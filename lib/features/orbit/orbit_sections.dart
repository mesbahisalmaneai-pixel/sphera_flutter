import 'package:flutter/material.dart';
import '../../core/l10n.dart';

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
      label: appL10n.navStats,
      tagline: appL10n.secStatsTagline,
      icon: Icons.bar_chart_rounded,
      destinations: [
        OrbitDestination(
          id: 'profit',
          title: appL10n.profitCenter,
          description: appL10n.profitCenterSub,
          icon: Icons.payments_outlined,
          pattern: 0,
          builder: (_) => const ProfitCenterScreen(),
        ),
        OrbitDestination(
          id: 'activity',
          title: appL10n.activityCenter,
          description: appL10n.activityCenterSub,
          icon: Icons.timeline_rounded,
          pattern: 1,
          builder: (_) => const ActivityCenterScreen(),
        ),
        OrbitDestination(
          id: 'performance',
          title: appL10n.performanceCenter,
          description: appL10n.destPerformanceSub,
          icon: Icons.speed_rounded,
          pattern: 3,
          builder: (_) => const PerformanceCenterScreen(),
        ),
        OrbitDestination(
          id: 'intelligence',
          title: appL10n.spheraIntelligence,
          description: appL10n.spheraIntelligenceSub,
          icon: Icons.auto_awesome_outlined,
          pattern: 4,
          builder: (_) => const IntelligenceScreen(),
        ),
        OrbitDestination(
          id: 'grades',
          title: appL10n.gradeStatistics,
          description: appL10n.destGradeStatsSub,
          icon: Icons.workspace_premium_outlined,
          pattern: 2,
          builder: (_) => const GradeStatisticsScreen(),
        ),
        OrbitDestination(
          id: 'status',
          title: appL10n.statusStatistics,
          description: appL10n.statusStatisticsSub,
          icon: Icons.fact_check_outlined,
          pattern: 3,
          builder: (_) => const StatusStatisticsScreen(),
        ),
        OrbitDestination(
          id: 'games-stats',
          title: appL10n.gamesStatistics,
          description: appL10n.gamesStatisticsSub,
          icon: Icons.sports_esports_outlined,
          pattern: 4,
          builder: (_) => const GamesStatisticsScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'cards',
      label: appL10n.navCards,
      tagline: appL10n.secCardsTagline,
      icon: Icons.style_rounded,
      destinations: [
        OrbitDestination(
          id: 'duplicates',
          title: appL10n.duplicateScanner,
          description: appL10n.duplicateScannerSub,
          icon: Icons.content_copy_outlined,
          pattern: 1,
          builder: (_) => const DuplicateScannerScreen(),
        ),
        OrbitDestination(
          id: 'organizer',
          title: appL10n.smartOrganizer,
          description: appL10n.smartOrganizerSub,
          icon: Icons.manage_search_rounded,
          pattern: 3,
          builder: (_) => const SmartOrganizerScreen(),
        ),
        OrbitDestination(
          id: 'vault',
          title: appL10n.inventoryVault,
          description: appL10n.inventoryVaultSub,
          icon: Icons.inventory_2_outlined,
          pattern: 2,
          builder: (_) => const InventoryVaultScreen(),
        ),
        OrbitDestination(
          id: 'arena',
          title: appL10n.tournamentArena,
          description: appL10n.arenaSub,
          icon: Icons.emoji_events_outlined,
          pattern: 0,
          builder: (_) => const ArenaScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'games',
      label: appL10n.games,
      tagline: appL10n.secGamesTagline,
      icon: Icons.sports_esports_outlined,
      destinations: [
        OrbitDestination(
          id: 'all-games',
          title: appL10n.destAllGames,
          description: appL10n.gamesSub,
          icon: Icons.apps_rounded,
          pattern: 4,
          builder: (_) => const GamesScreen(),
        ),
        OrbitDestination(
          id: 'for-sale',
          title: appL10n.forSale,
          description: appL10n.destForSaleSub,
          icon: Icons.sell_outlined,
          pattern: 1,
          builder: (_) => const ForSaleScreen(),
        ),
        // One planet per configured game (max 5, the rest live in "All Games").
        for (var i = 0; i < games.length && i < 5; i++)
          OrbitDestination(
            id: 'game-${games[i].id}',
            title: games[i].name,
            description: appL10n.destGameSub,
            icon: Icons.videogame_asset_outlined,
            pattern: i,
            builder: (_) => GameAccountsScreen(game: games[i]),
          ),
      ],
    ),
    OrbitSection(
      id: 'google',
      label: appL10n.secGoogle,
      tagline: appL10n.secGoogleTagline,
      icon: Icons.mail_outline,
      destinations: [
        OrbitDestination(
          id: 'google-accounts',
          title: appL10n.googlePlayAccounts,
          description: appL10n.googlePlayAccountsSub,
          icon: Icons.mail_outline,
          pattern: 0,
          builder: (_) => const GoogleAccountsScreen(),
        ),
        OrbitDestination(
          id: 'google-add',
          title: appL10n.addAccount,
          description: appL10n.destGoogleAddSub,
          icon: Icons.person_add_alt_outlined,
          pattern: 2,
          builder: (_) => const GoogleAccountForm(),
        ),
        OrbitDestination(
          id: 'google-grades',
          title: appL10n.destGrades,
          description: appL10n.destGradesSub,
          icon: Icons.workspace_premium_outlined,
          pattern: 3,
          builder: (_) => const GradeStatisticsScreen(),
        ),
        OrbitDestination(
          id: 'google-status',
          title: appL10n.destBoxStatus,
          description: appL10n.destBoxStatusSub,
          icon: Icons.fact_check_outlined,
          pattern: 4,
          builder: (_) => const StatusStatisticsScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'profile',
      label: appL10n.navProfile,
      tagline: appL10n.secProfileTagline,
      icon: Icons.person_outline_rounded,
      destinations: [
        OrbitDestination(
          id: 'profile',
          title: appL10n.destMyProfile,
          description: appL10n.destMyProfileSub,
          icon: Icons.person_outline_rounded,
          pattern: 2,
          builder: (_) => const ProfileScreen(),
        ),
        OrbitDestination(
          id: 'achievements',
          title: appL10n.achievements,
          description: appL10n.destAchievementsSub,
          icon: Icons.military_tech_outlined,
          pattern: 4,
          builder: (_) => const AchievementsScreen(),
        ),
      ],
    ),
    OrbitSection(
      id: 'settings',
      label: appL10n.settings,
      tagline: appL10n.secSettingsTagline,
      icon: Icons.settings_outlined,
      destinations: [
        OrbitDestination(
          id: 'settings',
          title: appL10n.settings,
          description: appL10n.destSettingsSub,
          icon: Icons.tune_rounded,
          pattern: 3,
          builder: (_) => const SettingsScreen(),
        ),
        OrbitDestination(
          id: 'notifications',
          title: appL10n.notifications,
          description: appL10n.destNotificationsSub,
          icon: Icons.notifications_none_rounded,
          pattern: 1,
          builder: (_) => const NotificationsScreen(),
        ),
        OrbitDestination(
          id: 'security',
          title: appL10n.securityCenter,
          description: appL10n.securityCenterSub,
          icon: Icons.shield_outlined,
          pattern: 2,
          builder: (_) => const SecurityCenterScreen(),
        ),
        OrbitDestination(
          id: 'trash',
          title: appL10n.trash,
          description: appL10n.destTrashSub,
          icon: Icons.delete_outline,
          pattern: 0,
          builder: (_) => const TrashScreen(),
        ),
      ],
    ),
  ];
}
