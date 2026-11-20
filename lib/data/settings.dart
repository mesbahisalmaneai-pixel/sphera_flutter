import '../core/l10n.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ======================= Currency =======================

/// Amounts are stored in DH (MAD). Other currencies are shown by converting
/// with the saved exchange rate.
const kCurrencies = ['DH', 'USD', 'EUR'];

/// Approximate fallback rates (units of the currency per 1 DH), used until live
/// rates are downloaded. Mid-2026 market level, NOT live.
const kDefaultRates = {'USD': 0.107, 'EUR': 0.092};

class CurrencySettings {
  const CurrencySettings({required this.code, required this.rates, this.updatedAt, required this.source});
  final String code; // DH | USD | EUR
  final Map<String, double> rates; // per 1 DH
  final DateTime? updatedAt;
  final String source; // 'default' | 'live'

  /// How many [code] units 1 DH is worth.
  double get rate => code == 'DH' ? 1.0 : (rates[code] ?? 1.0);

  double toDisplay(double storedDh) => storedDh * rate;
  double toBase(double shown) => rate == 0 ? shown : shown / rate;

  CurrencySettings copyWith({String? code, Map<String, double>? rates, DateTime? updatedAt, String? source}) =>
      CurrencySettings(
          code: code ?? this.code,
          rates: rates ?? this.rates,
          updatedAt: updatedAt ?? this.updatedAt,
          source: source ?? this.source);
}

class CurrencyNotifier extends Notifier<CurrencySettings> {
  @override
  CurrencySettings build() {
    _load();
    return const CurrencySettings(code: 'DH', rates: kDefaultRates, source: 'default');
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    var code = p.getString('currency') ?? 'DH';
    if (code == 'MAD') code = 'DH';
    if (!kCurrencies.contains(code)) code = 'DH';
    final rates = Map<String, double>.of(kDefaultRates);
    var source = 'default';
    DateTime? at;
    final raw = p.getString('rates');
    if (raw != null) {
      try {
        final m = (jsonDecode(raw) as Map).cast<String, dynamic>();
        for (final c in kDefaultRates.keys) {
          final v = m[c];
          if (v is num && v > 0) rates[c] = v.toDouble();
        }
        source = p.getString('rates_source') ?? 'default';
        final t = p.getString('rates_updated');
        at = t == null ? null : DateTime.tryParse(t);
      } catch (_) {}
    }
    state = CurrencySettings(code: code, rates: rates, updatedAt: at, source: source);
  }

  Future<void> set(String code) async {
    state = state.copyWith(code: code);
    final p = await SharedPreferences.getInstance();
    await p.setString('currency', code);
  }

  /// Downloads live rates (needs internet). Returns null on success, or an error message.
  Future<String?> refreshRates() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final req = await client.getUrl(Uri.parse('https://open.er-api.com/v6/latest/MAD'));
      final res = await req.close().timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) return appL10n.ratesServerError(res.statusCode);
      final body = await res.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      if (json['result'] != 'success') return appL10n.ratesUnavailable;
      final r = (json['rates'] as Map).cast<String, dynamic>();
      final rates = <String, double>{
        for (final c in kDefaultRates.keys) c: (r[c] as num).toDouble(),
      };
      final now = DateTime.now();
      final p = await SharedPreferences.getInstance();
      await p.setString('rates', jsonEncode(rates));
      await p.setString('rates_updated', now.toIso8601String());
      await p.setString('rates_source', 'live');
      state = state.copyWith(rates: rates, updatedAt: now, source: 'live');
      return null;
    } catch (_) {
      return appL10n.ratesNoInternet;
    } finally {
      client.close();
    }
  }
}

final currencyProvider = NotifierProvider<CurrencyNotifier, CurrencySettings>(CurrencyNotifier.new);

// ======================= Appearance =======================

enum ThemeModeSetting { dark, light, system }

class Appearance {
  const Appearance({this.style = 'gold', this.mode = ThemeModeSetting.dark});
  final String style;
  final ThemeModeSetting mode;
}

