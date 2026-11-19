import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../../data/smart_tools.dart';
import '../games/game_accounts_screen.dart';
import '../google/google_account_form.dart';

/// Finds accounts that look like duplicates. It only SHOWS them: nothing is
/// deleted or merged automatically. Open an account to review or edit it.
class DuplicateScannerScreen extends ConsumerWidget {
  const DuplicateScannerScreen({super.key});

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 20, 0, 0),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gGroups = ref.watch(duplicateGroupsProvider);
    final aGroups = ref.watch(gameDuplicateGroupsProvider);
    final dismissed = ref.watch(dismissedDuplicatesProvider);
    final meta = ref.watch(accountMetaProvider);
    final games = {for (final g in ref.watch(allGamesProvider).value ?? <Game>[]) g.id: g};
    final cur = ref.watch(currencyProvider);
    final notifier = ref.read(dismissedDuplicatesProvider.notifier);
    final none = gGroups.isEmpty && aGroups.isEmpty;

    return Scaffold(
      appBar: AppBar(title: Text('Duplicate Scanner')),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.content_copy_outlined, color: SpheraColors.gold),
                SizedBox(width: 10),
                Text('How matching works', style: TextStyle(fontWeight: FontWeight.w600)),
              ]),
              SizedBox(height: 8),
              Text(
                'Google accounts: same Email (ignores case, spaces, and for Gmail dots and "+tags").\n'
                'Game accounts: same Account ID inside the same game.\n'
                'Phone matching is not available: phone numbers are not stored yet.',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12),
              ),
              SizedBox(height: 8),
              Row(children: [
                Icon(Icons.verified_user_outlined, size: 16, color: SpheraColors.done),
                SizedBox(width: 6),
                Expanded(
                  child: Text('Nothing is deleted or merged automatically. You review every account yourself.',
                      style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                ),
              ]),
            ]),
          ),
        ),
        if (none)
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(children: [
              Icon(Icons.check_circle_outline, size: 48, color: SpheraColors.done),
              SizedBox(height: 12),
              Text('No duplicates found', style: TextStyle(color: SpheraColors.muted)),
            ]),
          ),
        if (gGroups.isNotEmpty) _section('Google accounts'),
        for (final g in gGroups) _googleGroup(context, g, meta, notifier),
        if (aGroups.isNotEmpty) _section('Game accounts'),
        for (final g in aGroups) _gameGroup(context, g, games[g.gameId], cur, notifier),
        if (dismissed.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: notifier.clear,
              child: Text('Show ${dismissed.length} dismissed again'),
            ),
          ),
      ]),
    );
  }

  void _undoBar(BuildContext context, DismissedDuplicatesNotifier n, String key) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Marked as not duplicates'),
        action: SnackBarAction(label: 'UNDO', onPressed: () => n.restore(key)),
      ));
  }

  Widget _header(String title, String sub) => Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.warning_amber_rounded, size: 18, color: SpheraColors.coming),
            SizedBox(width: 8),
            Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600))),
          ]),
          Padding(
            padding: EdgeInsets.only(left: 26, top: 2),
            child: Text(sub, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          ),
        ]),
      );

  Widget _googleGroup(BuildContext context, DuplicateGroup g, Map<String, AccountMeta> meta,
      DismissedDuplicatesNotifier notifier) {
    return Card(
      margin: EdgeInsets.only(top: 12),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 12, 8, 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _header('${g.accounts.length} similar accounts', g.key),
          for (final a in g.accounts)
            ListTile(
              dense: true,
              leading: GradeMedal(a.grade, size: 34),
              title: Text(a.email, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${gradeLabel(a.grade)} · ${meta[a.id]?.boxesSet ?? 0} boxes set · added ${fmtDate(a.createdAt)}',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12),
              ),
              trailing: IconButton(
                tooltip: 'Open to review',
                icon: Icon(Icons.edit_outlined, color: SpheraColors.gold),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => GoogleAccountForm(
                        account: a, initialStatuses: meta[a.id]?.statuses ?? const {}))),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                notifier.dismiss(g.key);
                _undoBar(context, notifier, g.key);
              },
              child: Text('Not duplicates'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _gameGroup(BuildContext context, GameDuplicateGroup g, Game? game, CurrencySettings cur,
      DismissedDuplicatesNotifier notifier) {
    return Card(
      margin: EdgeInsets.only(top: 12),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 12, 8, 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _header('${g.accounts.length} accounts with ID ${g.idCompte}', game?.name ?? 'Unknown game'),
          for (final a in g.accounts)
            ListTile(
              dense: true,
              leading: Icon(Icons.sports_esports_outlined, color: SpheraColors.gold),
              title: Text(a.name.isEmpty ? a.idCompte : a.name, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                '${a.status.name.toUpperCase()} · buy ${money(a.purchasePrice, currency: cur)} → '
                'sell ${money(a.salePrice, currency: cur)} · ${fmtDate(a.createdAt)}',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12),
              ),
            ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (game != null)
              TextButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => GameAccountsScreen(game: game))),
                child: Text('Open game'),
              ),
            TextButton(
              onPressed: () {
                notifier.dismiss(g.key);
                _undoBar(context, notifier, g.key);
              },
              child: Text('Not duplicates'),
            ),
          ]),
        ]),
      ),
    );
  }
}
