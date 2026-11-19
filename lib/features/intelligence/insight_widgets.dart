import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/insights.dart';
import '../achievements/achievements_screen.dart';
import '../arena/arena_screen.dart';
import '../games/game_account_form.dart';
import '../games/games_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/notifications_settings_screen.dart';
import '../settings/settings_screen.dart';
import '../settings/trash_screen.dart';
import '../stats/activity_center_screen.dart';
import '../stats/games_statistics_screen.dart';
import '../stats/grade_statistics_screen.dart';
import '../stats/status_statistics_screen.dart';
import '../tools/inventory_vault_screen.dart';
import '../tools/smart_organizer_screen.dart';
import '../google/google_accounts_screen.dart';
import '../sale/for_sale_screen.dart';
import '../stats/performance_center_screen.dart';
import '../stats/profit_center_screen.dart';
import '../tools/duplicate_scanner_screen.dart';
import '../tools/security_center_screen.dart';

Color insightColor(InsightLevel l) => switch (l) {
      InsightLevel.good => SpheraColors.done,
      InsightLevel.info => SpheraColors.gold,
      InsightLevel.warning => SpheraColors.danger,
    };

Widget _screenFor(InsightTarget t) => switch (t) {
      InsightTarget.profit => const ProfitCenterScreen(),
      InsightTarget.performance => const PerformanceCenterScreen(),
      InsightTarget.forSale => const ForSaleScreen(),
      InsightTarget.duplicates => const DuplicateScannerScreen(),
      InsightTarget.security => const SecurityCenterScreen(),
      InsightTarget.googleAccounts => const GoogleAccountsScreen(),
      InsightTarget.addAccount => const GameAccountForm(),
      InsightTarget.activity => const ActivityCenterScreen(),
      InsightTarget.gradeStats => const GradeStatisticsScreen(),
      InsightTarget.statusStats => const StatusStatisticsScreen(),
      InsightTarget.gamesStats => const GamesStatisticsScreen(),
      InsightTarget.games => const GamesScreen(),
      InsightTarget.trash => const TrashScreen(),
      InsightTarget.organizer => const SmartOrganizerScreen(),
      InsightTarget.vault => const InventoryVaultScreen(),
      InsightTarget.arena => const ArenaScreen(),
      InsightTarget.achievements => const AchievementsScreen(),
      InsightTarget.settings => const SettingsScreen(),
      InsightTarget.notifications => const NotificationsScreen(),
      InsightTarget.notificationSettings => const NotificationsSettingsScreen(),
    };

/// Button label for a destination ("Open Profit Center").
String targetLabel(InsightTarget t) => switch (t) {
      InsightTarget.profit => 'Profit Center',
      InsightTarget.performance => 'Performance Center',
      InsightTarget.forSale => 'For Sale',
      InsightTarget.duplicates => 'Duplicate Scanner',
      InsightTarget.security => 'Security Center',
      InsightTarget.googleAccounts => 'Google Accounts',
      InsightTarget.addAccount => 'Add Account',
      InsightTarget.activity => 'Activity Center',
      InsightTarget.gradeStats => 'Grade Statistics',
      InsightTarget.statusStats => 'Status Statistics',
      InsightTarget.gamesStats => 'Games Statistics',
      InsightTarget.games => 'Games',
      InsightTarget.trash => 'Trash',
      InsightTarget.organizer => 'Smart Organizer',
      InsightTarget.vault => 'Inventory Vault',
      InsightTarget.arena => 'Tournament Arena',
      InsightTarget.achievements => 'Achievements',
      InsightTarget.settings => 'Settings',
      InsightTarget.notifications => 'Notifications',
      InsightTarget.notificationSettings => 'Notification settings',
    };

void openTarget(BuildContext context, InsightTarget t) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => _screenFor(t)));

void openInsight(BuildContext context, Insight i) {
  final t = i.target;
  if (t != null) openTarget(context, t);
}

/// One insight as a card. [unread] adds a dot (Notifications center).
class InsightTile extends StatelessWidget {
  const InsightTile(this.insight, {super.key, this.unread = false});
  final Insight insight;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final color = insightColor(insight.level);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(insight.icon, color: color, size: 20),
        ),
        title: Row(children: [
          Expanded(
              child: Text(insight.title,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          if (unread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                  color: SpheraColors.gold, shape: BoxShape.circle),
            ),
        ]),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(insight.body,
              style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
        ),
        trailing:
            insight.target == null ? null : const Icon(Icons.chevron_right),
        onTap:
            insight.target == null ? null : () => openInsight(context, insight),
      ),
    );
  }
}
