import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/format.dart';
import '../../data/dashboard.dart';
import '../../data/insights.dart';
import '../../data/phone_notifications.dart';
import '../../data/settings.dart';
import 'notifications_screen.dart';

/// Wraps the signed-in app and keeps phone notifications in sync:
/// - when you leave the app, unread alerts not shown before become one phone notification;
/// - the daily summary is rescheduled whenever its text or time changes;
/// - tapping a notification opens the Notifications center.
class NotificationSync extends ConsumerStatefulWidget {
  const NotificationSync({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<NotificationSync> createState() => _NotificationSyncState();
}

class _NotificationSyncState extends ConsumerState<NotificationSync> with WidgetsBindingObserver {
  static const _pushedKey = 'notif_pushed';
  final _phone = PhoneNotifications.instance;
  int _handledOpens = 0;
  String? _scheduledKey;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _phone.openRequests.addListener(_openCenter);
    if (_phone.openRequests.value > 0) WidgetsBinding.instance.addPostFrameCallback((_) => _openCenter());
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncDaily());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _phone.openRequests.removeListener(_openCenter);
    _debounce?.cancel();
    super.dispose();
  }

  void _openCenter() {
    if (!mounted || _phone.openRequests.value == _handledOpens) return;
    _handledOpens = _phone.openRequests.value;
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const NotificationsScreen()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused || s == AppLifecycleState.hidden) _pushPending();
  }

  Future<void> _pushPending() async {
    final prefs = ref.read(notificationPrefsProvider);
    if (!prefs.enabled || !prefs.phone || ref.read(dashboardLoadingProvider)) return;
    final alerts = ref.read(notificationsProvider);
    final read = ref.read(readNotificationsProvider);
    final p = await SharedPreferences.getInstance();
    final pushed = (p.getStringList(_pushedKey) ?? const <String>[]).toSet();
    final fresh = [for (final i in alerts) if (!read.contains(i.id) && !pushed.contains(i.id)) i];
    if (fresh.isNotEmpty) await _phone.showAlerts(fresh);
    // Keep only ids that are still current, so the set never grows forever.
    final current = {for (final i in alerts) i.id};
    await p.setStringList(_pushedKey, current.intersection({...pushed, ...fresh.map((i) => i.id)}).toList());
  }

  void _scheduleSoon() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), _syncDaily);
  }

  Future<void> _syncDaily() async {
    if (!mounted || ref.read(dashboardLoadingProvider)) return;
    final prefs = ref.read(notificationPrefsProvider);
    final on = prefs.enabled && prefs.phone && prefs.daily;
    final kpis = ref.read(dashboardKpisProvider);
    final (title, body) = dailySummaryText(
      alerts: ref.read(notificationsProvider).length,
      netProfit: signedMoney(kpis.netProfit, currency: ref.read(currencyProvider)),
      accounts: kpis.total,
    );
    final key = on ? '${prefs.dailyMinutes}|$title|$body' : 'off';
    if (key == _scheduledKey) return;
    _scheduledKey = key;
    if (on) {
      await _phone.scheduleDaily(hour: prefs.dailyHour, minute: prefs.dailyMinute, title: title, body: body);
    } else {
      await _phone.cancelDaily();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(notificationPrefsProvider, (_, __) => _scheduleSoon());
    ref.listen(notificationsProvider, (_, __) => _scheduleSoon());
    ref.listen(dashboardKpisProvider, (_, __) => _scheduleSoon());
    ref.listen(currencyProvider, (_, __) => _scheduleSoon());
    return widget.child;
  }
}
