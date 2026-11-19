import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../games/game_account_detail_screen.dart';
import '../games/game_accounts_screen.dart' show statusLabel;

/// Google boxes that have a given status (account + game).
class BoxStatusListScreen extends ConsumerWidget {
  const BoxStatusListScreen({super.key, required this.status});
  final BoxStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = {for (final a in ref.watch(googleAccountsProvider).value ?? <GoogleAccount>[]) a.id: a};
    final games = {for (final g in ref.watch(activeGamesProvider).value ?? <Game>[]) g.id: g};
    final boxes = (ref.watch(googleBoxesProvider).value ?? <GoogleGameBox>[])
        .where((b) => b.status == status && accounts.containsKey(b.googleAccountId) && games.containsKey(b.gameId))
        .toList()
      ..sort((a, b) => accounts[a.googleAccountId]!.email.compareTo(accounts[b.googleAccountId]!.email));
    final c = boxColor(status);

    return Scaffold(
      appBar: AppBar(title: Text('${boxLabel(status)} (${boxes.length})')),
      body: boxes.isEmpty
          ? Center(child: Text('Nothing here', style: TextStyle(color: SpheraColors.muted)))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: boxes.length,
              itemBuilder: (_, i) {
                final b = boxes[i];
                return Card(
                  child: ListTile(
                    leading: Container(width: 12, height: 12, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                    title: Text(accounts[b.googleAccountId]!.email, overflow: TextOverflow.ellipsis),
                    subtitle: Text(games[b.gameId]!.name, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                  ),
                );
              },
            ),
    );
  }
}

/// All gaming accounts (every game) with a given status.
class GameAccountsByStatusScreen extends ConsumerWidget {
  const GameAccountsByStatusScreen({super.key, required this.status});
  final GameAccountStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = {for (final g in ref.watch(activeGamesProvider).value ?? <Game>[]) g.id: g};
    final cur = ref.watch(currencyProvider);
    final list = (ref.watch(allGameAccountsProvider).value ?? <GameAccount>[])
        .where((a) => a.status == status && games.containsKey(a.gameId))
        .toList();
    final label = statusLabel(status);

    return Scaffold(
      appBar: AppBar(title: Text('$label (${list.length})')),
      body: list.isEmpty
          ? Center(child: Text('No accounts', style: TextStyle(color: SpheraColors.muted)))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final a = list[i];
                return Card(
                  child: ListTile(
                    title: Text(a.name, overflow: TextOverflow.ellipsis),
                    subtitle: Text(games[a.gameId]!.name, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                    trailing: Text(money(a.salePrice, currency: cur), style: TextStyle(color: SpheraColors.gold)),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => GameAccountDetailScreen(accountId: a.id))),
                  ),
                );
              },
            ),
    );
  }
}
