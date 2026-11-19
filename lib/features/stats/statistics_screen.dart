import 'package:flutter/material.dart';
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
        title: Text('Statistics'),
        actions: [HeaderActions(), SizedBox(width: 4)],
      ),
      body: ListView(padding: EdgeInsets.all(16), children: [
        _section('Analytics Center'),
        _tile(context, Icons.payments_outlined, 'Profit Center',
            'Sales, expenses, purchase & sale price, net profit', ProfitCenterScreen()),
        _tile(context, Icons.timeline_rounded, 'Activity Center', 'Activity log, filter by date & type',
            ActivityCenterScreen()),
        _tile(context, Icons.speed_rounded, 'Performance Center', 'Daily, weekly, monthly & goals',
            PerformanceCenterScreen()),
        _tile(context, Icons.auto_awesome_outlined, 'SPHERA Intelligence',
            'Offline analysis of your accounts', IntelligenceScreen()),
        _section('Statistics'),
        _tile(context, Icons.workspace_premium_outlined, 'Grade Statistics',
            'Bronze, Silver, Gold, Platinum, Diamond & Interdit', GradeStatisticsScreen()),
        _tile(context, Icons.fact_check_outlined, 'Status Statistics',
            'Google boxes and gaming accounts, each on its own', StatusStatisticsScreen()),
        _tile(context, Icons.sports_esports_outlined, 'Games Statistics',
            'Profit, counts & status per game', GamesStatisticsScreen()),
      ]),
    );
  }
}
