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
}
