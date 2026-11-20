import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../../data/smart_tools.dart';

class _Item {
  const _Item({required this.key, required this.title, required this.subtitle, required this.leading});
  final String key;
  final String title;
  final String subtitle;
  final Widget leading;
}

/// A place for favourite, rare and high-value accounts (Google and gaming).
/// Tags are only labels: tagging never changes or removes the account itself.
class InventoryVaultScreen extends ConsumerStatefulWidget {
  const InventoryVaultScreen({super.key});

  @override
  ConsumerState<InventoryVaultScreen> createState() => _InventoryVaultScreenState();
}

class _InventoryVaultScreenState extends ConsumerState<InventoryVaultScreen> {
  VaultTag? _filter;

  void _tags(String key, String title) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _TagSheet(vaultKey: key, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vault = ref.watch(vaultProvider);
    final google = ref.watch(googleAccountsProvider).value ?? <GoogleAccount>[];
    final gameAccounts = ref.watch(allGameAccountsProvider).value ?? <GameAccount>[];
    final gameNames = {for (final g in ref.watch(allGamesProvider).value ?? <Game>[]) g.id: g.name};
    final cur = ref.watch(currencyProvider);

    final items = <String, _Item>{};
    for (final a in google) {
      items[vaultKeyGoogle(a.id)] = _Item(
        key: vaultKeyGoogle(a.id),
        title: a.email,
        subtitle: 'Google · ${gradeLabel(a.grade)}',
        leading: GradeMedal(a.grade, size: 38),
      );
    }
    for (final a in gameAccounts) {
      items[vaultKeyGame(a.id)] = _Item(
        key: vaultKeyGame(a.id),
        title: a.name.isEmpty ? a.idCompte : a.name,
        subtitle: '${gameNames[a.gameId] ?? appL10n.game} · ID ${a.idCompte} · ${appL10n.saleAmount(money(a.salePrice, currency: cur))}',
        leading: Icon(Icons.sports_esports_outlined, color: SpheraColors.gold, size: 32),
      );
    }

    int count(VaultTag t) => vault.entries.where((e) => items.containsKey(e.key) && e.value.contains(t)).length;

    final entries = vault.entries
        .where((e) => items.containsKey(e.key) && (_filter == null || e.value.contains(_filter)))
        .toList()
      ..sort((a, b) => items[a.key]!.title.toLowerCase().compareTo(items[b.key]!.title.toLowerCase()));

    // Picker lists: Google by email, gaming accounts by highest sale price first.
    final pickGoogle = [for (final a in google) items[vaultKeyGoogle(a.id)]!]
      ..sort((a, b) => a.title.compareTo(b.title));
    final sortedGame = [...gameAccounts]..sort((a, b) => b.salePrice.compareTo(a.salePrice));
    final pickGame = [for (final a in sortedGame) items[vaultKeyGame(a.id)]!];

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.inventoryVault)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => _Picker(
            google: pickGoogle,
            games: pickGame,
            onPick: (it) {
              Navigator.pop(ctx);
              _tags(it.key, it.title);
            },
          ),
        ),
        backgroundColor: SpheraColors.gold,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        icon: Icon(Icons.add),
        label: Text(context.l10n.addToVault),
      ),
      body: ListView(padding: EdgeInsets.fromLTRB(16, 8, 16, 96), children: [
        SizedBox(
          height: 44,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8),
              child: FilterChip(
                  label: Text(context.l10n.all), selected: _filter == null, onSelected: (_) => setState(() => _filter = null)),
            ),
            for (final t in VaultTag.values)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 8),
                child: FilterChip(
                  avatar: Icon(t.icon, size: 16),
                  label: Text('${t.label} (${count(t)})'),
                  selected: _filter == t,
                  onSelected: (_) => setState(() => _filter = t),
                ),
              ),
          ]),
        ),
        SizedBox(height: 8),
        if (entries.isEmpty)
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: SpheraColors.muted),
              SizedBox(height: 12),
              Text(vault.isEmpty ? context.l10n.vaultEmpty : context.l10n.nothingWithTag,
                  style: TextStyle(color: SpheraColors.muted)),
              if (vault.isEmpty) ...[
                SizedBox(height: 4),
                Text(context.l10n.vaultHint,
                    textAlign: TextAlign.center, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              ],
            ]),
          ),
        for (final e in entries)
          Card(
            margin: EdgeInsets.only(bottom: 10),
            child: ListTile(
              isThreeLine: true,
              leading: items[e.key]!.leading,
              title: Text(items[e.key]!.title, overflow: TextOverflow.ellipsis),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(items[e.key]!.subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                SizedBox(height: 4),
                Wrap(spacing: 10, children: [
                  for (final t in VaultTag.values)
                    if (e.value.contains(t))
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(t.icon, size: 14, color: SpheraColors.gold),
                        SizedBox(width: 4),
                        Text(t.label, style: TextStyle(color: SpheraColors.gold, fontSize: 12)),
                      ]),
                ]),
              ]),
              trailing: Icon(Icons.tune, color: SpheraColors.muted),
              onTap: () => _tags(e.key, items[e.key]!.title),
            ),
          ),
      ]),
    );
  }
}

class _TagSheet extends ConsumerWidget {
  const _TagSheet({required this.vaultKey, required this.title});
  final String vaultKey, title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(vaultProvider)[vaultKey] ?? <VaultTag>{};
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(title, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        for (final t in VaultTag.values)
          SwitchListTile(
            secondary: Icon(t.icon, color: SpheraColors.gold),
            title: Text(t.label),
            value: tags.contains(t),
            onChanged: (_) => ref.read(vaultProvider.notifier).toggle(vaultKey, t),
          ),
        SizedBox(height: 8),
      ]),
    );
  }
}

class _Picker extends StatefulWidget {
  const _Picker({required this.google, required this.games, required this.onPick});
  final List<_Item> google;
  final List<_Item> games;
  final void Function(_Item) onPick;

  @override
  State<_Picker> createState() => _PickerState();
}

class _PickerState extends State<_Picker> {
  bool _game = false;
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final source = _game ? widget.games : widget.google;
    final list = source.where((i) => '${i.title} ${i.subtitle}'.toLowerCase().contains(_q.toLowerCase())).toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: false, label: Text('Google')),
                  ButtonSegment(value: true, label: Text(context.l10n.gameAccountsSection)),
                ],
                selected: {_game},
                onSelectionChanged: (s) => setState(() => _game = s.first),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              decoration: InputDecoration(hintText: context.l10n.search, prefixIcon: Icon(Icons.search)),
              onChanged: (v) => setState(() => _q = v.trim()),
            ),
          ),
          if (_game)
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(context.l10n.highestSaleFirst,
                    style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              ),
            ),
          Expanded(
            child: list.isEmpty
                ? Center(child: Text(context.l10n.noAccount, style: TextStyle(color: SpheraColors.muted)))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: list[i].leading,
                      title: Text(list[i].title, overflow: TextOverflow.ellipsis),
                      subtitle: Text(list[i].subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                      onTap: () => widget.onPick(list[i]),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
