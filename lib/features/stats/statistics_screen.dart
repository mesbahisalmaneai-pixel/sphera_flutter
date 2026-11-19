import 'package:flutter/material.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../intelligence/intelligence_screen.dart';
import '../shell/header_actions.dart';
import 'activity_center_screen.dart';
import 'games_statistics_screen.dart';
import 'grade_statistics_screen.dart';
import 'performance_center_screen.dart';
import 'profit_center_screen.dart';
import 'status_statistics_screen.dart';

/// Stats = Analytics Center: one card per section.
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  Widget _tile(BuildContext context, IconData icon, String title, String subtitle, Widget screen) => Card(
        child: ListTile(
          leading: Icon(icon, color: SpheraColors.gold, size: 28),
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
          trailing: Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen)),
        ),
      );

  Widget _section(String t) => Padding(
        padding: EdgeInsets.fromLTRB(4, 18, 0, 8),
        child: Text(t, style: TextStyle(color: SpheraColors.gold, fontWeight: FontWeight.w600, fontSize: 15)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.statistics),
        actions: [HeaderActions(), SizedBox(width: 4)],
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        _section(context.l10n.analyticsCenter),
        _tile(context, Icons.payments_outlined, context.l10n.profitCenter,
            context.l10n.profitCenterSub, ProfitCenterScreen()),
        _tile(context, Icons.timeline_rounded, context.l10n.activityCenter, context.l10n.activityCenterSub,
            ActivityCenterScreen()),
        _tile(context, Icons.speed_rounded, context.l10n.performanceCenter, context.l10n.performanceCenterSub,
            PerformanceCenterScreen()),
        _tile(context, Icons.auto_awesome_outlined, context.l10n.spheraIntelligence,
            context.l10n.spheraIntelligenceSub, IntelligenceScreen()),
        _section(context.l10n.statistics),
        _tile(context, Icons.workspace_premium_outlined, context.l10n.gradeStatistics,
            context.l10n.gradeStatisticsSub, GradeStatisticsScreen()),
        _tile(context, Icons.fact_check_outlined, context.l10n.statusStatistics,
            context.l10n.statusStatisticsSub, StatusStatisticsScreen()),
        _tile(context, Icons.sports_esports_outlined, context.l10n.gamesStatistics,
            context.l10n.gamesStatisticsSub, GamesStatisticsScreen()),
      ]),
    );
  }
}
