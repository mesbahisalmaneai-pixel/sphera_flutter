import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/format.dart';
import '../../core/game_logo.dart';
import '../../core/theme.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import 'stats_drilldown.dart';

/// Per-game statistics (the former "Games" tab).
class GamesStatisticsScreen extends ConsumerWidget {
  const GamesStatisticsScreen({super.key});

  Widget _section(String title) => Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: Text(title, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  Widget _pill(String label, int n, Color c, VoidCallback onTap) => InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: c.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: c.withValues(alpha: 0.7))),
          child: Text('$label  $n', style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(gameStatsProvider);
    final cur = ref.watch(currencyProvider);

    Widget body;
    if (stats.isEmpty) {
      body = Center(child: Text(context.l10n.noGamesYet, style: TextStyle(color: SpheraColors.muted)));
    } else {
      final maxCount = stats.fold<int>(1, (m, s) => s.count > m ? s.count : m);
      final total = stats.fold<double>(0, (t, s) => t + s.profit);
      void openGame(game, [String initial = 'all']) => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => GameStatusAccountsScreen(game: game, initial: initial)));

      body = ListView(padding: EdgeInsets.all(16), children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(context.l10n.totalProfitLoss, style: TextStyle(color: SpheraColors.muted)),
              Text(signedMoney(total, currency: cur),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: total >= 0 ? SpheraColors.done : SpheraColors.danger)),
            ]),
          ),
        ),
        _section(context.l10n.pricePerGame),
        for (final s in stats)
          Card(
            child: ListTile(
              leading: GameLogo(s.game, size: 44),
              title: Text(s.game.name),
              subtitle: Text(context.l10n.accountsIncluded(s.count),
                  style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              trailing: Text(signedMoney(s.profit, currency: cur),
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: s.profit >= 0 ? SpheraColors.done : SpheraColors.danger)),
              onTap: () => openGame(s.game),
            ),
          ),
        _section(context.l10n.accountsPerGame),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              for (final s in stats)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Row(children: [
                    SizedBox(width: 110, child: Text(s.game.name, overflow: TextOverflow.ellipsis)),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: s.count / maxCount,
                          minHeight: 10,
                          backgroundColor: SpheraColors.surfaceHigh,
                          color: SpheraColors.gold,
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 36,
                        child: Text('${s.count}',
                            textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600))),
                  ]),
                ),
            ]),
          ),
        ),
        _section(context.l10n.statusPerGame),
        for (final s in stats)
          Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Row(children: [
                Expanded(child: Text(s.game.name, style: TextStyle(fontWeight: FontWeight.w600))),
                _pill(appL10n.statusActive, s.active, SpheraColors.done, () => openGame(s.game, 'active')),
                SizedBox(width: 8),
                _pill(appL10n.statusSold, s.sell, SpheraColors.danger, () => openGame(s.game, 'sell')),
              ]),
            ),
          ),
      ]);
    }

    return Scaffold(appBar: AppBar(title: Text(context.l10n.gamesStatistics)), body: body);
  }
}
