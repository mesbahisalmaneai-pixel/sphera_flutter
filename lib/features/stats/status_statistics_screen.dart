import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../core/tile_grid.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import 'status_lists.dart';

/// Two separate status systems:
///  1) Google game boxes: Done / Not Yet / Coming
///  2) Gaming accounts: Active / For Sale
class StatusStatisticsScreen extends ConsumerWidget {
  const StatusStatisticsScreen({super.key});

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 18, 0, 10),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  Widget _statusCard(BuildContext context, String label, int n, Color c, Widget target) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => target)),
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                SizedBox(width: 8),
                Text(label, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
              ]),
              SizedBox(height: 4),
              Text('$n', style: TextStyle(color: c, fontSize: 26, fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      );

  Widget _grid(List<Widget> children) => TileGrid(columns: 2, children: children);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final g = ref.watch(googleStatsProvider);
    final games = ref.watch(gameStatsProvider);
    final active = games.fold<int>(0, (t, s) => t + s.active);
    final sell = games.fold<int>(0, (t, s) => t + s.sell);
    const boxStatuses = [BoxStatus.done, BoxStatus.notYet, BoxStatus.coming];

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.statusStatistics)),
      body: ListView(padding: EdgeInsets.all(16), children: [
        _section(context.l10n.googlePlayBoxes),
        _grid([
          for (final s in boxStatuses)
            _statusCard(context, boxLabel(s), g.byStatus[s] ?? 0, boxColor(s), BoxStatusListScreen(status: s)),
        ]),
        _section(context.l10n.gamingAccounts),
        _grid([
          _statusCard(context, appL10n.statusActive, active, SpheraColors.done,
              GameAccountsByStatusScreen(status: GameAccountStatus.active)),
          _statusCard(context, appL10n.statusSold, sell, SpheraColors.danger,
              GameAccountsByStatusScreen(status: GameAccountStatus.sell)),
        ]),
      ]),
    );
  }
}
