import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/sphera_logo.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../tools/inventory_vault_screen.dart';
import '../tools/security_center_screen.dart';
import 'notifications_settings_screen.dart';
import 'trash_screen.dart';

const kAppVersion = '1.0.0';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _title(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 22, 0, 8),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600)),
      );

  void _pickLanguage(BuildContext context, WidgetRef ref) {
    final current = ref.read(languageProvider);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(context.l10n.language, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          for (final e in kLanguages.entries)
            ListTile(
              title: Text(e.value),
              trailing: e.key == current ? Icon(Icons.check_circle, color: SpheraColors.gold) : null,
              onTap: () {
                ref.read(languageProvider.notifier).set(e.key);
                Navigator.pop(ctx);
              },
            ),
          SizedBox(height: 8),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final look = ref.watch(appearanceProvider);
    final lang = ref.watch(languageProvider);
    final notif = ref.watch(notificationPrefsProvider);
    final trashCount = (ref.watch(trashedGoogleAccountsProvider).value?.length ?? 0) +
        (ref.watch(trashedGameAccountsProvider).value?.length ?? 0);
    final platformDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final previewDark = switch (look.mode) {
      ThemeModeSetting.dark => true,
      ThemeModeSetting.light => false,
      ThemeModeSetting.system => platformDark,
    };

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.toolsSettings)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        _title(context.l10n.profileSecurity),
        Card(
          child: ListTile(
            leading: Icon(Icons.person_outline, color: SpheraColors.gold),
            title: Text(context.l10n.localMode),
            subtitle: Text(
                context.l10n.localModeSub),
            isThreeLine: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.shield_outlined, color: SpheraColors.gold),
            title: Text(context.l10n.securityCenter),
            subtitle: Text(context.l10n.protectionPrivacy),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SecurityCenterScreen())),
          ),
        ),
        _title(context.l10n.appearance),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(context.l10n.mode, style: TextStyle(color: SpheraColors.muted)),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeModeSetting>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                        value: ThemeModeSetting.dark,
                        icon: Icon(Icons.dark_mode_outlined, size: 18),
                        label: Text(context.l10n.dark)),
                    ButtonSegment(
                        value: ThemeModeSetting.light,
                        icon: Icon(Icons.light_mode_outlined, size: 18),
                        label: Text(context.l10n.light)),
                    ButtonSegment(
                        value: ThemeModeSetting.system,
                        icon: Icon(Icons.phone_android, size: 18),
                        label: Text(context.l10n.auto)),
                  ],
                  selected: {look.mode},
                  onSelectionChanged: (s) => ref.read(appearanceProvider.notifier).setMode(s.first),
                ),
              ),
              SizedBox(height: 18),
              Text(context.l10n.style, style: TextStyle(color: SpheraColors.muted)),
              SizedBox(height: 8),
              Wrap(spacing: 10, runSpacing: 10, children: [
                for (final e in kThemeStyles.entries)
                  _StyleTile(
                    palette: paletteFor(e.key, dark: previewDark),
                    name: e.value,
                    selected: look.style == e.key,
                    onTap: () => ref.read(appearanceProvider.notifier).setStyle(e.key),
                  ),
              ]),
              SizedBox(height: 6),
              Text(context.l10n.autoFollowsPhone,
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            ]),
          ),
        ),
        _title(context.l10n.language),
        Card(
          child: ListTile(
            leading: Icon(Icons.language, color: SpheraColors.gold),
            title: Text(context.l10n.language),
            subtitle: Text(kLanguages[lang] ?? 'English'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => _pickLanguage(context, ref),
          ),
        ),
        _title(context.l10n.notifications),
        Card(
          child: ListTile(
            leading: Icon(Icons.notifications_outlined, color: SpheraColors.gold),
            title: Text(context.l10n.notifications),
            subtitle: Text(!notif.enabled
                ? context.l10n.off
                : (notif.reminders ? context.l10n.onRemindersOn : context.l10n.onRemindersOff)),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => NotificationsSettingsScreen())),
          ),
        ),
        _title(context.l10n.currency),
        Card(child: Padding(padding: EdgeInsets.all(16), child: _CurrencySection())),
        _title(context.l10n.data),
        Card(
          child: ListTile(
            leading: Icon(Icons.delete_outline, color: SpheraColors.gold),
            title: Text(context.l10n.trash),
            subtitle: Text(trashCount == 0 ? context.l10n.empty : context.l10n.itemsCount(trashCount)),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TrashScreen())),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.inventory_2_outlined, color: SpheraColors.gold),
            title: Text(context.l10n.inventoryVault),
            subtitle: Text(context.l10n.storedItems),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => InventoryVaultScreen())),
          ),
        ),
        _title(context.l10n.aboutSphera),
        Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              SpheraLogo(height: 64),
              SizedBox(height: 12),
              Text('SPHERA',
                  style: TextStyle(color: SpheraColors.gold, fontSize: 20, letterSpacing: 5, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Text(context.l10n.version(kAppVersion), style: TextStyle(color: SpheraColors.muted)),
              SizedBox(height: 8),
              Text(context.l10n.aboutText,
                  textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _StyleTile extends StatelessWidget {
  const _StyleTile({required this.palette, required this.name, required this.selected, required this.onTap});
  final SpheraPalette palette;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 96,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: palette.black,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? SpheraColors.gold : palette.border, width: selected ? 2 : 1),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _dot(palette.gold),
            SizedBox(width: 4),
            _dot(palette.surface, ring: palette.border),
            SizedBox(width: 4),
            _dot(palette.goldSoft),
          ]),
          SizedBox(height: 8),
          Text(name, style: TextStyle(color: palette.ivory, fontSize: 12, fontWeight: FontWeight.w600)),
          if (selected) Icon(Icons.check_circle, size: 14, color: SpheraColors.gold),
        ]),
      ),
    );
  }

  Widget _dot(Color c, {Color? ring}) => Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: ring == null ? null : Border.all(color: ring)),
      );
}

