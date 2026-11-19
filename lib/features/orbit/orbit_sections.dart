import 'package:flutter/material.dart';

import '../../data/database.dart' show Game;
import '../achievements/achievements_screen.dart';
import '../arena/arena_screen.dart';
import '../games/game_accounts_screen.dart';
import '../games/games_screen.dart';
import '../google/google_account_form.dart';
import '../google/google_accounts_screen.dart';
import '../profile/profile_screen.dart';
import '../sale/for_sale_screen.dart';
import '../intelligence/intelligence_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import '../settings/trash_screen.dart';
import '../stats/activity_center_screen.dart';
import '../stats/games_statistics_screen.dart';
import '../stats/grade_statistics_screen.dart';
import '../stats/performance_center_screen.dart';
import '../stats/profit_center_screen.dart';
import '../stats/status_statistics_screen.dart';
import '../tools/duplicate_scanner_screen.dart';
import '../tools/inventory_vault_screen.dart';
import '../tools/security_center_screen.dart';
import '../tools/smart_organizer_screen.dart';
import 'models/orbit_destination.dart';

/// Maps the Orbit universe to the REAL screens of the app.
/// Only features that exist are listed here.
/// The Games section is built from the games configured in the database.
List<OrbitSection> buildOrbitSections(List<Game> games) {
  return [
    OrbitSection(
      id: 'stats',
      label: 'Stats',
      tagline: 'Analytics & performance',
      icon: Icons.bar_chart_rounded,
      destinations: [
        OrbitDestination(
          id: 'profit',
          title: 'Profit Center',
          description: 'Sales, expenses, purchase & sale price, net profit',
          icon: Icons.payments_outlined,
          pattern: 0,
          builder: (_) => const ProfitCenterScreen(),
        ),
        OrbitDestination(
          id: 'activity',
          title: 'Activity Center',
          description: 'Activity log, filter by date & type',
          icon: Icons.timeline_rounded,
          pattern: 1,
          builder: (_) => const ActivityCenterScreen(),
        ),
        OrbitDestination(
          id: 'performance',
          title: 'Performance Center',
          description: 'Today, this week, this month & goals',
          icon: Icons.speed_rounded,
          pattern: 3,
          builder: (_) => const PerformanceCenterScreen(),
        ),
        OrbitDestination(
          id: 'intelligence',
          title: 'SPHERA Intelligence',
          description: 'Offline analysis of your accounts',
          icon: Icons.auto_awesome_outlined,
          pattern: 4,
          builder: (_) => const IntelligenceScreen(),
        ),
        OrbitDestination(
          id: 'grades',
          title: 'Grade Statistics',
          description: 'Bronze to Diamond & Interdit',
          icon: Icons.workspace_premium_outlined,
          pattern: 2,
          builder: (_) => const GradeStatisticsScreen(),
        ),
        OrbitDestination(
          id: 'status',
          title: 'Status Statistics',
          description: 'Google boxes and gaming accounts, each on its own',
          icon: Icons.fact_check_outlined,
          pattern: 3,
          builder: (_) => const StatusStatisticsScreen(),
        ),
        OrbitDestination(
          id: 'games-stats',
          title: 'Games Statistics',
          description: 'Profit, counts & status per game',
          icon: Icons.sports_esports_outlined,
          pattern: 4,
          builder: (_) => const GamesStatisticsScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'cards',
      label: 'Cards',
      tagline: 'Smart tools & arena',
      icon: Icons.style_rounded,
      destinations: [
        OrbitDestination(
          id: 'duplicates',
          title: 'Duplicate Scanner',
          description: 'Find duplicate accounts, review manually',
          icon: Icons.content_copy_outlined,
          pattern: 1,
          builder: (_) => const DuplicateScannerScreen(),
        ),
        OrbitDestination(
          id: 'organizer',
          title: 'Smart Organizer',
          description: 'Search, filter & sort accounts',
          icon: Icons.manage_search_rounded,
          pattern: 3,
          builder: (_) => const SmartOrganizerScreen(),
        ),
        OrbitDestination(
          id: 'vault',
          title: 'Inventory Vault',
          description: 'Favourite, rare & high-value accounts',
          icon: Icons.inventory_2_outlined,
          pattern: 2,
          builder: (_) => const InventoryVaultScreen(),
        ),
        OrbitDestination(
          id: 'arena',
          title: 'Tournament Arena',
          description: 'Leagues, groups & knockouts',
          icon: Icons.emoji_events_outlined,
          pattern: 0,
          builder: (_) => const ArenaScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'games',
      label: 'Games',
      tagline: 'Your gaming accounts',
      icon: Icons.sports_esports_outlined,
      destinations: [
        OrbitDestination(
          id: 'all-games',
          title: 'All Games',
          description: 'Gaming account inventory',
          icon: Icons.apps_rounded,
          pattern: 4,
          builder: (_) => const GamesScreen(),
        ),
        OrbitDestination(
          id: 'for-sale',
          title: 'For Sale',
          description: 'Accounts currently listed for sale',
          icon: Icons.sell_outlined,
          pattern: 1,
          builder: (_) => const ForSaleScreen(),
        ),
        // One planet per configured game (max 5, the rest live in "All Games").
        for (var i = 0; i < games.length && i < 5; i++)
          OrbitDestination(
            id: 'game-${games[i].id}',
            title: games[i].name,
            description: 'Accounts and statuses of this game',
            icon: Icons.videogame_asset_outlined,
            pattern: i,
            builder: (_) => GameAccountsScreen(game: games[i]),
          ),
      ],
    ),
    OrbitSection(
      id: 'google',
      label: 'Google',
      tagline: 'Google Play accounts',
      icon: Icons.mail_outline,
      destinations: [
        OrbitDestination(
          id: 'google-accounts',
          title: 'Google Play Accounts',
          description: 'Grades & game boxes',
          icon: Icons.mail_outline,
          pattern: 0,
          builder: (_) => const GoogleAccountsScreen(),
        ),
        OrbitDestination(
          id: 'google-add',
          title: 'Add Account',
          description: 'Add a new Google Play account',
          icon: Icons.person_add_alt_outlined,
          pattern: 2,
          builder: (_) => const GoogleAccountForm(),
        ),
        OrbitDestination(
          id: 'google-grades',
          title: 'Grades',
          description: 'Statistics by grade',
          icon: Icons.workspace_premium_outlined,
          pattern: 3,
          builder: (_) => const GradeStatisticsScreen(),
        ),
        OrbitDestination(
          id: 'google-status',
          title: 'Box Status',
          description: 'Statistics by game box status',
          icon: Icons.fact_check_outlined,
          pattern: 4,
          builder: (_) => const StatusStatisticsScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'profile',
      label: 'Profile',
      tagline: 'You & your progress',
      icon: Icons.person_outline_rounded,
      destinations: [
        OrbitDestination(
          id: 'profile',
          title: 'My Profile',
          description: 'Picture, info, rank & session',
          icon: Icons.person_outline_rounded,
          pattern: 2,
          builder: (_) => const ProfileScreen(),
        ),
        OrbitDestination(
          id: 'achievements',
          title: 'Achievements',
          description: 'Badges, progress & unlock dates',
          icon: Icons.military_tech_outlined,
          pattern: 4,
          builder: (_) => const AchievementsScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'settings',
      label: 'Settings',
      tagline: 'Preferences & safety',
      icon: Icons.settings_outlined,
      destinations: [
        OrbitDestination(
          id: 'settings',
          title: 'Settings',
          description: 'Appearance, language, currency & data',
          icon: Icons.tune_rounded,
          pattern: 3,
          builder: (_) => const SettingsScreen(),
        ),
        OrbitDestination(
          id: 'notifications',
          title: 'Notifications',
          description: 'Warnings and reminders',
          icon: Icons.notifications_none_rounded,
          pattern: 1,
          builder: (_) => const NotificationsScreen(),
        ),
        OrbitDestination(
          id: 'security',
          title: 'Security Center',
          description: 'Data health, backup & sync status',
          icon: Icons.shield_outlined,
          pattern: 2,
          builder: (_) => const SecurityCenterScreen(),
        ),
        OrbitDestination(
          id: 'trash',
          title: 'Trash',
          description: 'Restore removed accounts',
          icon: Icons.delete_outline,
          pattern: 0,
          builder: (_) => const TrashScreen(),
        ),
      ],
    ),
  ];
}
