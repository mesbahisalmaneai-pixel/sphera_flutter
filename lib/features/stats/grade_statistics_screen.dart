import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';
import 'stats_drilldown.dart';

/// Number of Google accounts per grade (Bronze ... Diamond + Interdit).
class GradeStatisticsScreen extends ConsumerWidget {
  const GradeStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(googleStatsProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Grade Statistics')),
      body: ListView(padding: EdgeInsets.all(16), children: [
        Text('${st.total} Google account${st.total == 1 ? '' : 's'}',
            style: TextStyle(color: SpheraColors.muted)),
        SizedBox(height: 14),
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
      ]),
    );
  }
}
