import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/format.dart';
import '../../core/game_logo.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import '../../data/settings.dart';
import '../common/coming_soon_screen.dart';
import '../stats/stats_drilldown.dart';
import '../shell/header_actions.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Statistics'),
          actions: [HeaderActions(), SizedBox(width: 4)],
          bottom: TabBar(
            indicatorColor: SpheraColors.gold,
            labelColor: SpheraColors.gold,
            tabs: [Tab(text: 'Google Play'), Tab(text: 'Games')],
          ),
        ),
        body: TabBarView(children: [_GoogleTab(), _GamesTab()]),
      ),
    );
  }
}

Widget _section(String title) => Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Text(title,
          style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
    );

Widget _centerCard(BuildContext context, IconData icon, String title, String subtitle) => Card(
      child: ListTile(
        leading: Icon(icon, color: SpheraColors.gold),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        trailing: Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ComingSoonScreen(title: title, icon: icon))),
      ),
    );

List<Widget> _centers(BuildContext context) => [
      _section('Centers'),
      _centerCard(context, Icons.payments_outlined, 'Profit Center', 'Detailed profit & loss'),
      _centerCard(context, Icons.timeline_rounded, 'Activity Center', 'Recent activity & trends'),
    ];

class _GoogleTab extends ConsumerWidget {
  const _GoogleTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(googleStatsProvider);
    return ListView(padding: EdgeInsets.all(16), children: [
      Text('${st.total} Google account${st.total == 1 ? '' : 's'}',
          style: TextStyle(color: SpheraColors.muted)),
      _section('Grade statistics'),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
        children: [
          for (final g in Grade.values)
            Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => GradeAccountsScreen(grade: g))),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GradeMedal(g, size: 40),
                  SizedBox(height: 6),
                  Text('${st.byGrade[g]}',
                      style: TextStyle(color: gradeColor(g), fontSize: 22, fontWeight: FontWeight.w700)),
                  Text(gradeLabel(g), style: TextStyle(color: SpheraColors.muted, fontSize: 11)),
                ]),
              ),
            ),
        ],
      ),
      _section('Status statistics (game boxes)'),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.9,
        children: [
          for (final s in BoxStatus.values)
            Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: boxColor(s), shape: BoxShape.circle)),
                    SizedBox(width: 8),
                    Text(boxLabel(s), style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
                  ]),
                  SizedBox(height: 4),
                  Text('${st.byStatus[s]}',
                      style: TextStyle(color: boxColor(s), fontSize: 26, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
        ],
      ),
      ..._centers(context),
    ]);
  }
}

class _GamesTab extends ConsumerWidget {
  const _GamesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(gameStatsProvider);
    final cur = ref.watch(currencyProvider);
    if (stats.isEmpty) {
      return Center(child: Text('No games yet', style: TextStyle(color: SpheraColors.muted)));
    }
    final maxCount = stats.fold<int>(1, (m, s) => s.count > m ? s.count : m);
    final total = stats.fold<double>(0, (t, s) => t + s.profit);

    return ListView(padding: EdgeInsets.all(16), children: [
      Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total profit / loss', style: TextStyle(color: SpheraColors.muted)),
            Text(signedMoney(total, currency: cur),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: total >= 0 ? SpheraColors.done : SpheraColors.danger)),
          ]),
        ),
      ),
      _section('Price per game'),
      for (final s in stats)
        Card(
          child: ListTile(
            leading: GameLogo(s.game, size: 44),
            title: Text(s.game.name),
            subtitle: Text('${s.count} account${s.count == 1 ? '' : 's'} included',
                style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
            trailing: Text(signedMoney(s.profit, currency: cur),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: s.profit >= 0 ? SpheraColors.done : SpheraColors.danger)),
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => GameStatusAccountsScreen(game: s.game))),
          ),
        ),
      _section('Number of accounts per game'),
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
                      child: Text('${s.count}', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.w600))),
                ]),
              ),
          ]),
        ),
      ),
      _section('Account status per game'),
      for (final s in stats)
        Card(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Row(children: [
              Expanded(child: Text(s.game.name, style: TextStyle(fontWeight: FontWeight.w600))),
              _pill('ACTIVE', s.active, SpheraColors.done, () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GameStatusAccountsScreen(game: s.game, initial: 'active')))),
              SizedBox(width: 8),
              _pill('SOLD', s.sell, SpheraColors.danger, () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GameStatusAccountsScreen(game: s.game, initial: 'sell')))),
            ]),
          ),
        ),
      ..._centers(context),
    ]);
  }

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
}