class _CurrencySection extends ConsumerStatefulWidget {
  const _CurrencySection();
  @override
  ConsumerState<_CurrencySection> createState() => _CurrencySectionState();
}

class _CurrencySectionState extends ConsumerState<_CurrencySection> {
  bool _loading = false;

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final err = await ref.read(currencyProvider.notifier).refreshRates();
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(err ?? context.l10n.ratesUpdated)));
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final cur = ref.watch(currencyProvider);
    final isBase = cur.code == 'DH';
    final at = cur.updatedAt;
    final when = at == null
        ? ''
        : '${at.year}-${_two(at.month)}-${_two(at.day)} ${_two(at.hour)}:${_two(at.minute)}';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 8, children: [
        for (final c in kCurrencies)
          ChoiceChip(
            label: Text(c),
            selected: cur.code == c,
            selectedColor: SpheraColors.gold.withValues(alpha: 0.3),
            onSelected: (_) => ref.read(currencyProvider.notifier).set(c),
          ),
      ]),
      SizedBox(height: 10),
      Text(
        isBase
            ? context.l10n.dhIsBase
            : '1 DH = ${cur.rate.toStringAsFixed(4)} ${cur.code}   (1 ${cur.code} = ${(1 / cur.rate).toStringAsFixed(2)} DH)',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      SizedBox(height: 4),
      Text(
        cur.source == 'live'
            ? context.l10n.liveRate(when)
            : context.l10n.approximateRate,
        style: TextStyle(color: SpheraColors.muted, fontSize: 12),
      ),
      SizedBox(height: 4),
      Text(
        context.l10n.conversionNote,
        style: TextStyle(color: SpheraColors.muted, fontSize: 12),
      ),
      SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: _loading ? null : _refresh,
        icon: _loading
            ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(Icons.refresh, size: 18),
        label: Text(context.l10n.updateRates),
      ),
    ]);
  }
}
