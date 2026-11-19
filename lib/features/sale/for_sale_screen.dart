import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/dashboard.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../games/game_account_detail_screen.dart';
import '../games/game_accounts_screen.dart' show statusColor;

String _days(DateTime t) {
  final d = DateTime.now().difference(t).inDays;
  if (d <= 0) return 'today';
  if (d == 1) return '1 day';
  return '$d days';
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
      final b = StringBuffer('Accounts for sale (${shown.length}):\n');
      for (final a in shown) {
        b.writeln('• ${games[a.gameId]?.name ?? ''} — ${a.name} (ID ${a.idCompte})');
      }
      Clipboard.setData(ClipboardData(text: b.toString().trimRight()));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('List copied (no prices)')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('For Sale (${all.length})'),
        actions: [
          IconButton(
            tooltip: 'Copy list without prices',
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
                    'Nothing is listed for sale.\nOpen an account and choose "List for sale".',
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
                    _stat('${all.length}', 'Listed'),
                    _stat('${perGame.length}', perGame.length == 1 ? 'Game' : 'Games'),
                    _stat(waiting == null ? '-' : _days(waiting.updatedAt), 'Longest wait'),
                  ]),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search name, ID or game',
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 38,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('All (${all.length})'),
                      selected: _gameId == null,
                      onSelected: (_) => setState(() => _gameId = null),
                    ),
                  ),
                  for (final id in gameIds)
                    Padding(
                      padding: EdgeInsets.only(right: 8),
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
                      child: Text('No match', style: TextStyle(color: SpheraColors.muted))),
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
                          '${games[a.gameId]?.name ?? ''} · ID ${a.idCompte} · waiting ${_days(a.updatedAt)}',
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
