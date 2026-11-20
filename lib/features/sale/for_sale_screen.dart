import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/dashboard.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../games/game_account_detail_screen.dart';
import '../games/game_accounts_screen.dart' show statusColor;

String _days(DateTime t) {
  final d = DateTime.now().difference(t).inDays;
  if (d <= 0) return appL10n.today;
  return appL10n.daysCount(d);
}

/// Every account listed FOR SALE. Prices are never shown here: this is a
/// catalog you can read out or copy and send to a buyer.
class ForSaleScreen extends ConsumerStatefulWidget {
  const ForSaleScreen({super.key});
  @override
  ConsumerState<ForSaleScreen> createState() => _ForSaleScreenState();
}

class _ForSaleScreenState extends ConsumerState<ForSaleScreen> {
  String _query = '';
  String? _gameId; // null = all games

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(forSaleAccountsProvider);
    final games = {for (final g in ref.watch(activeGamesProvider).value ?? <Game>[]) g.id: g};

    // How many are listed per game (drives the filter chips).
    final perGame = <String, int>{};
    for (final a in all) {
      perGame[a.gameId] = (perGame[a.gameId] ?? 0) + 1;
    }
    final gameIds = perGame.keys.toList()
      ..sort((a, b) => (games[a]?.name ?? '').compareTo(games[b]?.name ?? ''));

    final q = _query.trim().toLowerCase();
    final shown = all.where((a) {
      if (_gameId != null && a.gameId != _gameId) return false;
      if (q.isEmpty) return true;
      return a.name.toLowerCase().contains(q) ||
          a.idCompte.toLowerCase().contains(q) ||
          (games[a.gameId]?.name ?? '').toLowerCase().contains(q);
    }).toList();

    // Waiting longest = oldest last change among listed accounts.
    GameAccount? waiting;
    for (final a in all) {
      if (waiting == null || a.updatedAt.isBefore(waiting.updatedAt)) waiting = a;
    }

    void copyList() {
      final b = StringBuffer('${context.l10n.accountsForSaleList(shown.length)}\n');
      for (final a in shown) {
        b.writeln('• ${games[a.gameId]?.name ?? ''} — ${a.name} (ID ${a.idCompte})');
      }
      Clipboard.setData(ClipboardData(text: b.toString().trimRight()));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.listCopied)));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.forSaleCount(all.length)),
        actions: [
          IconButton(
            tooltip: context.l10n.copyListNoPrices,
            icon: Icon(Icons.copy_rounded),
            onPressed: shown.isEmpty ? null : copyList,
          ),
        ],
      ),
      body: all.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    context.l10n.nothingForSale,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: SpheraColors.muted)),
              ),
            )
          : ListView(padding: EdgeInsets.all(16), children: [
              // ---- stats header ----
              Card(
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(children: [
                    _stat('${all.length}', context.l10n.listed),
                    _stat('${perGame.length}', context.l10n.gamesWord(perGame.length)),
                    _stat(waiting == null ? '-' : _days(waiting.updatedAt), context.l10n.longestWait),
                  ]),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: context.l10n.searchNameIdGame,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      label: Text(context.l10n.allCount(all.length)),
                      selected: _gameId == null,
                      onSelected: (_) => setState(() => _gameId = null),
                    ),
                  ),
                  for (final id in gameIds)
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 8),
                      child: ChoiceChip(
                        label: Text('${games[id]?.name ?? id} (${perGame[id]})'),
                        selected: _gameId == id,
                        onSelected: (_) => setState(() => _gameId = _gameId == id ? null : id),
                      ),
                    ),
                ]),
              ),
              SizedBox(height: 10),
              if (shown.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                      child: Text(context.l10n.noMatch, style: TextStyle(color: SpheraColors.muted))),
                )
              else
                for (final a in shown)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: games[a.gameId] == null
                          ? null
                          : GameImage(games[a.gameId]!,
                              kind: GameImageKind.account,
                              photoPath: a.photoPath,
                              width: 44,
                              height: 44,
                              radius: 8),
                      title: Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                          '${games[a.gameId]?.name ?? ''} · ID ${a.idCompte} · ${context.l10n.waitingFor(_days(a.updatedAt))}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                      trailing: Icon(Icons.chevron_right,
                          color: statusColor(GameAccountStatus.forSale)),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => GameAccountDetailScreen(accountId: a.id))),
                    ),
                  ),
            ]),
    );
  }

  Widget _stat(String value, String label) => Expanded(
        child: Column(children: [
          Text(value,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: SpheraColors.coming)),
          SizedBox(height: 2),
          Text(label, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ]),
      );
}