class AppearanceNotifier extends Notifier<Appearance> {
  @override
  Appearance build() {
    _load();
    return const Appearance();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final style = p.getString('theme_style') ?? 'gold';
    final modeName = p.getString('theme_mode') ?? 'dark';
    final mode = ThemeModeSetting.values.firstWhere((m) => m.name == modeName, orElse: () => ThemeModeSetting.dark);
    state = Appearance(style: style, mode: mode);
  }

  Future<void> setStyle(String style) async {
    state = Appearance(style: style, mode: state.mode);
    (await SharedPreferences.getInstance()).setString('theme_style', style);
  }

  Future<void> setMode(ThemeModeSetting mode) async {
    state = Appearance(style: state.style, mode: mode);
    (await SharedPreferences.getInstance()).setString('theme_mode', mode.name);
  }
}

final appearanceProvider = NotifierProvider<AppearanceNotifier, Appearance>(AppearanceNotifier.new);

// ======================= Language =======================

/// Language code -> name shown in its own language.
const kLanguages = {
  'ar': 'العربية',
  'fr': 'Français',
  'en': 'English',
};

class LanguageNotifier extends Notifier<String> {
  @override
  String build() {
    _load();
    return 'en';
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final code = p.getString('language') ?? 'en';
    state = kLanguages.containsKey(code) ? code : 'en';
  }

  Future<void> set(String code) async {
    if (!kLanguages.containsKey(code)) return;
    state = code;
    (await SharedPreferences.getInstance()).setString('language', code);
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, String>(LanguageNotifier.new);

// ======================= Notifications =======================

class NotificationPrefs {
  const NotificationPrefs({
    this.enabled = true,
    this.reminders = true,
    this.phone = false,
    this.daily = true,
    this.dailyMinutes = 20 * 60,
  });
  final bool enabled; // master switch (in-app center + phone)
  final bool reminders;

  /// Show alerts as phone (system) notifications. Off until the user allows it.
  final bool phone;

  /// Daily summary on the phone at [dailyMinutes] after midnight.
  final bool daily;
  final int dailyMinutes;

  int get dailyHour => dailyMinutes ~/ 60;
  int get dailyMinute => dailyMinutes % 60;

  NotificationPrefs copyWith({bool? enabled, bool? reminders, bool? phone, bool? daily, int? dailyMinutes}) =>
      NotificationPrefs(
        enabled: enabled ?? this.enabled,
        reminders: reminders ?? this.reminders,
        phone: phone ?? this.phone,
        daily: daily ?? this.daily,
        dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      );
}

class NotificationPrefsNotifier extends Notifier<NotificationPrefs> {
  @override
  NotificationPrefs build() {
    _load();
    return const NotificationPrefs();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = NotificationPrefs(
      enabled: p.getBool('notif_enabled') ?? true,
      reminders: p.getBool('notif_reminders') ?? true,
      phone: p.getBool('notif_phone') ?? false,
      daily: p.getBool('notif_daily') ?? true,
      dailyMinutes: p.getInt('notif_daily_minutes') ?? 20 * 60,
    );
  }

  Future<void> setEnabled(bool v) async {
    state = state.copyWith(enabled: v);
    (await SharedPreferences.getInstance()).setBool('notif_enabled', v);
  }

  Future<void> setReminders(bool v) async {
    state = state.copyWith(reminders: v);
    (await SharedPreferences.getInstance()).setBool('notif_reminders', v);
  }

  Future<void> setPhone(bool v) async {
    state = state.copyWith(phone: v);
    (await SharedPreferences.getInstance()).setBool('notif_phone', v);
  }

  Future<void> setDaily(bool v) async {
    state = state.copyWith(daily: v);
    (await SharedPreferences.getInstance()).setBool('notif_daily', v);
  }

  Future<void> setDailyTime(int hour, int minute) async {
    state = state.copyWith(dailyMinutes: hour * 60 + minute);
    (await SharedPreferences.getInstance()).setInt('notif_daily_minutes', state.dailyMinutes);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsNotifier, NotificationPrefs>(NotificationPrefsNotifier.new);
