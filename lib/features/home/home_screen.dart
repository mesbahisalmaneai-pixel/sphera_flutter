import 'package:flutter/material.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../shell/header_actions.dart';
import 'dashboard_widgets.dart';

/// Home = dashboard: Quick Actions, 4 KPIs, Performance graph, Recent Activity.
/// Every number comes from the Drift database through live streams, so the
/// screen refreshes by itself whenever data changes (no manual refresh/timer).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, c) {
          final wide = c.maxWidth >= 720; // tablets / landscape: 2 columns
          return ListView(
            padding: EdgeInsets.all(20),
            children: [
              Row(children: [
                LogoForSaleButton(),
                SizedBox(width: 10),
                // Takes the room left by the logo and the buttons, so a large
                // system font shrinks the title instead of pushing the buttons out.
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text('SPHERA',
                          style: TextStyle(
                              color: SpheraColors.gold,
                              fontSize: 20,
                              letterSpacing: 5,
                              fontWeight: FontWeight.w600)),
                    ),
                    Text(context.l10n.welcomeBack,
                        maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: SpheraColors.muted)),
                  ]),
                ),
                HeaderActions(),
              ]),
              SizedBox(height: 20),
              QuickActions(),
              SizedBox(height: 12),
              KpiGrid(),
              SizedBox(height: 16),
              if (wide)
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 2, child: PerformanceCard()),
                  SizedBox(width: 16),
                  Expanded(flex: 1, child: RecentActivityCard()),
                ])
              else ...[
                PerformanceCard(),
                SizedBox(height: 16),
                RecentActivityCard(),
              ],
            ],
          );
        }),
      ),
    );
  }
}
