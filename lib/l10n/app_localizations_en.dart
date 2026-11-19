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

  @override
  String get authNeedHelp => 'Need help?';

  @override
  String get authHelpBody =>
      'New here? Choose \"Create a new account\".\n\nAlready registered on this device? Choose \"I have an existing account\".\n\nCan\'t get in? Use \"I have a problem in login & password\".';

  @override
  String get gotIt => 'Got it';

  @override
  String get cancel => 'Cancel';

  @override
  String get back => 'Back';

  @override
  String get help => 'Help';

  @override
  String get authVerifyUnavailableTitle => 'Verification is not available yet';

  @override
  String get authVerifyUnavailableBody =>
      'Codes by email or SMS need an online service, which is not connected to SPHERA yet.\n\nYou can reset the login on this device instead and create a new one. Your accounts, games and statistics are kept.\n\nThis login only protects casual access to the app on this device.';

  @override
  String get authResetLogin => 'Reset login';

  @override
  String get authOops => 'Oops!';

  @override
  String get authHintEmailOrPhone => 'email or phone number';

  @override
  String get authHintCode => 'validation code';

  @override
  String get authLogin => 'Login';

  @override
  String get authEnterUserAndPassword => 'Enter your username and password.';

  @override
  String get authWelcomeTitle => 'WELCOME!';

  @override
  String get authHintUsername => 'username';

  @override
  String get authHintPassword => 'password';

  @override
  String get authForgotPassword => 'you forgot your password?';

  @override
  String get authProfilePhotoOptional => 'Profile photo (optional)';

  @override
  String get authHintChooseUsername => 'choose a username';

  @override
  String get authHintCreatePassword => 'create a password';

  @override
  String get authHintConfirmPassword => 'confirm your password';

  @override
  String get authConfirmInfo => 'I confirm my information is correct';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authYourAge => 'your age';

  @override
  String get authHelloTitle => 'HELLO!';

  @override
  String get authCreateNewAccount => 'Create a new account';

  @override
  String get authHaveAccount => 'I have an existing account';

  @override
  String get authLoginProblem => 'I have a problem in login & password';

  @override
  String get valEnterIdentifier => 'Enter your email or phone number';

  @override
  String get valInvalidIdentifier => 'Enter a valid email or phone number';

  @override
  String get valChooseUsername => 'Choose a username';

  @override
  String get valUsernameRule => '3-20 characters: letters, numbers, _ or .';

  @override
  String get valCreatePassword => 'Create a password';

  @override
  String get valPasswordLength => 'At least 8 characters';

  @override
  String get valPasswordMix => 'Use both letters and numbers';

  @override
  String get valConfirmPassword => 'Confirm your password';

  @override
  String get valPasswordsMismatch => 'Passwords do not match';

  @override
  String valMinAge(int age) {
    return 'SPHERA is for users $age and older';
  }

  @override
  String get valInvalidAge => 'Enter a valid age';

  @override
  String get authErrAccountExists =>
      'An account already exists on this device. Log in instead.';

  @override
  String get authErrWrongCredentials => 'Wrong username or password.';

  @override
  String get authNoCode => 'I didn\'t receive the verification code';

  @override
  String get boxEmpty => 'EMPTY';

  @override
  String get boxDone => 'DONE';

  @override
  String get boxNotYet => 'NOT YET';

  @override
  String get boxComing => 'COMING';

  @override
  String get gradeBronze => 'Bronze';

  @override
  String get gradeSilver => 'Silver';

  @override
  String get gradeGold => 'Gold';

  @override
  String get gradePlatinum => 'Platinum';

  @override
  String get gradeDiamond => 'Diamond';

  @override
  String get gradeInterdit => 'Interdit';

  @override
  String get statusActive => 'ACTIVE';

  @override
  String get statusSold => 'SOLD';

  @override
  String get statusForSale => 'FOR SALE';

  @override
  String get done => 'Done';

  @override
  String couldNotSave(String error) {
    return 'Could not save: $error';
  }

  @override
  String errDuplicateEmail(String email) {
    return 'A Google account with $email already exists.';
  }

  @override
  String errDuplicateGame(String name) {
    return 'A game named \"$name\" already exists.';
  }

  @override
  String get editGoogleAccount => 'Edit Google Account';

  @override
  String get addGoogleAccount => 'Add Google Account';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get grade => 'Grade';

  @override
  String get gameBoxes => 'Game boxes';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get addAccountShort => 'Add account';

  @override
  String movedToTrash(String name) {
    return '$name moved to Trash';
  }

  @override
  String get undo => 'UNDO';

  @override
  String get manageGamesLower => 'Manage games';

  @override
  String couldNotLoadAccounts(String error) {
    return 'Could not load accounts: $error';
  }

  @override
  String get searchByEmail => 'Search by email';

  @override
  String get allGrades => 'All grades';

  @override
  String get anyStatus => 'Any status';

  @override
  String boxesSet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boxes set',
      one: '1 box set',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Edit';

  @override
  String get moveToTrash => 'Move to Trash';

  @override
  String get setBoxes => 'Set boxes';

  @override
  String get box => 'Box';

  @override
  String get noAccountMatches => 'No account matches your filters';

  @override
  String get noGoogleAccountsYet => 'No Google accounts yet';

  @override
  String get addFirstAccount => 'Add your first account';

  @override
  String get enterGameName => 'Enter a game name';

  @override
  String couldNotAddGame(String error) {
    return 'Could not add game: $error';
  }

  @override
  String removeGameTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String removeGameWithAccounts(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gaming accounts',
      one: '1 gaming account',
    );
    return '$name has $_temp0. They are kept, but the game and its boxes will be hidden from the lists.';
  }

  @override
  String get removeGameNoAccounts =>
      'The game and its boxes will be hidden from the lists.';

  @override
  String get remove => 'Remove';

  @override
  String get newGameName => 'New game name';

  @override
  String get add => 'Add';

  @override
  String get removeGame => 'Remove game';

  @override
  String get accountNoLongerAvailable => 'Account no longer available';

  @override
  String couldNotSetPhoto(String error) {
    return 'Could not set photo: $error';
  }

  @override
  String get changePhoto => 'Change photo';

  @override
  String get reset => 'Reset';

  @override
  String get game => 'Game';

  @override
  String get removedGame => 'Removed game';

  @override
  String get idCompte => 'ID compte';

  @override
  String get purchasePrice => 'Purchase price';

  @override
  String get salePrice => 'Sale price';

  @override
  String get profit => 'Profit';

  @override
  String get loss => 'Loss';

  @override
  String get enterNumber => 'Enter a number';

  @override
  String get mustBeZeroOrMore => 'Must be 0 or more';

  @override
  String get chooseGame => 'Choose a game';

  @override
  String get editAccount => 'Edit account';

  @override
  String get idCompteRequired => 'ID compte is required';

  @override
  String get accountName => 'Account name';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get status => 'Status';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get noAccountsYetShort => 'No accounts yet';

  @override
  String get gameName => 'Game name';

  @override
  String get save => 'Save';

  @override
  String get addGame => 'Add game';

  @override
  String get renameGame => 'Rename game';

  @override
  String couldNotSetImage(String error) {
    return 'Could not set image: $error';
  }

  @override
  String removeGameKeepsAccounts(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
    );
    return '$name has $_temp0. They are kept, but the game is hidden from the lists.';
  }

  @override
  String get removeGameHidden => 'The game will be hidden from the lists.';

  @override
  String get noGamesYet => 'No games yet';

  @override
  String get rename => 'Rename';

  @override
  String get changeGameImage => 'Change game image';

  @override
  String get changeAccountPhoto => 'Change account photo';

  @override
  String get resetImages => 'Reset images';

  @override
  String get today => 'today';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String accountsForSaleList(int count) {
    return 'Accounts for sale ($count):';
  }

  @override
  String get listCopied => 'List copied (no prices)';

  @override
  String forSaleCount(int count) {
    return 'For Sale ($count)';
  }

  @override
  String get copyListNoPrices => 'Copy list without prices';

  @override
  String get nothingForSale =>
      'Nothing is listed for sale.\nOpen an account and choose \"List for sale\".';

  @override
  String get listed => 'Listed';

  @override
  String gamesWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Games',
      one: 'Game',
    );
    return '$_temp0';
  }

  @override
  String get longestWait => 'Longest wait';

  @override
  String get searchNameIdGame => 'Search name, ID or game';

  @override
  String allCount(int count) {
    return 'All ($count)';
  }

  @override
  String get noMatch => 'No match';

  @override
  String waitingFor(String time) {
    return 'waiting $time';
  }

  @override
  String get searchAccounts => 'Search accounts';

  @override
  String get clear => 'Clear';

  @override
  String noAccountFoundFor(String query) {
    return 'No account found for \"$query\"';
  }

  @override
  String marginPct(String pct) {
    return '$pct% margin';
  }

  @override
  String get salesSalePrice => 'Sales (Sale Price)';

  @override
  String get expensesPurchasePrice => 'Expenses (Purchase Price)';

  @override
  String get perGame => 'Per game';

  @override
  String salesAndExpenses(String sales, String expenses) {
    return 'Sales $sales · Expenses $expenses';
  }

  @override
  String get topProfit => 'Top profit';

  @override
  String get losses => 'Losses';

  @override
  String get todayCap => 'Today';

  @override
  String get typeGoogle => 'Google';

  @override
  String get typeGaming => 'Gaming';

  @override
  String get typeGames => 'Games';

  @override
  String get typeSystem => 'System';

  @override
  String get last7Days => '7 days';

  @override
  String get last30Days => '30 days';

  @override
  String get allTypes => 'All types';

  @override
  String get noActivityFromNow =>
      'No activity yet.\nNew actions will appear here from now on.';

  @override
  String perfAddedVsPrev(int added, int prev, String prevLabel) {
    return '$added added · $prev $prevLabel';
  }

  @override
  String perfSameProfit(String prevLabel) {
    return 'Same profit as $prevLabel';
  }

  @override
  String perfVsPrev(String amount, String prevLabel) {
    return '$amount vs $prevLabel';
  }

  @override
  String get thisWeek => 'This week';

  @override
  String get thisMonth => 'This month';

  @override
  String get prevYesterday => 'yesterday';

  @override
  String get prevLastWeek => 'last week';

  @override
  String get prevLastMonth => 'last month';

  @override
  String get goalReached => 'Reached';

  @override
  String get goalOnTrack => 'On track';

  @override
  String get goalBehind => 'Behind pace';

  @override
  String goalProgress(String current, String target, String pct) {
    return '$current of $target · $pct%';
  }

  @override
  String get performanceCenterTitle => 'Performance Center';

  @override
  String get monthlyGoals => 'Monthly goals';

  @override
  String get setGoals => 'Set goals';

  @override
  String get noGoalsYet =>
      'No goals yet. Set a monthly profit or accounts goal to track your pace.';

  @override
  String get accountsAdded => 'Accounts added';

  @override
  String get highlights => 'Highlights';

  @override
  String get addStreak => 'Add streak';

  @override
  String get addStreakSub => 'Days in a row with a new account';

  @override
  String get bestDay30 => 'Best day (30 days)';

  @override
  String get bestWeek12 => 'Best week (12 weeks)';

  @override
  String get bestMonth12 => 'Best month (12 months)';

  @override
  String get perfNote =>
      'Accounts count in the period they were added. FOR SALE accounts have no profit yet.';

  @override
  String profitGoalCurrency(String currency) {
    return 'Profit goal ($currency)';
  }

  @override
  String get emptyNoGoal => 'Empty = no goal';

  @override
  String get accountsToAdd => 'Accounts to add';

  @override
  String googleAccountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Google accounts',
      one: '1 Google account',
    );
    return '$_temp0';
  }

  @override
  String get googlePlayBoxes => 'Google Play boxes';

  @override
  String get gamingAccounts => 'Gaming accounts';

  @override
  String get totalProfitLoss => 'Total profit / loss';

  @override
  String get pricePerGame => 'Price per game';

  @override
  String accountsIncluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts included',
      one: '1 account included',
    );
    return '$_temp0';
  }

  @override
  String get accountsPerGame => 'Number of accounts per game';

  @override
  String get statusPerGame => 'Account status per game';

  @override
  String get noAccountsInGrade => 'No accounts in this grade';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get nothingHere => 'Nothing here';

  @override
  String get howMatchingWorks => 'How matching works';

  @override
  String get matchingRules =>
      'Google accounts: same Email (ignores case, spaces, and for Gmail dots and \"+tags\").\nGame accounts: same Account ID inside the same game.\nPhone matching is not available: phone numbers are not stored yet.';

  @override
  String get nothingMergedAutomatically =>
      'Nothing is deleted or merged automatically. You review every account yourself.';

  @override
  String get noDuplicatesFound => 'No duplicates found';

  @override
  String get googleAccountsSection => 'Google accounts';

  @override
  String get gameAccountsSection => 'Game accounts';

  @override
  String showDismissedAgain(int count) {
    return 'Show $count dismissed again';
  }

  @override
  String get markedNotDuplicates => 'Marked as not duplicates';

  @override
  String similarAccounts(int count) {
    return '$count similar accounts';
  }

  @override
  String addedOn(String date) {
    return 'added $date';
  }

  @override
  String get openToReview => 'Open to review';

  @override
  String get notDuplicates => 'Not duplicates';

  @override
  String accountsWithId(int count, String id) {
    return '$count accounts with ID $id';
  }

  @override
  String get unknownGame => 'Unknown game';

  @override
  String buySell(String buy, String sell) {
    return 'buy $buy → sell $sell';
  }

  @override
  String get openGame => 'Open game';

  @override
  String saleAmount(String amount) {
    return 'sale $amount';
  }

  @override
  String get addToVault => 'Add to vault';

  @override
  String get all => 'All';

  @override
  String get vaultEmpty => 'Your vault is empty';

  @override
  String get nothingWithTag => 'Nothing with this tag';

  @override
  String get vaultHint =>
      'Tap \"Add to vault\" to mark favourite, rare or high-value accounts.';

  @override
  String get search => 'Search';

  @override
  String get highestSaleFirst => 'Highest sale price first';

  @override
  String get noAccount => 'No account';

  @override
  String get tagFavorite => 'Favorite';

  @override
  String get tagRare => 'Rare';

  @override
  String get tagHighValue => 'High value';

  @override
  String get everythingGood => 'Everything looks good';

  @override
  String itemsToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items to review',
      one: '1 item to review',
    );
    return '$_temp0';
  }

  @override
  String get basedOnDeviceData => 'Based on the data stored on this device.';

  @override
  String get dataHealth => 'Data health';

  @override
  String get duplicateAccounts => 'Duplicate accounts';

  @override
  String get noneFound => 'None found';

  @override
  String groupsToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count groups to review',
      one: '1 group to review',
    );
    return '$_temp0';
  }

  @override
  String get duplicateGameIds => 'Duplicate game Account IDs';

  @override
  String get accountsWithoutId => 'Game accounts without Account ID';

  @override
  String get allHaveId => 'All have an Account ID';

  @override
  String accountsMissingId(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts missing an ID',
      one: '1 account missing an ID',
    );
    return '$_temp0';
  }

  @override
  String get invalidEmails => 'Invalid emails';

  @override
  String get allEmailsValid => 'All emails look valid';

  @override
  String accountsWrongEmail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts with a wrong email format',
      one: '1 account with a wrong email format',
    );
    return '$_temp0';
  }

  @override
  String get accountsNoBoxes => 'Accounts with no boxes set';

  @override
  String justInformational(int count) {
    return '$count (just informational)';
  }

  @override
  String get itemsInTrash => 'Items in Trash';

  @override
  String trashKept(int count) {
    return '$count kept, nothing is removed automatically';
  }

  @override
  String get protection => 'Protection';

  @override
  String get appLock => 'App lock';

  @override
  String get notEnabledYet => 'Not enabled yet';

  @override
  String get localStorage => 'Local storage';

  @override
  String get dataStaysOnDevice => 'Your data stays on this device';

  @override
  String get backup => 'Backup';

  @override
  String get noBackupYet =>
      'No backup yet. Backup is not available in this version.';

  @override
  String get syncStatus => 'Sync status';

  @override
  String get cloudSync => 'Cloud sync';

  @override
  String get localOnly => 'Local only. Sync is not connected yet.';

  @override
  String get safetyRules => 'Safety rules';

  @override
  String get noAutoDeletion => 'No automatic deletion';

  @override
  String get nothingDeletedWithoutYou => 'Nothing is deleted without you';

  @override
  String get noAutoMerging => 'No automatic merging';

  @override
  String get neverMerge => 'Scanning and organizing never merge accounts';

  @override
  String get manualReviewFirst => 'Manual review first';

  @override
  String get changesByYou => 'Every change is made by you, after review';

  @override
  String get sortRecentActivity => 'Recent activity';

  @override
  String get sortOldestActivity => 'Oldest activity';

  @override
  String get sortNewestAdded => 'Newest added';

  @override
  String get sortOldestAdded => 'Oldest added';

  @override
  String get sortEmailAz => 'Email A–Z';

  @override
  String get sortEmailZa => 'Email Z–A';

  @override
  String get sortGrade => 'Grade';

  @override
  String get sortNewest => 'Newest';

  @override
  String get sortOldest => 'Oldest';

  @override
  String get sortSaleHigh => 'Highest sale price';

  @override
  String get sortSaleLow => 'Lowest sale price';

  @override
  String get sortBuyHigh => 'Highest purchase price';

  @override
  String get sortNameAz => 'Name A–Z';

  @override
  String get sort => 'Sort';

  @override
  String get searchByNameOrId => 'Search by name or Account ID';

  @override
  String get allGames => 'All games';

  @override
  String shownOfTotal(int shown, int total) {
    return '$shown of $total accounts';
  }

  @override
  String sortedBy(String sort) {
    return 'Sorted: $sort';
  }

  @override
  String get noAccountMatchesShort => 'No account matches';

  @override
  String get noActivity => 'no activity';

  @override
  String get emptyTrashTitle => 'Empty Trash?';

  @override
  String emptyTrashBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'All $count items will be permanently deleted. This cannot be undone.',
      one: '1 item will be permanently deleted. This cannot be undone.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'Delete all';

  @override
  String get emptyAction => 'Empty';

  @override
  String googleTabCount(int count) {
    return 'Google ($count)';
  }

  @override
  String gamesTabCount(int count) {
    return 'Games ($count)';
  }

  @override
  String googleAccountDeleted(String grade, String when) {
    return 'Google account · $grade\nDeleted $when';
  }

  @override
  String deletedWhen(String when) {
    return 'Deleted $when';
  }

  @override
  String get removedSuffix => ' (removed)';

  @override
  String get restore => 'Restore';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String get deletePermanentlyTitle => 'Delete permanently?';

  @override
  String deletedForGood(String name) {
    return '$name will be deleted for good. This cannot be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get trashIsEmpty => 'Trash is empty';

  @override
  String get phoneNotifsMobileOnly =>
      'Phone notifications work on Android and iOS only.';

  @override
  String get notifsBlocked =>
      'Notifications are blocked for SPHERA. Allow them in your phone settings, then try again.';

  @override
  String get notifsSub => 'Warnings and reminders in SPHERA';

  @override
  String get reminders => 'Reminders';

  @override
  String get remindersSub =>
      'Stale FOR SALE listings, COMING boxes, goals behind pace';

  @override
  String get alertsNote =>
      'Alerts always appear in the Notifications center (bell icon), with a red count.';

  @override
  String get phoneNotifications => 'Phone notifications';

  @override
  String get phoneNotificationsSub =>
      'Show new alerts on your phone when you leave the app';

  @override
  String get dailySummary => 'Daily summary';

  @override
  String get dailySummarySub => 'Alerts, net profit and accounts, once a day';

  @override
  String get summaryTime => 'Summary time';

  @override
  String get sendTestNotification => 'Send a test notification';

  @override
  String get phoneNotifsNote =>
      'Phone notifications are created on this device, no account or internet needed. The daily summary may arrive a few minutes late to save battery. Some phones (Xiaomi, Huawei...) block background notifications unless you allow SPHERA in battery settings.';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get notifsOff => 'Notifications are off';

  @override
  String get turnOnInSettings => 'Turn them on in notification settings.';

  @override
  String get allClear => 'All clear';

  @override
  String get noWarningsNow => 'No warnings or reminders right now.';

  @override
  String get remindersMuted => 'Reminders are muted in notification settings.';

  @override
  String notificationsNew(int count) {
    return 'Notifications ($count new)';
  }

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get removePhoto => 'Remove photo';

  @override
  String get logOutTitle => 'Log out?';

  @override
  String get logOutBody =>
      'You will need to log in again. Your profile, accounts, games and statistics are kept on this device.';

  @override
  String get logOut => 'Log out';

  @override
  String get profileTitle => 'Profile';

  @override
  String get spheraUser => 'SPHERA User';

  @override
  String rankPts(String rank, int points) {
    return '$rank · $points pts';
  }

  @override
  String get editProfile => 'Edit profile';

  @override
  String get activitySummary => 'Activity summary';

  @override
  String get googleAccountsLabel => 'Google accounts';

  @override
  String get gameAccountsLabel => 'Game accounts';

  @override
  String get profitLoss => 'Profit / loss';

  @override
  String get rank => 'Rank';

  @override
  String rankName(String rank) {
    return 'Rank: $rank';
  }

  @override
  String rankPoints(int points) {
    return '$points rank points';
  }

  @override
  String get topRankReached => 'Top rank reached';

  @override
  String ptsToRank(int points, String rank) {
    return '$points pts to $rank';
  }

  @override
  String unlockedOfTotal(int done, int total) {
    return '$done / $total unlocked';
  }

  @override
  String get allAchievementsUnlocked => 'All achievements unlocked.';

  @override
  String fraction(int a, int b) {
    return '$a / $b';
  }

  @override
  String get session => 'Session';

  @override
  String get currentSession => 'Current session';

  @override
  String startedAt(String time) {
    return 'Started at $time';
  }

  @override
  String get dataOnDeviceOnly => 'Your data is stored on this device only.';

  @override
  String get name => 'Name';

  @override
  String get profilePhotosPhoneOnly =>
      'Profile photos work in the phone app, not in the browser.';

  @override
  String achievementPoints(int earned, int total) {
    return '$earned / $total achievement points';
  }

  @override
  String get achievementPointsNote =>
      'Achievement points are separate from rank points and from Google Play grades.';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get inProgress => 'In progress';

  @override
  String get locked => 'Locked';

  @override
  String get nothingHereYet => 'Nothing here yet';

  @override
  String get achievementDatesNote =>
      'Dates show when an achievement was first detected on this device. Profit amounts are counted in DH.';

  @override
  String unlockCondition(String condition) {
    return 'Unlock: $condition';
  }

  @override
  String unlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String plusPts(int points) {
    return '+$points pts';
  }

  @override
  String progressPct(int a, int b, int pct) {
    return '$a / $b  ·  $pct%';
  }

  @override
  String get catAccounts => 'Accounts';

  @override
  String get catGames => 'Games';

  @override
  String get catSales => 'Sales';

  @override
  String get catProfits => 'Profits';

  @override
  String get catOrganization => 'Organization';

  @override
  String get achAcc1 => 'First account';

  @override
  String get achAcc1Desc => 'Add your first Google account.';

  @override
  String get achAcc10 => 'Collector';

  @override
  String get achAcc10Desc => 'Have 10 Google accounts.';

  @override
  String get achAcc25 => 'Big collection';

  @override
  String get achAcc25Desc => 'Have 25 Google accounts.';

  @override
  String get achGacc10 => 'Game accounts x10';

  @override
  String get achGacc10Desc => 'Have 10 game accounts.';

  @override
  String get achGacc50 => 'Game accounts x50';

  @override
  String get achGacc50Desc => 'Have 50 game accounts.';

  @override
  String get achGacc100 => 'Game accounts x100';

  @override
  String get achGacc100Desc => 'Have 100 game accounts.';

  @override
  String get achGame1 => 'First game';

  @override
  String get achGame1Desc => 'Add your first game.';

  @override
  String get achGame5 => 'Game shelf';

  @override
  String get achGame5Desc => 'Have 5 games.';

  @override
  String get achGame10 => 'Game library';

  @override
  String get achGame10Desc => 'Have 10 games.';

  @override
  String get achSell1 => 'First sale listing';

  @override
  String get achSell1Desc => 'Mark your first account as SOLD.';

  @override
  String get achSell10 => 'Seller';

  @override
  String get achSell10Desc => 'Have 10 accounts marked SOLD.';

  @override
  String get achSell50 => 'Big seller';

  @override
  String get achSell50Desc => 'Have 50 accounts marked SOLD.';

  @override
  String get achProfit1 => 'In profit';

  @override
  String get achProfit1Desc => 'Reach a positive total profit.';

  @override
  String get achProfit1k => '1,000 DH profit';

  @override
  String get achProfit1kDesc => 'Reach 1,000 DH of total profit.';

  @override
  String get achProfit10k => '10,000 DH profit';

  @override
  String get achProfit10kDesc => 'Reach 10,000 DH of total profit.';

  @override
  String get achProfitGames3 => 'Winning games';

  @override
  String get achProfitGames3Desc => 'Have 3 games with a positive profit.';

  @override
  String get achBoxes10 => 'Organized';

  @override
  String get achBoxes10Desc => 'Set 10 game boxes (not EMPTY).';

  @override
  String get achBoxes50 => 'Well organized';

  @override
  String get achBoxes50Desc => 'Set 50 game boxes (not EMPTY).';

  @override
  String get achFull => 'Full coverage';

  @override
  String get achFullDesc =>
      'Have at least one account in every game (minimum 3 games).';

  @override
  String get askSpheraAnything => 'Ask SPHERA anything';

  @override
  String get aiModeOnHint =>
      'AI mode is on: Claude answers using a summary of your numbers.';

  @override
  String get offlineHint =>
      'Your profit, games, accounts, grades, goals, problems, or how to use any screen. Works offline, in English, French or Arabic.';

  @override
  String get askQuestionHint => 'Ask a question…';

  @override
  String get send => 'Send';

  @override
  String get thinking => 'Thinking…';

  @override
  String get sourceOffline => 'Offline';

  @override
  String get sourceNotice => 'Notice';

  @override
  String get aiMode => 'AI mode';

  @override
  String get aiModeExplain =>
      'Offline, the assistant answers from your data and the app guide. With AI mode, Claude (Anthropic) answers any question, in any language.';

  @override
  String get useClaudeAi => 'Use Claude AI';

  @override
  String get apiKeySaved => 'API key saved on this phone';

  @override
  String get addApiKeyFirst => 'Add your API key first';

  @override
  String get replaceApiKey => 'Replace API key';

  @override
  String get anthropicApiKey => 'Anthropic API key';

  @override
  String get keysStartWith => 'Keys start with sk-ant-';

  @override
  String get hide => 'Hide';

  @override
  String get show => 'Show';

  @override
  String get saveKey => 'Save key';

  @override
  String get removeKey => 'Remove key';

  @override
  String get privacy => 'Privacy';

  @override
  String get aiPrivacyText =>
      'When AI mode is on, your question and a summary of your numbers (counts, profits, game names, account names, grades, alerts) are sent to Anthropic to write the answer. Emails, Account IDs, notes and photos are never sent. The key is stored encrypted on this phone.\n\nGet a key at console.anthropic.com (API usage is billed to your Anthropic account).';

  @override
  String get targetGoogleAccounts => 'Google Accounts';

  @override
  String get tournamentArena => 'Tournament Arena';

  @override
  String get newChat => 'New chat';

  @override
  String get aiModeOn => 'AI mode: on';

  @override
  String get aiModeOff => 'AI mode: off';

  @override
  String get ask => 'Ask';

  @override
  String get insights => 'Insights';

  @override
  String get levelAttention => 'Attention';

  @override
  String get levelTips => 'Tips';

  @override
  String get levelGood => 'Good news';

  @override
  String insightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count insights',
      one: '1 insight',
    );
    return '$_temp0';
  }

  @override
  String attentionAndGood(int attention, int good) {
    return '$attention need attention · $good good news';
  }

  @override
  String get nothingHereNow => 'Nothing here right now.';

  @override
  String get analysisOnDevice =>
      'Analysis runs on this device from your own data and updates as you edit accounts.';

  @override
  String get contNorthAmerica => 'North America';

  @override
  String get contSouthAmerica => 'South America';

  @override
  String get contEurope => 'Europe';

  @override
  String get contAfrica => 'Africa';

  @override
  String get contAsia => 'Asia';

  @override
  String get contOceania => 'Oceania';

  @override
  String get globeSemantics =>
      'Globe. Every continent is a section of the app. Use the all sections button to list them.';

  @override
  String get backToGlobe => 'Back to the globe';

  @override
  String get allSections => 'All sections';

  @override
  String get close => 'Close';

  @override
  String get purpose => 'Purpose';

  @override
  String get tellWhereToGo => 'Tell me where you want to go';

  @override
  String get explore => 'Explore';

  @override
  String get seeAll => 'See all';

  @override
  String openScreen(String name) {
    return 'Open $name';
  }

  @override
  String get screens => 'Screens';

  @override
  String get smallerPanel => 'Smaller panel';

  @override
  String get biggerPanel => 'Bigger panel';

  @override
  String get nothingHereYetDot => 'Nothing here yet.';

  @override
  String get noStatsForSection => 'No stats for this section.';

  @override
  String get secStatsTagline => 'Analytics & performance';

  @override
  String get destPerformanceSub => 'Today, this week, this month & goals';

  @override
  String get destGradeStatsSub => 'Bronze to Diamond & Interdit';

  @override
  String get secCardsTagline => 'Smart tools & arena';

  @override
  String get secGamesTagline => 'Your gaming accounts';

  @override
  String get destAllGames => 'All Games';

  @override
  String get destForSaleSub => 'Accounts currently listed for sale';

  @override
  String get destGameSub => 'Accounts and statuses of this game';

  @override
  String get secGoogle => 'Google';

  @override
  String get secGoogleTagline => 'Google Play accounts';

  @override
  String get destGoogleAddSub => 'Add a new Google Play account';

  @override
  String get destGrades => 'Grades';

  @override
  String get destGradesSub => 'Statistics by grade';

  @override
  String get destBoxStatus => 'Box Status';

  @override
  String get destBoxStatusSub => 'Statistics by game box status';

  @override
  String get secProfileTagline => 'You & your progress';

  @override
  String get destMyProfile => 'My Profile';

  @override
  String get destMyProfileSub => 'Picture, info, rank & session';

  @override
  String get destAchievementsSub => 'Badges, progress & unlock dates';

  @override
  String get secSettingsTagline => 'Preferences & safety';

  @override
  String get destSettingsSub => 'Appearance, language, currency & data';

  @override
  String get destNotificationsSub => 'Warnings and reminders';

  @override
  String get destTrashSub => 'Restore removed accounts';

  @override
  String get orbScreens => 'Screens';

  @override
  String get orbSystem => 'System';

  @override
  String get orbNetProfit => 'Net profit';

  @override
  String get orbAccounts => 'Accounts';

  @override
  String get orbSold => 'Sold';

  @override
  String get orbForSale => 'For sale';

  @override
  String get orbActive => 'Active';

  @override
  String get orbAddedThisMonth => 'Added this month';

  @override
  String get orbGoogleAccounts => 'Google accounts';

  @override
  String get orbGamingAccounts => 'Gaming accounts';

  @override
  String get orbDuplicates => 'Duplicates';

  @override
  String get orbInVault => 'In vault';

  @override
  String get orbClean => 'Clean';

  @override
  String get orbGoogleDuplicates => 'Google duplicates';

  @override
  String get orbSameAccountId => 'Same account ID';

  @override
  String get orbGames => 'Games';

  @override
  String get orbListed => 'Listed';

  @override
  String get orbBoxesSet => 'Boxes set';

  @override
  String get orbDone => 'Done';

  @override
  String get orbPremium => 'Premium';

  @override
  String get orbName => 'Name';

  @override
  String get orbNotSet => 'Not set';

  @override
  String get orbUnlocked => 'Unlocked';

  @override
  String get orbPoints => 'Points';

  @override
  String get orbNextGoal => 'Next goal';

  @override
  String get orbAllDone => 'All done';

  @override
  String get orbTheme => 'Theme';

  @override
  String get orbMode => 'Mode';

  @override
  String get orbCurrency => 'Currency';

  @override
  String get orbLanguage => 'Language';

  @override
  String get orbAlerts => 'Alerts';

  @override
  String get orbReminders => 'Reminders';

  @override
  String get orbNotifications => 'Notifications';

  @override
  String get orbOn => 'On';

  @override
  String get orbOff => 'Off';

  @override
  String get orbInTrash => 'In trash';

  @override
  String get orbDataIssues => 'Data issues';

  @override
  String get orbNoMonthToCompare => 'No month to compare yet';

  @override
  String orbPctOnLastMonth(String pct) {
    return '$pct% on last month';
  }

  @override
  String get orbNothingListed => 'Nothing listed right now';

  @override
  String get orbListedNoPrice => 'Listed, no price set yet';

  @override
  String get orbBestGame => 'Best game';

  @override
  String get orbNoDataYet => 'No data yet';

  @override
  String get orbAddToRank => 'Add a game account to rank games';

  @override
  String orbFromAccounts(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
    );
    return '$amount from $_temp0';
  }

  @override
  String get orbDiamondAccounts => 'Diamond accounts';

  @override
  String orbOutOfGoogle(int count) {
    return 'Out of $count Google accounts';
  }

  @override
  String get orbDataHealth => 'Data health';

  @override
  String get orbAllClear => 'All clear';

  @override
  String orbToReview(int count) {
    return '$count to review';
  }

  @override
  String get orbNoDuplicatesOrIds => 'No duplicates or missing IDs';

  @override
  String get orbDuplicatesEmailsIds => 'Duplicates, bad emails or missing IDs';

  @override
  String get orbAchievements => 'Achievements';

  @override
  String get orbEveryBadge => 'Every badge unlocked';

  @override
  String orbNext(String title) {
    return 'Next: $title';
  }

  @override
  String get searchEveryScreen => 'Search every screen';

  @override
  String get howGlobeWorks => 'How the globe works';

  @override
  String percentSemantics(String label, String pct) {
    return '$label $pct percent';
  }

  @override
  String get open => 'Open';

  @override
  String get whereToGo => 'Where do you want to go?';

  @override
  String get searchScreenHint => 'Search a screen, like profit or vault';

  @override
  String get noScreenMatches => 'No screen matches that.';

  @override
  String screensCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count screens',
      one: '1 screen',
    );
    return '$_temp0';
  }

  @override
  String get globeHelpDrag => 'Drag the globe to turn it.';

  @override
  String get globeHelpTap =>
      'Tap a glowing node to see what is inside that continent.';

  @override
  String get globeHelpExplore =>
      'Press Explore to dive in, then tap a card to open the screen.';

  @override
  String get globeHelpSearch =>
      'The bar at the bottom finds any screen by name.';

  @override
  String get arenaStructSingleLeague => 'Single League';

  @override
  String get arenaStructMultipleLeagues => 'Multiple Leagues';

  @override
  String get arenaStructGroupsOnly => 'Groups Only';

  @override
  String get arenaStructGroupsKnockout => 'Groups + Knockout';

  @override
  String get arenaStructLeaguesGroupsKnockout => 'Leagues + Groups + Knockout';

  @override
  String get arenaStructKnockoutOnly => 'Knockout Only';

  @override
  String get arenaHintSingleLeague => 'Everyone plays everyone in one table.';

  @override
  String get arenaHintMultipleLeagues =>
      'Participants are split into several independent leagues.';

  @override
  String get arenaHintGroupsOnly =>
      'One league divided into groups, each with its own table.';

  @override
  String get arenaHintGroupsKnockout =>
      'Group stage, then the best qualify for a knockout bracket.';

  @override
  String get arenaHintLeaguesGroupsKnockout =>
      'Several leagues, each with groups; qualifiers meet in one knockout.';

  @override
  String get arenaHintKnockoutOnly =>
      'Single-elimination bracket with byes when needed.';

  @override
  String get arenaDetailUpTo48Players => 'up to 48 players';

  @override
  String get arenaDetailDuo => 'up to 24 teams · 2 players each';

  @override
  String get arenaDetailSquad => 'up to 12 teams · 4 players each';

  @override
  String get arenaDetailOnePerTeam => '1 player per team';

  @override
  String get arenaDetailUpTo2 => 'up to 2 players per team';

  @override
  String get arenaDetailUpTo4 => 'up to 4 players per team';

  @override
  String get arenaDetailUpTo8 => 'up to 8 players per team';

  @override
  String get arenaDetail1v1 => '1 vs 1';

  @override
  String get arenaDetailCoop => 'team vs team · up to 3 players per team';

  @override
  String get arenaDetailCustom => 'custom team size';

  @override
  String get arenaTbHeadToHead => 'Head-to-head';

  @override
  String get arenaTbGoalDifference => 'Goal difference';

  @override
  String get arenaTbGoalsScored => 'Goals scored';

  @override
  String get arenaTbGoalsAgainst => 'Goals against';

  @override
  String get arenaTbShortH2h => 'H2H';

  @override
  String get arenaTbShortGd => 'GD';

  @override
  String get arenaTbShortGf => 'GF';

  @override
  String get arenaTbShortGa => 'GA';

  @override
  String get arenaTbExplainH2h =>
      'Teams level on points are ranked by the matches they played against each other: points first, then goal difference in those matches.';

  @override
  String get arenaTbExplainGd =>
      'Goals scored minus goals conceded over all matches.';

  @override
  String get arenaTbExplainGf =>
      'The team that scored more goals ranks higher.';

  @override
  String get arenaTbExplainGa =>
      'The team that conceded fewer goals ranks higher.';

  @override
  String get arenaKoPenalties => 'Penalties';

  @override
  String get arenaKoExtraTime => 'Extra time';

  @override
  String get arenaKoReplay => 'Replay';

  @override
  String get arenaKoHintPenalties =>
      'Level after normal time: decided by a penalty shoot-out.';

  @override
  String get arenaKoHintExtraTime =>
      'Level after normal time: extra time is played. If still level, penalties decide.';

  @override
  String get arenaKoHintReplay =>
      'Level after normal time: the match is played again until there is a winner.';

  @override
  String get arenaAet => 'a.e.t.';

  @override
  String get arenaPens => 'pens';

  @override
  String get arenaColPldShort => 'Pld';

  @override
  String get arenaColWShort => 'W';

  @override
  String get arenaColDShort => 'D';

  @override
  String get arenaColLShort => 'L';

  @override
  String get arenaColGfShort => 'GF';

  @override
  String get arenaColGaShort => 'GA';

  @override
  String get arenaColGdShort => 'GD';

  @override
  String get arenaColPtsShort => 'Pts';

  @override
  String get arenaColPlayed => 'Played';

  @override
  String get arenaColWins => 'Wins';

  @override
  String get arenaColDraws => 'Draws';

  @override
  String get arenaColLosses => 'Losses';

  @override
  String get arenaColGoalsFor => 'Goals for';

  @override
  String get arenaColGoalsAgainst => 'Goals against';

  @override
  String get arenaColGoalDifference => 'Goal difference';

  @override
  String get arenaColPoints => 'Points';

  @override
  String arenaScorePens(String score, String pens) {
    return '$score ($pens pens)';
  }

  @override
  String get arenaErrKillPoints => 'Kill points cannot be negative.';

  @override
  String arenaErrPlacementRows(int slots, int count) {
    return 'The placement table needs exactly $slots rows (one per participant or team); it has $count.';
  }

  @override
  String get arenaErrPlacementNegative =>
      'Placement points cannot be negative.';

  @override
  String arenaErrPlacementOrder(int lower, int higher) {
    return 'A lower placement cannot score more than a higher one (#$lower scores more than #$higher).';
  }

  @override
  String get arenaErrFirstPlace => '1st place must score more than 0.';

  @override
  String arenaErrZeroTail(int count) {
    return 'The last $count placements must score 0 placement points.';
  }

  @override
  String get arenaTbd => 'TBD';

  @override
  String get arenaUnknown => 'Unknown';

  @override
  String get arenaErrNameRequired => 'Tournament name is required.';

  @override
  String get arenaErrMin2 => 'Add at least 2 participants.';

  @override
  String arenaErrTooMany(int count, int max) {
    return 'Participants ($count) exceed the maximum ($max).';
  }

  @override
  String get arenaErrDeadline =>
      'Registration deadline must be on or before the start date.';

  @override
  String get arenaErrWinPoints =>
      'Win points must be at least the draw points.';

  @override
  String get arenaErrMinColumns =>
      'Show at least 1 column in the standings table.';

  @override
  String arenaErrMaxColumns(int max) {
    return 'The standings table can show at most $max columns.';
  }

  @override
  String get arenaErrMinRounds => 'Plan at least 1 round.';

  @override
  String get arenaErrMinLeagues => 'Use at least 2 leagues.';

  @override
  String get arenaErrMinGroups => 'Use at least 2 groups per league.';

  @override
  String arenaErrNotEnough(int leagues, int groups, int min) {
    return 'Not enough participants: $leagues league(s) x $groups group(s) need at least $min.';
  }

  @override
  String get arenaErrMinQualifier =>
      'At least 1 qualifier per group is required.';

  @override
  String arenaErrQualifiersExceed(int q, int min) {
    return 'Qualifiers per group ($q) exceed the smallest group size ($min).';
  }

  @override
  String get arenaErrMin2Qualify =>
      'At least 2 participants must qualify for the knockout.';

  @override
  String arenaErrWinnerColumns(String mode, String columns) {
    return '$mode is decided by the winner: pick at least one of $columns.';
  }

  @override
  String arenaErrMaxTeams(String mode, int cap, int count) {
    return '$mode allows at most $cap teams (you have $count).';
  }

  @override
  String arenaErrMaxPlayers(String mode, int cap, int count) {
    return '$mode allows at most $cap players (you have $count).';
  }

  @override
  String arenaErrMinTeamsBr(String mode, int min, int tail) {
    return '$mode needs at least $min teams (placement points are not awarded to the last $tail places).';
  }

  @override
  String arenaErrMinPlayersBr(String mode, int min, int tail) {
    return '$mode needs at least $min players (placement points are not awarded to the last $tail places).';
  }

  @override
  String arenaErrExactPlayers(String name, int size) {
    return '\"$name\" must have exactly $size players.';
  }

  @override
  String arenaErrBetweenPlayers(String name, int size) {
    return '\"$name\" must have between 1 and $size players.';
  }

  @override
  String arenaErrAssignedTwice(String name) {
    return 'Player \"$name\" is assigned twice.';
  }

  @override
  String arenaErrAppearsTwice(String name) {
    return 'Player \"$name\" appears more than once.';
  }

  @override
  String arenaErrMinTotalPlayers(int min, int total) {
    return 'At least $min players must be registered in total (currently $total).';
  }

  @override
  String arenaLogCreatedBr(int count) {
    return 'Tournament created: $count Battle Royale round(s)';
  }

  @override
  String get arenaLogCreatedKo =>
      'Tournament created: knockout bracket generated';

  @override
  String arenaLogCreatedFixtures(int count) {
    return 'Tournament created: $count fixtures generated';
  }

  @override
  String get arenaLeague => 'League';

  @override
  String arenaLeagueLetter(String letter) {
    return 'League $letter';
  }

  @override
  String arenaGroupName(String name) {
    return 'Group $name';
  }

  @override
  String get arenaFinal => 'Final';

  @override
  String get arenaSemiFinals => 'Semi-finals';

  @override
  String get arenaQuarterFinals => 'Quarter-finals';

  @override
  String arenaRoundOf(int count) {
    return 'Round of $count';
  }

  @override
  String get arenaCritPoints => 'Points';

  @override
  String get arenaCritAllLevel => 'Level on all criteria (name order)';

  @override
  String arenaNoteMorePoints(String a, int pa, int pb) {
    return '$a has more points ($pa vs $pb).';
  }

  @override
  String arenaNoteH2hBeat(int points, String a, String b, String score) {
    return 'Level on $points pts. Head-to-head: $a beat $b $score in their direct match.';
  }

  @override
  String arenaNoteH2hRecord(int points, String a) {
    return 'Level on $points pts. Head-to-head: $a has the better record in the matches between the tied teams.';
  }

  @override
  String arenaNoteGd(int points, String a, String va, String b, String vb) {
    return 'Level on $points pts. Goal difference: $a $va vs $b $vb.';
  }

  @override
  String arenaNoteGf(int points, String a, int va, String b, int vb) {
    return 'Level on $points pts. Goals scored: $a $va vs $b $vb.';
  }

  @override
  String arenaNoteGa(int points, String a, int va, String b, int vb) {
    return 'Level on $points pts. Goals against: $a $va vs $b $vb (fewer is better).';
  }

  @override
  String get arenaNoteByName => 'Level on every criterion: ranked by name.';

  @override
  String get arenaErrNoGroupStage =>
      'This tournament has no group stage to qualify from.';

  @override
  String get arenaErrKoAlready => 'The knockout stage was already generated.';

  @override
  String get arenaErrConfirmGroups =>
      'Confirm every group match before generating the knockout.';

  @override
  String get arenaErrMin2Qualified => 'At least 2 participants must qualify.';

  @override
  String arenaLogKoGenerated(int count) {
    return 'Knockout generated from group standings ($count qualifiers)';
  }

  @override
  String get arenaErrScoredMode =>
      'This mode is scored with a result, not by picking a winner.';

  @override
  String get arenaErrMatchNotFound => 'Match not found.';

  @override
  String get arenaErrWinnerSide => 'The winner must be one of the two sides.';

  @override
  String get arenaErrByeNoResult => 'A bye has no result.';

  @override
  String get arenaErrCancelled => 'This match was cancelled.';

  @override
  String get arenaErrBothKnown => 'Both participants must be known first.';

  @override
  String get arenaErrNegativeScore => 'Scores cannot be negative.';

  @override
  String get arenaErrKoLocksGroups =>
      'The knockout stage is already generated. Reset results to change group scores.';

  @override
  String get arenaErrNextRoundPlayed =>
      'The next round was already played. Reset results to change this score.';

  @override
  String arenaLogReplay(String score, String home, String away, int n) {
    return 'Draw $score: $home vs $away will be replayed (replay #$n)';
  }

  @override
  String get arenaErrEnterPensAfterNormal =>
      'Level after normal time: enter the penalty shoot-out score.';

  @override
  String get arenaErrEnterPensAfterExtra =>
      'Level after extra time: enter the penalty shoot-out score.';

  @override
  String get arenaErrNegativePens => 'Penalty scores cannot be negative.';

  @override
  String get arenaErrPensWinner => 'A penalty shoot-out needs a winner.';

  @override
  String arenaLogAmended(String names) {
    return 'Result amended: $names';
  }

  @override
  String arenaLogConfirmed(String names) {
    return 'Result confirmed: $names';
  }

  @override
  String get arenaLockBrConfirmed =>
      'A Battle Royale round is already confirmed. Reset results to change rosters.';

  @override
  String get arenaLockPlayed =>
      'A match of these teams was already played. Reset results to make this change.';

  @override
  String get arenaErrParticipantNotFound => 'Participant not found.';

  @override
  String get arenaErrNameEmpty => 'The name cannot be empty.';

  @override
  String arenaLogRenamed(String old, String name) {
    return 'Renamed: $old -> $name';
  }

  @override
  String get arenaErrNoRosters => 'This mode has no team rosters.';

  @override
  String get arenaErrTeamNeedsPlayer => 'A team needs at least 1 player.';

  @override
  String arenaErrMaxPerTeam(String mode, int size) {
    return '$mode allows at most $size players per team.';
  }

  @override
  String arenaErrExactPerTeam(int size) {
    return 'Every team must have exactly $size players.';
  }

  @override
  String get arenaErrPlayerNameEmpty => 'Player names cannot be empty.';

  @override
  String arenaErrAlreadyInTeam(String name) {
    return '\"$name\" is already assigned to a team.';
  }

  @override
  String arenaErrAlreadyRegistered(String name) {
    return '\"$name\" is already registered.';
  }

  @override
  String arenaLogRoster(String team, int count) {
    return 'Roster updated: $team ($count players)';
  }

  @override
  String get arenaErrChooseTwo => 'Choose two different ones.';

  @override
  String arenaLogSwapped(String a, String b) {
    return 'Swapped: $a <-> $b';
  }

  @override
  String get arenaErrChooseTwoPlayers => 'Choose two different players.';

  @override
  String get arenaErrPlayerNotInTeam => 'Player not found in that team.';

  @override
  String arenaLogPlayersSwapped(String a, String ta, String b, String tb) {
    return 'Players swapped: $a ($ta) <-> $b ($tb)';
  }

  @override
  String get arenaErrOnlyBrRounds =>
      'Only Battle Royale tournaments have rounds.';

  @override
  String arenaLogRoundAdded(int n) {
    return 'Round $n added';
  }

  @override
  String get arenaErrRoundNotFound => 'Round not found.';

  @override
  String get arenaErrUnknownInResults => 'Unknown participant in results.';

  @override
  String get arenaErrEnterPlacements =>
      'Enter a placement for every participant.';

  @override
  String arenaErrPlacementRange(int n) {
    return 'Placements must be between 1 and $n.';
  }

  @override
  String arenaErrSamePlacement(int n) {
    return 'Two participants have placement $n.';
  }

  @override
  String get arenaErrNegativeKills => 'Kills cannot be negative.';

  @override
  String arenaLogRoundAmended(int n) {
    return 'Round $n amended';
  }

  @override
  String arenaLogRoundConfirmed(int n) {
    return 'Round $n confirmed';
  }

  @override
  String get arenaCritWins => 'Wins';

  @override
  String get arenaCritKills => 'Kills';

  @override
  String get arenaCritLastRound => 'Last round placement';

  @override
  String get arenaCritNameOrder => 'Name order';

  @override
  String arenaBrNoteWins(int points, String a, int wa, String b, int wb) {
    return 'Level on $points pts. Wins (1st places): $a $wa vs $b $wb.';
  }

  @override
  String arenaBrNoteKills(int points, String a, int ka, String b, int kb) {
    return 'Level on $points pts and wins. Kills: $a $ka vs $b $kb.';
  }

  @override
  String arenaBrNoteLastRound(String a) {
    return 'Level on points, wins and kills. Better placement in the latest round: $a.';
  }

  @override
  String get arenaLogReset => 'All results were reset by the organizer';
}
