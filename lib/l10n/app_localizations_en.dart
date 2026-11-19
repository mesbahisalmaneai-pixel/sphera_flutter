// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navStats => 'Stats';

  @override
  String get navOrbit => 'Orbit';

  @override
  String get navCards => 'Cards';

  @override
  String get navProfile => 'Profile';

  @override
  String get askSphera => 'Ask SPHERA';

  @override
  String get settings => 'Settings';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get forSale => 'For Sale';

  @override
  String get addAccount => 'Add Account';

  @override
  String get searchAccount => 'Search Account';

  @override
  String get manageGames => 'Manage Games';

  @override
  String get netProfit => 'Net Profit';

  @override
  String vsLastMonth(String arrow, String pct) {
    return '$arrow $pct% vs last month';
  }

  @override
  String thisMonthAmount(String amount) {
    return 'This month $amount';
  }

  @override
  String get totalAccounts => 'Total Accounts';

  @override
  String get noneAddedThisMonth => 'None added this month';

  @override
  String addedThisMonth(int count) {
    return '+$count this month';
  }

  @override
  String get activeAccounts => 'Active Accounts';

  @override
  String get noAccountsYet => 'No accounts yet';

  @override
  String percentOfTotal(int pct) {
    return '$pct% of total';
  }

  @override
  String get nothingListed => 'Nothing listed';

  @override
  String get listedNoPrice => 'Listed, no price';

  @override
  String get sold => 'Sold';

  @override
  String get performance => 'Performance';

  @override
  String get profitByDateAdded => 'Profit by date added';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String accountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
    );
    return '$_temp0';
  }

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '1 game',
    );
    return '$_temp0';
  }

  @override
  String weekOf(String date) {
    return 'Week of $date';
  }

  @override
  String get noAccountsInPeriod => 'No accounts added in this period';

  @override
  String get actionAdded => 'Added';

  @override
  String get actionUpdated => 'Updated';

  @override
  String get actionStatusChanged => 'Status changed';

  @override
  String get actionMovedToTrash => 'Moved to trash';

  @override
  String get actionRestored => 'Restored';

  @override
  String get actionDeleted => 'Deleted';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get noActivityYet => 'No activity yet.\nNew actions will appear here.';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get viewAll => 'View all';

  @override
  String get statistics => 'Statistics';

  @override
  String get analyticsCenter => 'Analytics Center';

  @override
  String get profitCenter => 'Profit Center';

  @override
  String get profitCenterSub =>
      'Sales, expenses, purchase & sale price, net profit';

  @override
  String get activityCenter => 'Activity Center';

  @override
  String get activityCenterSub => 'Activity log, filter by date & type';

  @override
  String get performanceCenter => 'Performance Center';

  @override
  String get performanceCenterSub => 'Daily, weekly, monthly & goals';

  @override
  String get spheraIntelligence => 'SPHERA Intelligence';

  @override
  String get spheraIntelligenceSub => 'Offline analysis of your accounts';

  @override
  String get gradeStatistics => 'Grade Statistics';

  @override
  String get gradeStatisticsSub =>
      'Bronze, Silver, Gold, Platinum, Diamond & Interdit';

  @override
  String get statusStatistics => 'Status Statistics';

  @override
  String get statusStatisticsSub =>
      'Google boxes and gaming accounts, each on its own';

  @override
  String get gamesStatistics => 'Games Statistics';

  @override
  String get gamesStatisticsSub => 'Profit, counts & status per game';

  @override
  String get cards => 'Cards';

  @override
  String get googlePlayAccounts => 'Google Play Accounts';

  @override
  String get googlePlayAccountsSub => 'Grades & game boxes';

  @override
  String get games => 'Games';

  @override
  String get gamesSub => 'Gaming account inventory';

  @override
  String get statisticsSub => 'Profit, counts & statuses';

  @override
  String get toolsSettings => 'Tools & Settings';

  @override
  String get toolsSettingsSub => 'Backup, trash, profile';

  @override
  String get manage => 'Manage';

  @override
  String get arenaTitle => 'SPHERA TOURNAMENT ARENA';

  @override
  String get arenaSub => 'Leagues, groups & knockouts';

  @override
  String get createOne => 'Create one';

  @override
  String tournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournaments',
      one: '1 tournament',
    );
    return '$_temp0';
  }

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementsSub => 'Badges & milestones';

  @override
  String achievementsUnlocked(int done, int total) {
    return '$done / $total unlocked';
  }

  @override
  String get smartTools => 'Smart Tools';

  @override
  String get duplicateScanner => 'Duplicate Scanner';

  @override
  String get duplicateScannerSub => 'Find duplicate accounts, review manually';

  @override
  String get noDuplicates => 'No duplicates';

  @override
  String toReview(int count) {
    return '$count to review';
  }

  @override
  String get smartOrganizer => 'Smart Organizer';

  @override
  String get smartOrganizerSub => 'Search, filter & sort accounts';

  @override
  String get smartOrganizerSummary => 'By game, status, grade & date';

  @override
  String get inventoryVault => 'Inventory Vault';

  @override
  String get inventoryVaultSub => 'Favourite, rare & high-value accounts';

  @override
  String inVault(int count) {
    return '$count in vault';
  }

  @override
  String get securityCenter => 'Security Center';

  @override
  String get securityCenterSub => 'Data health, backup & sync status';

  @override
  String get allGood => 'All good';

  @override
  String get language => 'Language';

  @override
  String get profileSecurity => 'Profile & Security';

  @override
  String get localMode => 'Local mode';

  @override
  String get localModeSub =>
      'Not signed in. Your data is stored on this device only. Account sign-in and cloud sync are not connected yet.';

  @override
  String get protectionPrivacy => 'Protection & privacy';

  @override
  String get appearance => 'Appearance';

  @override
  String get mode => 'Mode';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get auto => 'Auto';

  @override
  String get style => 'Style';

  @override
  String get autoFollowsPhone =>
      'Auto follows your phone\'s dark / light setting.';

  @override
  String get notifications => 'Notifications';

  @override
  String get off => 'Off';

  @override
  String get onRemindersOn => 'On · Reminders on';

  @override
  String get onRemindersOff => 'On · Reminders off';

  @override
  String get currency => 'Currency';

  @override
  String get data => 'Data';

  @override
  String get trash => 'Trash';

  @override
  String get empty => 'Empty';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get storedItems => 'Stored items & assets';

  @override
  String get aboutSphera => 'About SPHERA';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get aboutText =>
      'Google Play accounts, gaming accounts, prices and statistics in one place.';

  @override
  String get ratesUpdated => 'Exchange rates updated.';

  @override
  String get dhIsBase => 'DH is the base currency: amounts are stored in DH.';

  @override
  String liveRate(String when) {
    return 'Live rate, updated $when';
  }

  @override
  String get approximateRate =>
      'Approximate rate, not live yet. Tap \"Update rates\" when online.';

  @override
  String get conversionNote =>
      'Every price is converted at this rate for display, and what you type is converted back to DH when saved.';

  @override
  String get updateRates => 'Update rates';
}
