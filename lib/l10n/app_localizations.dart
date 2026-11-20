import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navOrbit.
  ///
  /// In en, this message translates to:
  /// **'Orbit'**
  String get navOrbit;

  /// No description provided for @navCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get navCards;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @askSphera.
  ///
  /// In en, this message translates to:
  /// **'Ask SPHERA'**
  String get askSphera;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @forSale.
  ///
  /// In en, this message translates to:
  /// **'For Sale'**
  String get forSale;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Account'**
  String get addAccount;

  /// No description provided for @searchAccount.
  ///
  /// In en, this message translates to:
  /// **'Search Account'**
  String get searchAccount;

  /// No description provided for @manageGames.
  ///
  /// In en, this message translates to:
  /// **'Manage Games'**
  String get manageGames;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @vsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{arrow} {pct}% vs last month'**
  String vsLastMonth(String arrow, String pct);

  /// No description provided for @thisMonthAmount.
  ///
  /// In en, this message translates to:
  /// **'This month {amount}'**
  String thisMonthAmount(String amount);

  /// No description provided for @totalAccounts.
  ///
  /// In en, this message translates to:
  /// **'Total Accounts'**
  String get totalAccounts;

  /// No description provided for @noneAddedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'None added this month'**
  String get noneAddedThisMonth;

  /// No description provided for @addedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'+{count} this month'**
  String addedThisMonth(int count);

  /// No description provided for @activeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Active Accounts'**
  String get activeAccounts;

  /// No description provided for @noAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get noAccountsYet;

  /// No description provided for @percentOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{pct}% of total'**
  String percentOfTotal(int pct);

  /// No description provided for @nothingListed.
  ///
  /// In en, this message translates to:
  /// **'Nothing listed'**
  String get nothingListed;

  /// No description provided for @listedNoPrice.
  ///
  /// In en, this message translates to:
  /// **'Listed, no price'**
  String get listedNoPrice;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get performance;

  /// No description provided for @profitByDateAdded.
  ///
  /// In en, this message translates to:
  /// **'Profit by date added'**
  String get profitByDateAdded;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @accountsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account} other{{count} accounts}}'**
  String accountsCount(int count);

  /// No description provided for @gamesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 game} other{{count} games}}'**
  String gamesCount(int count);

  /// No description provided for @weekOf.
  ///
  /// In en, this message translates to:
  /// **'Week of {date}'**
  String weekOf(String date);

  /// No description provided for @noAccountsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No accounts added in this period'**
  String get noAccountsInPeriod;

  /// No description provided for @actionAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get actionAdded;

  /// No description provided for @actionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get actionUpdated;

  /// No description provided for @actionStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Status changed'**
  String get actionStatusChanged;

  /// No description provided for @actionMovedToTrash.
  ///
  /// In en, this message translates to:
  /// **'Moved to trash'**
  String get actionMovedToTrash;

  /// No description provided for @actionRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get actionRestored;

  /// No description provided for @actionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get actionDeleted;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String hoursAgo(int count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @noActivityYet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.\nNew actions will appear here.'**
  String get noActivityYet;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @analyticsCenter.
  ///
  /// In en, this message translates to:
  /// **'Analytics Center'**
  String get analyticsCenter;

  /// No description provided for @profitCenter.
  ///
  /// In en, this message translates to:
  /// **'Profit Center'**
  String get profitCenter;

  /// No description provided for @profitCenterSub.
  ///
  /// In en, this message translates to:
  /// **'Sales, expenses, purchase & sale price, net profit'**
  String get profitCenterSub;

  /// No description provided for @activityCenter.
  ///
  /// In en, this message translates to:
  /// **'Activity Center'**
  String get activityCenter;

  /// No description provided for @activityCenterSub.
  ///
  /// In en, this message translates to:
  /// **'Activity log, filter by date & type'**
  String get activityCenterSub;

  /// No description provided for @performanceCenter.
  ///
  /// In en, this message translates to:
  /// **'Performance Center'**
  String get performanceCenter;

  /// No description provided for @performanceCenterSub.
  ///
  /// In en, this message translates to:
  /// **'Daily, weekly, monthly & goals'**
  String get performanceCenterSub;

  /// No description provided for @spheraIntelligence.
  ///
  /// In en, this message translates to:
  /// **'SPHERA Intelligence'**
  String get spheraIntelligence;

  /// No description provided for @spheraIntelligenceSub.
  ///
  /// In en, this message translates to:
  /// **'Offline analysis of your accounts'**
  String get spheraIntelligenceSub;

  /// No description provided for @gradeStatistics.
  ///
  /// In en, this message translates to:
  /// **'Grade Statistics'**
  String get gradeStatistics;

  /// No description provided for @gradeStatisticsSub.
  ///
  /// In en, this message translates to:
  /// **'Bronze, Silver, Gold, Platinum, Diamond & Interdit'**
  String get gradeStatisticsSub;

  /// No description provided for @statusStatistics.
  ///
  /// In en, this message translates to:
  /// **'Status Statistics'**
  String get statusStatistics;

  /// No description provided for @statusStatisticsSub.
  ///
  /// In en, this message translates to:
  /// **'Google boxes and gaming accounts, each on its own'**
  String get statusStatisticsSub;

  /// No description provided for @gamesStatistics.
  ///
  /// In en, this message translates to:
  /// **'Games Statistics'**
  String get gamesStatistics;

  /// No description provided for @gamesStatisticsSub.
  ///
  /// In en, this message translates to:
  /// **'Profit, counts & status per game'**
  String get gamesStatisticsSub;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @googlePlayAccounts.
  ///
  /// In en, this message translates to:
  /// **'Google Play Accounts'**
  String get googlePlayAccounts;

  /// No description provided for @googlePlayAccountsSub.
  ///
  /// In en, this message translates to:
  /// **'Grades & game boxes'**
  String get googlePlayAccountsSub;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @gamesSub.
  ///
  /// In en, this message translates to:
  /// **'Gaming account inventory'**
  String get gamesSub;

  /// No description provided for @statisticsSub.
  ///
  /// In en, this message translates to:
  /// **'Profit, counts & statuses'**
  String get statisticsSub;

  /// No description provided for @toolsSettings.
  ///
  /// In en, this message translates to:
  /// **'Tools & Settings'**
  String get toolsSettings;

  /// No description provided for @toolsSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Backup, trash, profile'**
  String get toolsSettingsSub;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @arenaTitle.
  ///
  /// In en, this message translates to:
  /// **'SPHERA TOURNAMENT ARENA'**
  String get arenaTitle;

  /// No description provided for @arenaSub.
  ///
  /// In en, this message translates to:
  /// **'Leagues, groups & knockouts'**
  String get arenaSub;

  /// No description provided for @createOne.
  ///
  /// In en, this message translates to:
  /// **'Create one'**
  String get createOne;

  /// No description provided for @tournamentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tournament} other{{count} tournaments}}'**
  String tournamentsCount(int count);

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsSub.
  ///
  /// In en, this message translates to:
  /// **'Badges & milestones'**
  String get achievementsSub;

  /// No description provided for @achievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} unlocked'**
  String achievementsUnlocked(int done, int total);

  /// No description provided for @smartTools.
  ///
  /// In en, this message translates to:
  /// **'Smart Tools'**
  String get smartTools;

  /// No description provided for @duplicateScanner.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Scanner'**
  String get duplicateScanner;

  /// No description provided for @duplicateScannerSub.
  ///
  /// In en, this message translates to:
  /// **'Find duplicate accounts, review manually'**
  String get duplicateScannerSub;

  /// No description provided for @noDuplicates.
  ///
  /// In en, this message translates to:
  /// **'No duplicates'**
  String get noDuplicates;

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String toReview(int count);

  /// No description provided for @smartOrganizer.
  ///
  /// In en, this message translates to:
  /// **'Smart Organizer'**
  String get smartOrganizer;

  /// No description provided for @smartOrganizerSub.
  ///
  /// In en, this message translates to:
  /// **'Search, filter & sort accounts'**
  String get smartOrganizerSub;

  /// No description provided for @smartOrganizerSummary.
  ///
  /// In en, this message translates to:
  /// **'By game, status, grade & date'**
  String get smartOrganizerSummary;

  /// No description provided for @inventoryVault.
  ///
  /// In en, this message translates to:
  /// **'Inventory Vault'**
  String get inventoryVault;

  /// No description provided for @inventoryVaultSub.
  ///
  /// In en, this message translates to:
  /// **'Favourite, rare & high-value accounts'**
  String get inventoryVaultSub;

  /// No description provided for @inVault.
  ///
  /// In en, this message translates to:
  /// **'{count} in vault'**
  String inVault(int count);

  /// No description provided for @securityCenter.
  ///
  /// In en, this message translates to:
  /// **'Security Center'**
  String get securityCenter;

  /// No description provided for @securityCenterSub.
  ///
  /// In en, this message translates to:
  /// **'Data health, backup & sync status'**
  String get securityCenterSub;

  /// No description provided for @allGood.
  ///
  /// In en, this message translates to:
  /// **'All good'**
  String get allGood;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @profileSecurity.
  ///
  /// In en, this message translates to:
  /// **'Profile & Security'**
  String get profileSecurity;

  /// No description provided for @localMode.
  ///
  /// In en, this message translates to:
  /// **'Local mode'**
  String get localMode;

  /// No description provided for @localModeSub.
  ///
  /// In en, this message translates to:
  /// **'Not signed in. Your data is stored on this device only. Account sign-in and cloud sync are not connected yet.'**
  String get localModeSub;

  /// No description provided for @protectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Protection & privacy'**
  String get protectionPrivacy;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @autoFollowsPhone.
  ///
  /// In en, this message translates to:
  /// **'Auto follows your phone\'s dark / light setting.'**
  String get autoFollowsPhone;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @onRemindersOn.
  ///
  /// In en, this message translates to:
  /// **'On · Reminders on'**
  String get onRemindersOn;

  /// No description provided for @onRemindersOff.
  ///
  /// In en, this message translates to:
  /// **'On · Reminders off'**
  String get onRemindersOff;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemsCount(int count);

  /// No description provided for @storedItems.
  ///
  /// In en, this message translates to:
  /// **'Stored items & assets'**
  String get storedItems;

  /// No description provided for @aboutSphera.
  ///
  /// In en, this message translates to:
  /// **'About SPHERA'**
  String get aboutSphera;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// No description provided for @aboutText.
  ///
  /// In en, this message translates to:
  /// **'Google Play accounts, gaming accounts, prices and statistics in one place.'**
  String get aboutText;

  /// No description provided for @ratesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates updated.'**
  String get ratesUpdated;

  /// No description provided for @dhIsBase.
  ///
  /// In en, this message translates to:
  /// **'DH is the base currency: amounts are stored in DH.'**
  String get dhIsBase;

  /// No description provided for @liveRate.
  ///
  /// In en, this message translates to:
  /// **'Live rate, updated {when}'**
  String liveRate(String when);

  /// No description provided for @approximateRate.
  ///
  /// In en, this message translates to:
  /// **'Approximate rate, not live yet. Tap \"Update rates\" when online.'**
  String get approximateRate;

  /// No description provided for @conversionNote.
  ///
  /// In en, this message translates to:
  /// **'Every price is converted at this rate for display, and what you type is converted back to DH when saved.'**
  String get conversionNote;

  /// No description provided for @updateRates.
  ///
  /// In en, this message translates to:
  /// **'Update rates'**
  String get updateRates;

  /// No description provided for @authNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get authNeedHelp;

  /// No description provided for @authHelpBody.
  ///
  /// In en, this message translates to:
  /// **'New here? Choose \"Create a new account\".\n\nAlready registered on this device? Choose \"I have an existing account\".\n\nCan\'t get in? Use \"I have a problem in login & password\".'**
  String get authHelpBody;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @authVerifyUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification is not available yet'**
  String get authVerifyUnavailableTitle;

  /// No description provided for @authVerifyUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Codes by email or SMS need an online service, which is not connected to SPHERA yet.\n\nYou can reset the login on this device instead and create a new one. Your accounts, games and statistics are kept.\n\nThis login only protects casual access to the app on this device.'**
  String get authVerifyUnavailableBody;

  /// No description provided for @authResetLogin.
  ///
  /// In en, this message translates to:
  /// **'Reset login'**
  String get authResetLogin;

  /// No description provided for @authOops.
  ///
  /// In en, this message translates to:
  /// **'Oops!'**
  String get authOops;

  /// No description provided for @authHintEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'email or phone number'**
  String get authHintEmailOrPhone;

  /// No description provided for @authHintCode.
  ///
  /// In en, this message translates to:
  /// **'validation code'**
  String get authHintCode;

  /// No description provided for @authLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLogin;

  /// No description provided for @authEnterUserAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your username and password.'**
  String get authEnterUserAndPassword;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'WELCOME!'**
  String get authWelcomeTitle;

  /// No description provided for @authHintUsername.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get authHintUsername;

  /// No description provided for @authHintPassword.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get authHintPassword;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'you forgot your password?'**
  String get authForgotPassword;

  /// No description provided for @authProfilePhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile photo (optional)'**
  String get authProfilePhotoOptional;

  /// No description provided for @authHintChooseUsername.
  ///
  /// In en, this message translates to:
  /// **'choose a username'**
  String get authHintChooseUsername;

  /// No description provided for @authHintCreatePassword.
  ///
  /// In en, this message translates to:
  /// **'create a password'**
  String get authHintCreatePassword;

  /// No description provided for @authHintConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'confirm your password'**
  String get authHintConfirmPassword;

  /// No description provided for @authConfirmInfo.
  ///
  /// In en, this message translates to:
  /// **'I confirm my information is correct'**
  String get authConfirmInfo;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authYourAge.
  ///
  /// In en, this message translates to:
  /// **'your age'**
  String get authYourAge;

  /// No description provided for @authHelloTitle.
  ///
  /// In en, this message translates to:
  /// **'HELLO!'**
  String get authHelloTitle;

  /// No description provided for @authCreateNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get authCreateNewAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I have an existing account'**
  String get authHaveAccount;

  /// No description provided for @authLoginProblem.
  ///
  /// In en, this message translates to:
  /// **'I have a problem in login & password'**
  String get authLoginProblem;

  /// No description provided for @valEnterIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number'**
  String get valEnterIdentifier;

  /// No description provided for @valInvalidIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email or phone number'**
  String get valInvalidIdentifier;

  /// No description provided for @valChooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose a username'**
  String get valChooseUsername;

  /// No description provided for @valUsernameRule.
  ///
  /// In en, this message translates to:
  /// **'3-20 characters: letters, numbers, _ or .'**
  String get valUsernameRule;

  /// No description provided for @valCreatePassword.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get valCreatePassword;

  /// No description provided for @valPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get valPasswordLength;

  /// No description provided for @valPasswordMix.
  ///
  /// In en, this message translates to:
  /// **'Use both letters and numbers'**
  String get valPasswordMix;

  /// No description provided for @valConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get valConfirmPassword;

  /// No description provided for @valPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get valPasswordsMismatch;

  /// No description provided for @valMinAge.
  ///
  /// In en, this message translates to:
  /// **'SPHERA is for users {age} and older'**
  String valMinAge(int age);

  /// No description provided for @valInvalidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age'**
  String get valInvalidAge;

  /// No description provided for @authErrAccountExists.
  ///
  /// In en, this message translates to:
  /// **'An account already exists on this device. Log in instead.'**
  String get authErrAccountExists;

  /// No description provided for @authErrWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong username or password.'**
  String get authErrWrongCredentials;

  /// No description provided for @authNoCode.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t receive the verification code'**
  String get authNoCode;

  /// No description provided for @boxEmpty.
  ///
  /// In en, this message translates to:
  /// **'EMPTY'**
  String get boxEmpty;

  /// No description provided for @boxDone.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get boxDone;

  /// No description provided for @boxNotYet.
  ///
  /// In en, this message translates to:
  /// **'NOT YET'**
  String get boxNotYet;

  /// No description provided for @boxComing.
  ///
  /// In en, this message translates to:
  /// **'COMING'**
  String get boxComing;

  /// No description provided for @gradeBronze.
  ///
  /// In en, this message translates to:
  /// **'Bronze'**
  String get gradeBronze;

  /// No description provided for @gradeSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get gradeSilver;

  /// No description provided for @gradeGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gradeGold;

  /// No description provided for @gradePlatinum.
  ///
  /// In en, this message translates to:
  /// **'Platinum'**
  String get gradePlatinum;

  /// No description provided for @gradeDiamond.
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get gradeDiamond;

  /// No description provided for @gradeInterdit.
  ///
  /// In en, this message translates to:
  /// **'Interdit'**
  String get gradeInterdit;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get statusActive;

  /// No description provided for @statusSold.
  ///
  /// In en, this message translates to:
  /// **'SOLD'**
  String get statusSold;

  /// No description provided for @statusForSale.
  ///
  /// In en, this message translates to:
  /// **'FOR SALE'**
  String get statusForSale;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @couldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save: {error}'**
  String couldNotSave(String error);

  /// No description provided for @errDuplicateEmail.
  ///
  /// In en, this message translates to:
  /// **'A Google account with {email} already exists.'**
  String errDuplicateEmail(String email);

  /// No description provided for @errDuplicateGame.
  ///
  /// In en, this message translates to:
  /// **'A game named \"{name}\" already exists.'**
  String errDuplicateGame(String name);

  /// No description provided for @editGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Google Account'**
  String get editGoogleAccount;

  /// No description provided for @addGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Add Google Account'**
  String get addGoogleAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @grade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get grade;

  /// No description provided for @gameBoxes.
  ///
  /// In en, this message translates to:
  /// **'Game boxes'**
  String get gameBoxes;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @addAccountShort.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccountShort;

  /// No description provided for @movedToTrash.
  ///
  /// In en, this message translates to:
  /// **'{name} moved to Trash'**
  String movedToTrash(String name);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @manageGamesLower.
  ///
  /// In en, this message translates to:
  /// **'Manage games'**
  String get manageGamesLower;

  /// No description provided for @couldNotLoadAccounts.
  ///
  /// In en, this message translates to:
  /// **'Could not load accounts: {error}'**
  String couldNotLoadAccounts(String error);

  /// No description provided for @searchByEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by email'**
  String get searchByEmail;

  /// No description provided for @allGrades.
  ///
  /// In en, this message translates to:
  /// **'All grades'**
  String get allGrades;

  /// No description provided for @anyStatus.
  ///
  /// In en, this message translates to:
  /// **'Any status'**
  String get anyStatus;

  /// No description provided for @boxesSet.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 box set} other{{count} boxes set}}'**
  String boxesSet(int count);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @moveToTrash.
  ///
  /// In en, this message translates to:
  /// **'Move to Trash'**
  String get moveToTrash;

  /// No description provided for @setBoxes.
  ///
  /// In en, this message translates to:
  /// **'Set boxes'**
  String get setBoxes;

  /// No description provided for @box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get box;

  /// No description provided for @noAccountMatches.
  ///
  /// In en, this message translates to:
  /// **'No account matches your filters'**
  String get noAccountMatches;

  /// No description provided for @noGoogleAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No Google accounts yet'**
  String get noGoogleAccountsYet;

  /// No description provided for @addFirstAccount.
  ///
  /// In en, this message translates to:
  /// **'Add your first account'**
  String get addFirstAccount;

  /// No description provided for @enterGameName.
  ///
  /// In en, this message translates to:
  /// **'Enter a game name'**
  String get enterGameName;

  /// No description provided for @couldNotAddGame.
  ///
  /// In en, this message translates to:
  /// **'Could not add game: {error}'**
  String couldNotAddGame(String error);

  /// No description provided for @removeGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removeGameTitle(String name);

  /// No description provided for @removeGameWithAccounts.
  ///
  /// In en, this message translates to:
  /// **'{name} has {count, plural, =1{1 gaming account} other{{count} gaming accounts}}. They are kept, but the game and its boxes will be hidden from the lists.'**
  String removeGameWithAccounts(String name, int count);

  /// No description provided for @removeGameNoAccounts.
  ///
  /// In en, this message translates to:
  /// **'The game and its boxes will be hidden from the lists.'**
  String get removeGameNoAccounts;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @newGameName.
  ///
  /// In en, this message translates to:
  /// **'New game name'**
  String get newGameName;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @removeGame.
  ///
  /// In en, this message translates to:
  /// **'Remove game'**
  String get removeGame;

  /// No description provided for @accountNoLongerAvailable.
  ///
  /// In en, this message translates to:
  /// **'Account no longer available'**
  String get accountNoLongerAvailable;

  /// No description provided for @couldNotSetPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not set photo: {error}'**
  String couldNotSetPhoto(String error);

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @removedGame.
  ///
  /// In en, this message translates to:
  /// **'Removed game'**
  String get removedGame;

  /// No description provided for @idCompte.
  ///
  /// In en, this message translates to:
  /// **'ID compte'**
  String get idCompte;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get purchasePrice;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale price'**
  String get salePrice;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @enterNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a number'**
  String get enterNumber;

  /// No description provided for @mustBeZeroOrMore.
  ///
  /// In en, this message translates to:
  /// **'Must be 0 or more'**
  String get mustBeZeroOrMore;

  /// No description provided for @chooseGame.
  ///
  /// In en, this message translates to:
  /// **'Choose a game'**
  String get chooseGame;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @idCompteRequired.
  ///
  /// In en, this message translates to:
  /// **'ID compte is required'**
  String get idCompteRequired;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @noAccountsYetShort.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet'**
  String get noAccountsYetShort;

  /// No description provided for @gameName.
  ///
  /// In en, this message translates to:
  /// **'Game name'**
  String get gameName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @addGame.
  ///
  /// In en, this message translates to:
  /// **'Add game'**
  String get addGame;

  /// No description provided for @renameGame.
  ///
  /// In en, this message translates to:
  /// **'Rename game'**
  String get renameGame;

  /// No description provided for @couldNotSetImage.
  ///
  /// In en, this message translates to:
  /// **'Could not set image: {error}'**
  String couldNotSetImage(String error);

  /// No description provided for @removeGameKeepsAccounts.
  ///
  /// In en, this message translates to:
  /// **'{name} has {count, plural, =1{1 account} other{{count} accounts}}. They are kept, but the game is hidden from the lists.'**
  String removeGameKeepsAccounts(String name, int count);

  /// No description provided for @removeGameHidden.
  ///
  /// In en, this message translates to:
  /// **'The game will be hidden from the lists.'**
  String get removeGameHidden;

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get noGamesYet;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @changeGameImage.
  ///
  /// In en, this message translates to:
  /// **'Change game image'**
  String get changeGameImage;

  /// No description provided for @changeAccountPhoto.
  ///
  /// In en, this message translates to:
  /// **'Change account photo'**
  String get changeAccountPhoto;

  /// No description provided for @resetImages.
  ///
  /// In en, this message translates to:
  /// **'Reset images'**
  String get resetImages;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysCount(int count);

  /// No description provided for @accountsForSaleList.
  ///
  /// In en, this message translates to:
  /// **'Accounts for sale ({count}):'**
  String accountsForSaleList(int count);

  /// No description provided for @listCopied.
  ///
  /// In en, this message translates to:
  /// **'List copied (no prices)'**
  String get listCopied;

  /// No description provided for @forSaleCount.
  ///
  /// In en, this message translates to:
  /// **'For Sale ({count})'**
  String forSaleCount(int count);

  /// No description provided for @copyListNoPrices.
  ///
  /// In en, this message translates to:
  /// **'Copy list without prices'**
  String get copyListNoPrices;

  /// No description provided for @nothingForSale.
  ///
  /// In en, this message translates to:
  /// **'Nothing is listed for sale.\nOpen an account and choose \"List for sale\".'**
  String get nothingForSale;

  /// No description provided for @listed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get listed;

  /// No description provided for @gamesWord.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Game} other{Games}}'**
  String gamesWord(int count);

  /// No description provided for @longestWait.
  ///
  /// In en, this message translates to:
  /// **'Longest wait'**
  String get longestWait;

  /// No description provided for @searchNameIdGame.
  ///
  /// In en, this message translates to:
  /// **'Search name, ID or game'**
  String get searchNameIdGame;

  /// No description provided for @allCount.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String allCount(int count);

  /// No description provided for @noMatch.
  ///
  /// In en, this message translates to:
  /// **'No match'**
  String get noMatch;

  /// No description provided for @waitingFor.
  ///
  /// In en, this message translates to:
  /// **'waiting {time}'**
  String waitingFor(String time);

  /// No description provided for @searchAccounts.
  ///
  /// In en, this message translates to:
  /// **'Search accounts'**
  String get searchAccounts;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noAccountFoundFor.
  ///
  /// In en, this message translates to:
  /// **'No account found for \"{query}\"'**
  String noAccountFoundFor(String query);

  /// No description provided for @marginPct.
  ///
  /// In en, this message translates to:
  /// **'{pct}% margin'**
  String marginPct(String pct);

  /// No description provided for @salesSalePrice.
  ///
  /// In en, this message translates to:
  /// **'Sales (Sale Price)'**
  String get salesSalePrice;

  /// No description provided for @expensesPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Expenses (Purchase Price)'**
  String get expensesPurchasePrice;

  /// No description provided for @perGame.
  ///
  /// In en, this message translates to:
  /// **'Per game'**
  String get perGame;

  /// No description provided for @salesAndExpenses.
  ///
  /// In en, this message translates to:
  /// **'Sales {sales} · Expenses {expenses}'**
  String salesAndExpenses(String sales, String expenses);

  /// No description provided for @topProfit.
  ///
  /// In en, this message translates to:
  /// **'Top profit'**
  String get topProfit;

  /// No description provided for @losses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get losses;

  /// No description provided for @todayCap.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayCap;

  /// No description provided for @typeGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get typeGoogle;

  /// No description provided for @typeGaming.
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get typeGaming;

  /// No description provided for @typeGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get typeGames;

  /// No description provided for @typeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get typeSystem;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get last30Days;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @noActivityFromNow.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.\nNew actions will appear here from now on.'**
  String get noActivityFromNow;

  /// No description provided for @perfAddedVsPrev.
  ///
  /// In en, this message translates to:
  /// **'{added} added · {prev} {prevLabel}'**
  String perfAddedVsPrev(int added, int prev, String prevLabel);

  /// No description provided for @perfSameProfit.
  ///
  /// In en, this message translates to:
  /// **'Same profit as {prevLabel}'**
  String perfSameProfit(String prevLabel);

  /// No description provided for @perfVsPrev.
  ///
  /// In en, this message translates to:
  /// **'{amount} vs {prevLabel}'**
  String perfVsPrev(String amount, String prevLabel);

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @prevYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get prevYesterday;

  /// No description provided for @prevLastWeek.
  ///
  /// In en, this message translates to:
  /// **'last week'**
  String get prevLastWeek;

  /// No description provided for @prevLastMonth.
  ///
  /// In en, this message translates to:
  /// **'last month'**
  String get prevLastMonth;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Reached'**
  String get goalReached;

  /// No description provided for @goalOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get goalOnTrack;

  /// No description provided for @goalBehind.
  ///
  /// In en, this message translates to:
  /// **'Behind pace'**
  String get goalBehind;

  /// No description provided for @goalProgress.
  ///
  /// In en, this message translates to:
  /// **'{current} of {target} · {pct}%'**
  String goalProgress(String current, String target, String pct);

  /// No description provided for @performanceCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Center'**
  String get performanceCenterTitle;

  /// No description provided for @monthlyGoals.
  ///
  /// In en, this message translates to:
  /// **'Monthly goals'**
  String get monthlyGoals;

  /// No description provided for @setGoals.
  ///
  /// In en, this message translates to:
  /// **'Set goals'**
  String get setGoals;

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'No goals yet. Set a monthly profit or accounts goal to track your pace.'**
  String get noGoalsYet;

  /// No description provided for @accountsAdded.
  ///
  /// In en, this message translates to:
  /// **'Accounts added'**
  String get accountsAdded;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @addStreak.
  ///
  /// In en, this message translates to:
  /// **'Add streak'**
  String get addStreak;

  /// No description provided for @addStreakSub.
  ///
  /// In en, this message translates to:
  /// **'Days in a row with a new account'**
  String get addStreakSub;

  /// No description provided for @bestDay30.
  ///
  /// In en, this message translates to:
  /// **'Best day (30 days)'**
  String get bestDay30;

  /// No description provided for @bestWeek12.
  ///
  /// In en, this message translates to:
  /// **'Best week (12 weeks)'**
  String get bestWeek12;

  /// No description provided for @bestMonth12.
  ///
  /// In en, this message translates to:
  /// **'Best month (12 months)'**
  String get bestMonth12;

  /// No description provided for @perfNote.
  ///
  /// In en, this message translates to:
  /// **'Accounts count in the period they were added. FOR SALE accounts have no profit yet.'**
  String get perfNote;

  /// No description provided for @profitGoalCurrency.
  ///
  /// In en, this message translates to:
  /// **'Profit goal ({currency})'**
  String profitGoalCurrency(String currency);

  /// No description provided for @emptyNoGoal.
  ///
  /// In en, this message translates to:
  /// **'Empty = no goal'**
  String get emptyNoGoal;

  /// No description provided for @accountsToAdd.
  ///
  /// In en, this message translates to:
  /// **'Accounts to add'**
  String get accountsToAdd;

  /// No description provided for @googleAccountsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Google account} other{{count} Google accounts}}'**
  String googleAccountsCount(int count);

  /// No description provided for @googlePlayBoxes.
  ///
  /// In en, this message translates to:
  /// **'Google Play boxes'**
  String get googlePlayBoxes;

  /// No description provided for @gamingAccounts.
  ///
  /// In en, this message translates to:
  /// **'Gaming accounts'**
  String get gamingAccounts;

  /// No description provided for @totalProfitLoss.
  ///
  /// In en, this message translates to:
  /// **'Total profit / loss'**
  String get totalProfitLoss;

  /// No description provided for @pricePerGame.
  ///
  /// In en, this message translates to:
  /// **'Price per game'**
  String get pricePerGame;

  /// No description provided for @accountsIncluded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account included} other{{count} accounts included}}'**
  String accountsIncluded(int count);

  /// No description provided for @accountsPerGame.
  ///
  /// In en, this message translates to:
  /// **'Number of accounts per game'**
  String get accountsPerGame;

  /// No description provided for @statusPerGame.
  ///
  /// In en, this message translates to:
  /// **'Account status per game'**
  String get statusPerGame;

  /// No description provided for @noAccountsInGrade.
  ///
  /// In en, this message translates to:
  /// **'No accounts in this grade'**
  String get noAccountsInGrade;

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts'**
  String get noAccounts;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get nothingHere;

  /// No description provided for @howMatchingWorks.
  ///
  /// In en, this message translates to:
  /// **'How matching works'**
  String get howMatchingWorks;

  /// No description provided for @matchingRules.
  ///
  /// In en, this message translates to:
  /// **'Google accounts: same Email (ignores case, spaces, and for Gmail dots and \"+tags\").\nGame accounts: same Account ID inside the same game.\nPhone matching is not available: phone numbers are not stored yet.'**
  String get matchingRules;

  /// No description provided for @nothingMergedAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Nothing is deleted or merged automatically. You review every account yourself.'**
  String get nothingMergedAutomatically;

  /// No description provided for @noDuplicatesFound.
  ///
  /// In en, this message translates to:
  /// **'No duplicates found'**
  String get noDuplicatesFound;

  /// No description provided for @googleAccountsSection.
  ///
  /// In en, this message translates to:
  /// **'Google accounts'**
  String get googleAccountsSection;

  /// No description provided for @gameAccountsSection.
  ///
  /// In en, this message translates to:
  /// **'Game accounts'**
  String get gameAccountsSection;

  /// No description provided for @showDismissedAgain.
  ///
  /// In en, this message translates to:
  /// **'Show {count} dismissed again'**
  String showDismissedAgain(int count);

  /// No description provided for @markedNotDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Marked as not duplicates'**
  String get markedNotDuplicates;

  /// No description provided for @similarAccounts.
  ///
  /// In en, this message translates to:
  /// **'{count} similar accounts'**
  String similarAccounts(int count);

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'added {date}'**
  String addedOn(String date);

  /// No description provided for @openToReview.
  ///
  /// In en, this message translates to:
  /// **'Open to review'**
  String get openToReview;

  /// No description provided for @notDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Not duplicates'**
  String get notDuplicates;

  /// No description provided for @accountsWithId.
  ///
  /// In en, this message translates to:
  /// **'{count} accounts with ID {id}'**
  String accountsWithId(int count, String id);

  /// No description provided for @unknownGame.
  ///
  /// In en, this message translates to:
  /// **'Unknown game'**
  String get unknownGame;

  /// No description provided for @buySell.
  ///
  /// In en, this message translates to:
  /// **'buy {buy} → sell {sell}'**
  String buySell(String buy, String sell);

  /// No description provided for @openGame.
  ///
  /// In en, this message translates to:
  /// **'Open game'**
  String get openGame;

  /// No description provided for @saleAmount.
  ///
  /// In en, this message translates to:
  /// **'sale {amount}'**
  String saleAmount(String amount);

  /// No description provided for @addToVault.
  ///
  /// In en, this message translates to:
  /// **'Add to vault'**
  String get addToVault;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @vaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your vault is empty'**
  String get vaultEmpty;

  /// No description provided for @nothingWithTag.
  ///
  /// In en, this message translates to:
  /// **'Nothing with this tag'**
  String get nothingWithTag;

  /// No description provided for @vaultHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add to vault\" to mark favourite, rare or high-value accounts.'**
  String get vaultHint;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @highestSaleFirst.
  ///
  /// In en, this message translates to:
  /// **'Highest sale price first'**
  String get highestSaleFirst;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get noAccount;

  /// No description provided for @tagFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get tagFavorite;

  /// No description provided for @tagRare.
  ///
  /// In en, this message translates to:
  /// **'Rare'**
  String get tagRare;

  /// No description provided for @tagHighValue.
  ///
  /// In en, this message translates to:
  /// **'High value'**
  String get tagHighValue;

  /// No description provided for @everythingGood.
  ///
  /// In en, this message translates to:
  /// **'Everything looks good'**
  String get everythingGood;

  /// No description provided for @itemsToReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item to review} other{{count} items to review}}'**
  String itemsToReview(int count);

  /// No description provided for @basedOnDeviceData.
  ///
  /// In en, this message translates to:
  /// **'Based on the data stored on this device.'**
  String get basedOnDeviceData;

  /// No description provided for @dataHealth.
  ///
  /// In en, this message translates to:
  /// **'Data health'**
  String get dataHealth;

  /// No description provided for @duplicateAccounts.
  ///
  /// In en, this message translates to:
  /// **'Duplicate accounts'**
  String get duplicateAccounts;

  /// No description provided for @noneFound.
  ///
  /// In en, this message translates to:
  /// **'None found'**
  String get noneFound;

  /// No description provided for @groupsToReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 group to review} other{{count} groups to review}}'**
  String groupsToReview(int count);

  /// No description provided for @duplicateGameIds.
  ///
  /// In en, this message translates to:
  /// **'Duplicate game Account IDs'**
  String get duplicateGameIds;

  /// No description provided for @accountsWithoutId.
  ///
  /// In en, this message translates to:
  /// **'Game accounts without Account ID'**
  String get accountsWithoutId;

  /// No description provided for @allHaveId.
  ///
  /// In en, this message translates to:
  /// **'All have an Account ID'**
  String get allHaveId;

  /// No description provided for @accountsMissingId.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account missing an ID} other{{count} accounts missing an ID}}'**
  String accountsMissingId(int count);

  /// No description provided for @invalidEmails.
  ///
  /// In en, this message translates to:
  /// **'Invalid emails'**
  String get invalidEmails;

  /// No description provided for @allEmailsValid.
  ///
  /// In en, this message translates to:
  /// **'All emails look valid'**
  String get allEmailsValid;

  /// No description provided for @accountsWrongEmail.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account with a wrong email format} other{{count} accounts with a wrong email format}}'**
  String accountsWrongEmail(int count);

  /// No description provided for @accountsNoBoxes.
  ///
  /// In en, this message translates to:
  /// **'Accounts with no boxes set'**
  String get accountsNoBoxes;

  /// No description provided for @justInformational.
  ///
  /// In en, this message translates to:
  /// **'{count} (just informational)'**
  String justInformational(int count);

  /// No description provided for @itemsInTrash.
  ///
  /// In en, this message translates to:
  /// **'Items in Trash'**
  String get itemsInTrash;

  /// No description provided for @trashKept.
  ///
  /// In en, this message translates to:
  /// **'{count} kept, nothing is removed automatically'**
  String trashKept(int count);

  /// No description provided for @protection.
  ///
  /// In en, this message translates to:
  /// **'Protection'**
  String get protection;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @notEnabledYet.
  ///
  /// In en, this message translates to:
  /// **'Not enabled yet'**
  String get notEnabledYet;

  /// No description provided for @localStorage.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get localStorage;

  /// No description provided for @dataStaysOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this device'**
  String get dataStaysOnDevice;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @noBackupYet.
  ///
  /// In en, this message translates to:
  /// **'No backup yet. Backup is not available in this version.'**
  String get noBackupYet;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync status'**
  String get syncStatus;

  /// No description provided for @cloudSync.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync'**
  String get cloudSync;

  /// No description provided for @localOnly.
  ///
  /// In en, this message translates to:
  /// **'Local only. Sync is not connected yet.'**
  String get localOnly;

  /// No description provided for @safetyRules.
  ///
  /// In en, this message translates to:
  /// **'Safety rules'**
  String get safetyRules;

  /// No description provided for @noAutoDeletion.
  ///
  /// In en, this message translates to:
  /// **'No automatic deletion'**
  String get noAutoDeletion;

  /// No description provided for @nothingDeletedWithoutYou.
  ///
  /// In en, this message translates to:
  /// **'Nothing is deleted without you'**
  String get nothingDeletedWithoutYou;

  /// No description provided for @noAutoMerging.
  ///
  /// In en, this message translates to:
  /// **'No automatic merging'**
  String get noAutoMerging;

  /// No description provided for @neverMerge.
  ///
  /// In en, this message translates to:
  /// **'Scanning and organizing never merge accounts'**
  String get neverMerge;

  /// No description provided for @manualReviewFirst.
  ///
  /// In en, this message translates to:
  /// **'Manual review first'**
  String get manualReviewFirst;

  /// No description provided for @changesByYou.
  ///
  /// In en, this message translates to:
  /// **'Every change is made by you, after review'**
  String get changesByYou;

  /// No description provided for @sortRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get sortRecentActivity;

  /// No description provided for @sortOldestActivity.
  ///
  /// In en, this message translates to:
  /// **'Oldest activity'**
  String get sortOldestActivity;

  /// No description provided for @sortNewestAdded.
  ///
  /// In en, this message translates to:
  /// **'Newest added'**
  String get sortNewestAdded;

  /// No description provided for @sortOldestAdded.
  ///
  /// In en, this message translates to:
  /// **'Oldest added'**
  String get sortOldestAdded;

  /// No description provided for @sortEmailAz.
  ///
  /// In en, this message translates to:
  /// **'Email A–Z'**
  String get sortEmailAz;

  /// No description provided for @sortEmailZa.
  ///
  /// In en, this message translates to:
  /// **'Email Z–A'**
  String get sortEmailZa;

  /// No description provided for @sortGrade.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get sortGrade;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortSaleHigh.
  ///
  /// In en, this message translates to:
  /// **'Highest sale price'**
  String get sortSaleHigh;

  /// No description provided for @sortSaleLow.
  ///
  /// In en, this message translates to:
  /// **'Lowest sale price'**
  String get sortSaleLow;

  /// No description provided for @sortBuyHigh.
  ///
  /// In en, this message translates to:
  /// **'Highest purchase price'**
  String get sortBuyHigh;

  /// No description provided for @sortNameAz.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get sortNameAz;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @searchByNameOrId.
  ///
  /// In en, this message translates to:
  /// **'Search by name or Account ID'**
  String get searchByNameOrId;

  /// No description provided for @allGames.
  ///
  /// In en, this message translates to:
  /// **'All games'**
  String get allGames;

  /// No description provided for @shownOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total} accounts'**
  String shownOfTotal(int shown, int total);

  /// No description provided for @sortedBy.
  ///
  /// In en, this message translates to:
  /// **'Sorted: {sort}'**
  String sortedBy(String sort);

  /// No description provided for @noAccountMatchesShort.
  ///
  /// In en, this message translates to:
  /// **'No account matches'**
  String get noAccountMatchesShort;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'no activity'**
  String get noActivity;

  /// No description provided for @emptyTrashTitle.
  ///
  /// In en, this message translates to:
  /// **'Empty Trash?'**
  String get emptyTrashTitle;

  /// No description provided for @emptyTrashBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item will be permanently deleted. This cannot be undone.} other{All {count} items will be permanently deleted. This cannot be undone.}}'**
  String emptyTrashBody(int count);

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @emptyAction.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyAction;

  /// No description provided for @googleTabCount.
  ///
  /// In en, this message translates to:
  /// **'Google ({count})'**
  String googleTabCount(int count);

  /// No description provided for @gamesTabCount.
  ///
  /// In en, this message translates to:
  /// **'Games ({count})'**
  String gamesTabCount(int count);

  /// No description provided for @googleAccountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Google account · {grade}\nDeleted {when}'**
  String googleAccountDeleted(String grade, String when);

  /// No description provided for @deletedWhen.
  ///
  /// In en, this message translates to:
  /// **'Deleted {when}'**
  String deletedWhen(String when);

  /// No description provided for @removedSuffix.
  ///
  /// In en, this message translates to:
  /// **' (removed)'**
  String get removedSuffix;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @deletePermanentlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently?'**
  String get deletePermanentlyTitle;

  /// No description provided for @deletedForGood.
  ///
  /// In en, this message translates to:
  /// **'{name} will be deleted for good. This cannot be undone.'**
  String deletedForGood(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @trashIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty'**
  String get trashIsEmpty;

  /// No description provided for @phoneNotifsMobileOnly.
  ///
  /// In en, this message translates to:
  /// **'Phone notifications work on Android and iOS only.'**
  String get phoneNotifsMobileOnly;

  /// No description provided for @notifsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked for SPHERA. Allow them in your phone settings, then try again.'**
  String get notifsBlocked;

  /// No description provided for @notifsSub.
  ///
  /// In en, this message translates to:
  /// **'Warnings and reminders in SPHERA'**
  String get notifsSub;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @remindersSub.
  ///
  /// In en, this message translates to:
  /// **'Stale FOR SALE listings, COMING boxes, goals behind pace'**
  String get remindersSub;

  /// No description provided for @alertsNote.
  ///
  /// In en, this message translates to:
  /// **'Alerts always appear in the Notifications center (bell icon), with a red count.'**
  String get alertsNote;

  /// No description provided for @phoneNotifications.
  ///
  /// In en, this message translates to:
  /// **'Phone notifications'**
  String get phoneNotifications;

  /// No description provided for @phoneNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Show new alerts on your phone when you leave the app'**
  String get phoneNotificationsSub;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily summary'**
  String get dailySummary;

  /// No description provided for @dailySummarySub.
  ///
  /// In en, this message translates to:
  /// **'Alerts, net profit and accounts, once a day'**
  String get dailySummarySub;

  /// No description provided for @summaryTime.
  ///
  /// In en, this message translates to:
  /// **'Summary time'**
  String get summaryTime;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get sendTestNotification;

  /// No description provided for @phoneNotifsNote.
  ///
  /// In en, this message translates to:
  /// **'Phone notifications are created on this device, no account or internet needed. The daily summary may arrive a few minutes late to save battery. Some phones (Xiaomi, Huawei...) block background notifications unless you allow SPHERA in battery settings.'**
  String get phoneNotifsNote;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @notifsOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off'**
  String get notifsOff;

  /// No description provided for @turnOnInSettings.
  ///
  /// In en, this message translates to:
  /// **'Turn them on in notification settings.'**
  String get turnOnInSettings;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get allClear;

  /// No description provided for @noWarningsNow.
  ///
  /// In en, this message translates to:
  /// **'No warnings or reminders right now.'**
  String get noWarningsNow;

  /// No description provided for @remindersMuted.
  ///
  /// In en, this message translates to:
  /// **'Reminders are muted in notification settings.'**
  String get remindersMuted;

  /// No description provided for @notificationsNew.
  ///
  /// In en, this message translates to:
  /// **'Notifications ({count} new)'**
  String notificationsNew(int count);

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhoto;

  /// No description provided for @logOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logOutTitle;

  /// No description provided for @logOutBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to log in again. Your profile, accounts, games and statistics are kept on this device.'**
  String get logOutBody;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @spheraUser.
  ///
  /// In en, this message translates to:
  /// **'SPHERA User'**
  String get spheraUser;

  /// No description provided for @rankPts.
  ///
  /// In en, this message translates to:
  /// **'{rank} · {points} pts'**
  String rankPts(String rank, int points);

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @activitySummary.
  ///
  /// In en, this message translates to:
  /// **'Activity summary'**
  String get activitySummary;

  /// No description provided for @googleAccountsLabel.
  ///
  /// In en, this message translates to:
  /// **'Google accounts'**
  String get googleAccountsLabel;

  /// No description provided for @gameAccountsLabel.
  ///
  /// In en, this message translates to:
  /// **'Game accounts'**
  String get gameAccountsLabel;

  /// No description provided for @profitLoss.
  ///
  /// In en, this message translates to:
  /// **'Profit / loss'**
  String get profitLoss;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @rankName.
  ///
  /// In en, this message translates to:
  /// **'Rank: {rank}'**
  String rankName(String rank);

  /// No description provided for @rankPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} rank points'**
  String rankPoints(int points);

  /// No description provided for @topRankReached.
  ///
  /// In en, this message translates to:
  /// **'Top rank reached'**
  String get topRankReached;

  /// No description provided for @ptsToRank.
  ///
  /// In en, this message translates to:
  /// **'{points} pts to {rank}'**
  String ptsToRank(int points, String rank);

  /// No description provided for @unlockedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} unlocked'**
  String unlockedOfTotal(int done, int total);

  /// No description provided for @allAchievementsUnlocked.
  ///
  /// In en, this message translates to:
  /// **'All achievements unlocked.'**
  String get allAchievementsUnlocked;

  /// No description provided for @fraction.
  ///
  /// In en, this message translates to:
  /// **'{a} / {b}'**
  String fraction(int a, int b);

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @currentSession.
  ///
  /// In en, this message translates to:
  /// **'Current session'**
  String get currentSession;

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Started at {time}'**
  String startedAt(String time);

  /// No description provided for @dataOnDeviceOnly.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored on this device only.'**
  String get dataOnDeviceOnly;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @profilePhotosPhoneOnly.
  ///
  /// In en, this message translates to:
  /// **'Profile photos work in the phone app, not in the browser.'**
  String get profilePhotosPhoneOnly;

  /// No description provided for @achievementPoints.
  ///
  /// In en, this message translates to:
  /// **'{earned} / {total} achievement points'**
  String achievementPoints(int earned, int total);

  /// No description provided for @achievementPointsNote.
  ///
  /// In en, this message translates to:
  /// **'Achievement points are separate from rank points and from Google Play grades.'**
  String get achievementPointsNote;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @achievementDatesNote.
  ///
  /// In en, this message translates to:
  /// **'Dates show when an achievement was first detected on this device. Profit amounts are counted in DH.'**
  String get achievementDatesNote;

  /// No description provided for @unlockCondition.
  ///
  /// In en, this message translates to:
  /// **'Unlock: {condition}'**
  String unlockCondition(String condition);

  /// No description provided for @unlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String unlockedOn(String date);

  /// No description provided for @plusPts.
  ///
  /// In en, this message translates to:
  /// **'+{points} pts'**
  String plusPts(int points);

  /// No description provided for @progressPct.
  ///
  /// In en, this message translates to:
  /// **'{a} / {b}  ·  {pct}%'**
  String progressPct(int a, int b, int pct);

  /// No description provided for @catAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get catAccounts;

  /// No description provided for @catGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get catGames;

  /// No description provided for @catSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get catSales;

  /// No description provided for @catProfits.
  ///
  /// In en, this message translates to:
  /// **'Profits'**
  String get catProfits;

  /// No description provided for @catOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get catOrganization;

  /// No description provided for @achAcc1.
  ///
  /// In en, this message translates to:
  /// **'First account'**
  String get achAcc1;

  /// No description provided for @achAcc1Desc.
  ///
  /// In en, this message translates to:
  /// **'Add your first Google account.'**
  String get achAcc1Desc;

  /// No description provided for @achAcc10.
  ///
  /// In en, this message translates to:
  /// **'Collector'**
  String get achAcc10;

  /// No description provided for @achAcc10Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 10 Google accounts.'**
  String get achAcc10Desc;

  /// No description provided for @achAcc25.
  ///
  /// In en, this message translates to:
  /// **'Big collection'**
  String get achAcc25;

  /// No description provided for @achAcc25Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 25 Google accounts.'**
  String get achAcc25Desc;

  /// No description provided for @achGacc10.
  ///
  /// In en, this message translates to:
  /// **'Game accounts x10'**
  String get achGacc10;

  /// No description provided for @achGacc10Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 10 game accounts.'**
  String get achGacc10Desc;

  /// No description provided for @achGacc50.
  ///
  /// In en, this message translates to:
  /// **'Game accounts x50'**
  String get achGacc50;

  /// No description provided for @achGacc50Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 50 game accounts.'**
  String get achGacc50Desc;

  /// No description provided for @achGacc100.
  ///
  /// In en, this message translates to:
  /// **'Game accounts x100'**
  String get achGacc100;

  /// No description provided for @achGacc100Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 100 game accounts.'**
  String get achGacc100Desc;

  /// No description provided for @achGame1.
  ///
  /// In en, this message translates to:
  /// **'First game'**
  String get achGame1;

  /// No description provided for @achGame1Desc.
  ///
  /// In en, this message translates to:
  /// **'Add your first game.'**
  String get achGame1Desc;

  /// No description provided for @achGame5.
  ///
  /// In en, this message translates to:
  /// **'Game shelf'**
  String get achGame5;

  /// No description provided for @achGame5Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 5 games.'**
  String get achGame5Desc;

  /// No description provided for @achGame10.
  ///
  /// In en, this message translates to:
  /// **'Game library'**
  String get achGame10;

  /// No description provided for @achGame10Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 10 games.'**
  String get achGame10Desc;

  /// No description provided for @achSell1.
  ///
  /// In en, this message translates to:
  /// **'First sale listing'**
  String get achSell1;

  /// No description provided for @achSell1Desc.
  ///
  /// In en, this message translates to:
  /// **'Mark your first account as SOLD.'**
  String get achSell1Desc;

  /// No description provided for @achSell10.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get achSell10;

  /// No description provided for @achSell10Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 10 accounts marked SOLD.'**
  String get achSell10Desc;

  /// No description provided for @achSell50.
  ///
  /// In en, this message translates to:
  /// **'Big seller'**
  String get achSell50;

  /// No description provided for @achSell50Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 50 accounts marked SOLD.'**
  String get achSell50Desc;

  /// No description provided for @achProfit1.
  ///
  /// In en, this message translates to:
  /// **'In profit'**
  String get achProfit1;

  /// No description provided for @achProfit1Desc.
  ///
  /// In en, this message translates to:
  /// **'Reach a positive total profit.'**
  String get achProfit1Desc;

  /// No description provided for @achProfit1k.
  ///
  /// In en, this message translates to:
  /// **'1,000 DH profit'**
  String get achProfit1k;

  /// No description provided for @achProfit1kDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach 1,000 DH of total profit.'**
  String get achProfit1kDesc;

  /// No description provided for @achProfit10k.
  ///
  /// In en, this message translates to:
  /// **'10,000 DH profit'**
  String get achProfit10k;

  /// No description provided for @achProfit10kDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach 10,000 DH of total profit.'**
  String get achProfit10kDesc;

  /// No description provided for @achProfitGames3.
  ///
  /// In en, this message translates to:
  /// **'Winning games'**
  String get achProfitGames3;

  /// No description provided for @achProfitGames3Desc.
  ///
  /// In en, this message translates to:
  /// **'Have 3 games with a positive profit.'**
  String get achProfitGames3Desc;

  /// No description provided for @achBoxes10.
  ///
  /// In en, this message translates to:
  /// **'Organized'**
  String get achBoxes10;

  /// No description provided for @achBoxes10Desc.
  ///
  /// In en, this message translates to:
  /// **'Set 10 game boxes (not EMPTY).'**
  String get achBoxes10Desc;

  /// No description provided for @achBoxes50.
  ///
  /// In en, this message translates to:
  /// **'Well organized'**
  String get achBoxes50;

  /// No description provided for @achBoxes50Desc.
  ///
  /// In en, this message translates to:
  /// **'Set 50 game boxes (not EMPTY).'**
  String get achBoxes50Desc;

  /// No description provided for @achFull.
  ///
  /// In en, this message translates to:
  /// **'Full coverage'**
  String get achFull;

  /// No description provided for @achFullDesc.
  ///
  /// In en, this message translates to:
  /// **'Have at least one account in every game (minimum 3 games).'**
  String get achFullDesc;

  /// No description provided for @askSpheraAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask SPHERA anything'**
  String get askSpheraAnything;

  /// No description provided for @aiModeOnHint.
  ///
  /// In en, this message translates to:
  /// **'AI mode is on: Claude answers using a summary of your numbers.'**
  String get aiModeOnHint;

  /// No description provided for @offlineHint.
  ///
  /// In en, this message translates to:
  /// **'Your profit, games, accounts, grades, goals, problems, or how to use any screen. Works offline, in English, French or Arabic.'**
  String get offlineHint;

  /// No description provided for @askQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Ask a question…'**
  String get askQuestionHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get thinking;

  /// No description provided for @sourceOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get sourceOffline;

  /// No description provided for @sourceNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get sourceNotice;

  /// No description provided for @aiMode.
  ///
  /// In en, this message translates to:
  /// **'AI mode'**
  String get aiMode;

  /// No description provided for @aiModeExplain.
  ///
  /// In en, this message translates to:
  /// **'Offline, the assistant answers from your data and the app guide. With AI mode, Claude (Anthropic) answers any question, in any language.'**
  String get aiModeExplain;

  /// No description provided for @useClaudeAi.
  ///
  /// In en, this message translates to:
  /// **'Use Claude AI'**
  String get useClaudeAi;

  /// No description provided for @apiKeySaved.
  ///
  /// In en, this message translates to:
  /// **'API key saved on this phone'**
  String get apiKeySaved;

  /// No description provided for @addApiKeyFirst.
  ///
  /// In en, this message translates to:
  /// **'Add your API key first'**
  String get addApiKeyFirst;

  /// No description provided for @replaceApiKey.
  ///
  /// In en, this message translates to:
  /// **'Replace API key'**
  String get replaceApiKey;

  /// No description provided for @anthropicApiKey.
  ///
  /// In en, this message translates to:
  /// **'Anthropic API key'**
  String get anthropicApiKey;

  /// No description provided for @keysStartWith.
  ///
  /// In en, this message translates to:
  /// **'Keys start with sk-ant-'**
  String get keysStartWith;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @saveKey.
  ///
  /// In en, this message translates to:
  /// **'Save key'**
  String get saveKey;

  /// No description provided for @removeKey.
  ///
  /// In en, this message translates to:
  /// **'Remove key'**
  String get removeKey;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @aiPrivacyText.
  ///
  /// In en, this message translates to:
  /// **'When AI mode is on, your question and a summary of your numbers (counts, profits, game names, account names, grades, alerts) are sent to Anthropic to write the answer. Emails, Account IDs, notes and photos are never sent. The key is stored encrypted on this phone.\n\nGet a key at console.anthropic.com (API usage is billed to your Anthropic account).'**
  String get aiPrivacyText;

  /// No description provided for @targetGoogleAccounts.
  ///
  /// In en, this message translates to:
  /// **'Google Accounts'**
  String get targetGoogleAccounts;

  /// No description provided for @tournamentArena.
  ///
  /// In en, this message translates to:
  /// **'Tournament Arena'**
  String get tournamentArena;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get newChat;

  /// No description provided for @aiModeOn.
  ///
  /// In en, this message translates to:
  /// **'AI mode: on'**
  String get aiModeOn;

  /// No description provided for @aiModeOff.
  ///
  /// In en, this message translates to:
  /// **'AI mode: off'**
  String get aiModeOff;

  /// No description provided for @ask.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get ask;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @levelAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get levelAttention;

  /// No description provided for @levelTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get levelTips;

  /// No description provided for @levelGood.
  ///
  /// In en, this message translates to:
  /// **'Good news'**
  String get levelGood;

  /// No description provided for @insightsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 insight} other{{count} insights}}'**
  String insightsCount(int count);

  /// No description provided for @attentionAndGood.
  ///
  /// In en, this message translates to:
  /// **'{attention} need attention · {good} good news'**
  String attentionAndGood(int attention, int good);

  /// No description provided for @nothingHereNow.
  ///
  /// In en, this message translates to:
  /// **'Nothing here right now.'**
  String get nothingHereNow;

  /// No description provided for @analysisOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Analysis runs on this device from your own data and updates as you edit accounts.'**
  String get analysisOnDevice;

  /// No description provided for @contNorthAmerica.
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get contNorthAmerica;

  /// No description provided for @contSouthAmerica.
  ///
  /// In en, this message translates to:
  /// **'South America'**
  String get contSouthAmerica;

  /// No description provided for @contEurope.
  ///
  /// In en, this message translates to:
  /// **'Europe'**
  String get contEurope;

  /// No description provided for @contAfrica.
  ///
  /// In en, this message translates to:
  /// **'Africa'**
  String get contAfrica;

  /// No description provided for @contAsia.
  ///
  /// In en, this message translates to:
  /// **'Asia'**
  String get contAsia;

  /// No description provided for @contOceania.
  ///
  /// In en, this message translates to:
  /// **'Oceania'**
  String get contOceania;

  /// No description provided for @globeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Globe. Every continent is a section of the app. Use the all sections button to list them.'**
  String get globeSemantics;

  /// No description provided for @backToGlobe.
  ///
  /// In en, this message translates to:
  /// **'Back to the globe'**
  String get backToGlobe;

  /// No description provided for @allSections.
  ///
  /// In en, this message translates to:
  /// **'All sections'**
  String get allSections;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @tellWhereToGo.
  ///
  /// In en, this message translates to:
  /// **'Tell me where you want to go'**
  String get tellWhereToGo;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @openScreen.
  ///
  /// In en, this message translates to:
  /// **'Open {name}'**
  String openScreen(String name);

  /// No description provided for @screens.
  ///
  /// In en, this message translates to:
  /// **'Screens'**
  String get screens;

  /// No description provided for @smallerPanel.
  ///
  /// In en, this message translates to:
  /// **'Smaller panel'**
  String get smallerPanel;

  /// No description provided for @biggerPanel.
  ///
  /// In en, this message translates to:
  /// **'Bigger panel'**
  String get biggerPanel;

  /// No description provided for @nothingHereYetDot.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get nothingHereYetDot;

  /// No description provided for @noStatsForSection.
  ///
  /// In en, this message translates to:
  /// **'No stats for this section.'**
  String get noStatsForSection;

  /// No description provided for @secStatsTagline.
  ///
  /// In en, this message translates to:
  /// **'Analytics & performance'**
  String get secStatsTagline;

  /// No description provided for @destPerformanceSub.
  ///
  /// In en, this message translates to:
  /// **'Today, this week, this month & goals'**
  String get destPerformanceSub;

  /// No description provided for @destGradeStatsSub.
  ///
  /// In en, this message translates to:
  /// **'Bronze to Diamond & Interdit'**
  String get destGradeStatsSub;

  /// No description provided for @secCardsTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart tools & arena'**
  String get secCardsTagline;

  /// No description provided for @secGamesTagline.
  ///
  /// In en, this message translates to:
  /// **'Your gaming accounts'**
  String get secGamesTagline;

  /// No description provided for @destAllGames.
  ///
  /// In en, this message translates to:
  /// **'All Games'**
  String get destAllGames;

  /// No description provided for @destForSaleSub.
  ///
  /// In en, this message translates to:
  /// **'Accounts currently listed for sale'**
  String get destForSaleSub;

  /// No description provided for @destGameSub.
  ///
  /// In en, this message translates to:
  /// **'Accounts and statuses of this game'**
  String get destGameSub;

  /// No description provided for @secGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get secGoogle;

  /// No description provided for @secGoogleTagline.
  ///
  /// In en, this message translates to:
  /// **'Google Play accounts'**
  String get secGoogleTagline;

  /// No description provided for @destGoogleAddSub.
  ///
  /// In en, this message translates to:
  /// **'Add a new Google Play account'**
  String get destGoogleAddSub;

  /// No description provided for @destGrades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get destGrades;

  /// No description provided for @destGradesSub.
  ///
  /// In en, this message translates to:
  /// **'Statistics by grade'**
  String get destGradesSub;

  /// No description provided for @destBoxStatus.
  ///
  /// In en, this message translates to:
  /// **'Box Status'**
  String get destBoxStatus;

  /// No description provided for @destBoxStatusSub.
  ///
  /// In en, this message translates to:
  /// **'Statistics by game box status'**
  String get destBoxStatusSub;

  /// No description provided for @secProfileTagline.
  ///
  /// In en, this message translates to:
  /// **'You & your progress'**
  String get secProfileTagline;

  /// No description provided for @destMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get destMyProfile;

  /// No description provided for @destMyProfileSub.
  ///
  /// In en, this message translates to:
  /// **'Picture, info, rank & session'**
  String get destMyProfileSub;

  /// No description provided for @destAchievementsSub.
  ///
  /// In en, this message translates to:
  /// **'Badges, progress & unlock dates'**
  String get destAchievementsSub;

  /// No description provided for @secSettingsTagline.
  ///
  /// In en, this message translates to:
  /// **'Preferences & safety'**
  String get secSettingsTagline;

  /// No description provided for @destSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Appearance, language, currency & data'**
  String get destSettingsSub;

  /// No description provided for @destNotificationsSub.
  ///
  /// In en, this message translates to:
  /// **'Warnings and reminders'**
  String get destNotificationsSub;

  /// No description provided for @destTrashSub.
  ///
  /// In en, this message translates to:
  /// **'Restore removed accounts'**
  String get destTrashSub;

  /// No description provided for @orbScreens.
  ///
  /// In en, this message translates to:
  /// **'Screens'**
  String get orbScreens;

  /// No description provided for @orbSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get orbSystem;

  /// No description provided for @orbNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net profit'**
  String get orbNetProfit;

  /// No description provided for @orbAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get orbAccounts;

  /// No description provided for @orbSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get orbSold;

  /// No description provided for @orbForSale.
  ///
  /// In en, this message translates to:
  /// **'For sale'**
  String get orbForSale;

  /// No description provided for @orbActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get orbActive;

  /// No description provided for @orbAddedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Added this month'**
  String get orbAddedThisMonth;

  /// No description provided for @orbGoogleAccounts.
  ///
  /// In en, this message translates to:
  /// **'Google accounts'**
  String get orbGoogleAccounts;

  /// No description provided for @orbGamingAccounts.
  ///
  /// In en, this message translates to:
  /// **'Gaming accounts'**
  String get orbGamingAccounts;

  /// No description provided for @orbDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates'**
  String get orbDuplicates;

  /// No description provided for @orbInVault.
  ///
  /// In en, this message translates to:
  /// **'In vault'**
  String get orbInVault;

  /// No description provided for @orbClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get orbClean;

  /// No description provided for @orbGoogleDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Google duplicates'**
  String get orbGoogleDuplicates;

  /// No description provided for @orbSameAccountId.
  ///
  /// In en, this message translates to:
  /// **'Same account ID'**
  String get orbSameAccountId;

  /// No description provided for @orbGames.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get orbGames;

  /// No description provided for @orbListed.
  ///
  /// In en, this message translates to:
  /// **'Listed'**
  String get orbListed;

  /// No description provided for @orbBoxesSet.
  ///
  /// In en, this message translates to:
  /// **'Boxes set'**
  String get orbBoxesSet;

  /// No description provided for @orbDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get orbDone;

  /// No description provided for @orbPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get orbPremium;

  /// No description provided for @orbName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get orbName;

  /// No description provided for @orbNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get orbNotSet;

  /// No description provided for @orbUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get orbUnlocked;

  /// No description provided for @orbPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get orbPoints;

  /// No description provided for @orbNextGoal.
  ///
  /// In en, this message translates to:
  /// **'Next goal'**
  String get orbNextGoal;

  /// No description provided for @orbAllDone.
  ///
  /// In en, this message translates to:
  /// **'All done'**
  String get orbAllDone;

  /// No description provided for @orbTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get orbTheme;

  /// No description provided for @orbMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get orbMode;

  /// No description provided for @orbCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get orbCurrency;

  /// No description provided for @orbLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get orbLanguage;

  /// No description provided for @orbAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get orbAlerts;

  /// No description provided for @orbReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get orbReminders;

  /// No description provided for @orbNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get orbNotifications;

  /// No description provided for @orbOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get orbOn;

  /// No description provided for @orbOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get orbOff;

  /// No description provided for @orbInTrash.
  ///
  /// In en, this message translates to:
  /// **'In trash'**
  String get orbInTrash;

  /// No description provided for @orbDataIssues.
  ///
  /// In en, this message translates to:
  /// **'Data issues'**
  String get orbDataIssues;

  /// No description provided for @orbNoMonthToCompare.
  ///
  /// In en, this message translates to:
  /// **'No month to compare yet'**
  String get orbNoMonthToCompare;

  /// No description provided for @orbPctOnLastMonth.
  ///
  /// In en, this message translates to:
  /// **'{pct}% on last month'**
  String orbPctOnLastMonth(String pct);

  /// No description provided for @orbNothingListed.
  ///
  /// In en, this message translates to:
  /// **'Nothing listed right now'**
  String get orbNothingListed;

  /// No description provided for @orbListedNoPrice.
  ///
  /// In en, this message translates to:
  /// **'Listed, no price set yet'**
  String get orbListedNoPrice;

  /// No description provided for @orbBestGame.
  ///
  /// In en, this message translates to:
  /// **'Best game'**
  String get orbBestGame;

  /// No description provided for @orbNoDataYet.
  ///
  /// In en, this message translates to:
  /// **'No data yet'**
  String get orbNoDataYet;

  /// No description provided for @orbAddToRank.
  ///
  /// In en, this message translates to:
  /// **'Add a game account to rank games'**
  String get orbAddToRank;

  /// No description provided for @orbFromAccounts.
  ///
  /// In en, this message translates to:
  /// **'{amount} from {count, plural, =1{1 account} other{{count} accounts}}'**
  String orbFromAccounts(String amount, int count);

  /// No description provided for @orbDiamondAccounts.
  ///
  /// In en, this message translates to:
  /// **'Diamond accounts'**
  String get orbDiamondAccounts;

  /// No description provided for @orbOutOfGoogle.
  ///
  /// In en, this message translates to:
  /// **'Out of {count} Google accounts'**
  String orbOutOfGoogle(int count);

  /// No description provided for @orbDataHealth.
  ///
  /// In en, this message translates to:
  /// **'Data health'**
  String get orbDataHealth;

  /// No description provided for @orbAllClear.
  ///
  /// In en, this message translates to:
  /// **'All clear'**
  String get orbAllClear;

  /// No description provided for @orbToReview.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String orbToReview(int count);

  /// No description provided for @orbNoDuplicatesOrIds.
  ///
  /// In en, this message translates to:
  /// **'No duplicates or missing IDs'**
  String get orbNoDuplicatesOrIds;

  /// No description provided for @orbDuplicatesEmailsIds.
  ///
  /// In en, this message translates to:
  /// **'Duplicates, bad emails or missing IDs'**
  String get orbDuplicatesEmailsIds;

  /// No description provided for @orbAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get orbAchievements;

  /// No description provided for @orbEveryBadge.
  ///
  /// In en, this message translates to:
  /// **'Every badge unlocked'**
  String get orbEveryBadge;

  /// No description provided for @orbNext.
  ///
  /// In en, this message translates to:
  /// **'Next: {title}'**
  String orbNext(String title);

  /// No description provided for @searchEveryScreen.
  ///
  /// In en, this message translates to:
  /// **'Search every screen'**
  String get searchEveryScreen;

  /// No description provided for @howGlobeWorks.
  ///
  /// In en, this message translates to:
  /// **'How the globe works'**
  String get howGlobeWorks;

  /// No description provided for @percentSemantics.
  ///
  /// In en, this message translates to:
  /// **'{label} {pct} percent'**
  String percentSemantics(String label, String pct);

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @whereToGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get whereToGo;

  /// No description provided for @searchScreenHint.
  ///
  /// In en, this message translates to:
  /// **'Search a screen, like profit or vault'**
  String get searchScreenHint;

  /// No description provided for @noScreenMatches.
  ///
  /// In en, this message translates to:
  /// **'No screen matches that.'**
  String get noScreenMatches;

  /// No description provided for @screensCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 screen} other{{count} screens}}'**
  String screensCount(int count);

  /// No description provided for @globeHelpDrag.
  ///
  /// In en, this message translates to:
  /// **'Drag the globe to turn it.'**
  String get globeHelpDrag;

  /// No description provided for @globeHelpTap.
  ///
  /// In en, this message translates to:
  /// **'Tap a glowing node to see what is inside that continent.'**
  String get globeHelpTap;

  /// No description provided for @globeHelpExplore.
  ///
  /// In en, this message translates to:
  /// **'Press Explore to dive in, then tap a card to open the screen.'**
  String get globeHelpExplore;

  /// No description provided for @globeHelpSearch.
  ///
  /// In en, this message translates to:
  /// **'The bar at the bottom finds any screen by name.'**
  String get globeHelpSearch;

  /// No description provided for @arenaStructSingleLeague.
  ///
  /// In en, this message translates to:
  /// **'Single League'**
  String get arenaStructSingleLeague;

  /// No description provided for @arenaStructMultipleLeagues.
  ///
  /// In en, this message translates to:
  /// **'Multiple Leagues'**
  String get arenaStructMultipleLeagues;

  /// No description provided for @arenaStructGroupsOnly.
  ///
  /// In en, this message translates to:
  /// **'Groups Only'**
  String get arenaStructGroupsOnly;

  /// No description provided for @arenaStructGroupsKnockout.
  ///
  /// In en, this message translates to:
  /// **'Groups + Knockout'**
  String get arenaStructGroupsKnockout;

  /// No description provided for @arenaStructLeaguesGroupsKnockout.
  ///
  /// In en, this message translates to:
  /// **'Leagues + Groups + Knockout'**
  String get arenaStructLeaguesGroupsKnockout;

  /// No description provided for @arenaStructKnockoutOnly.
  ///
  /// In en, this message translates to:
  /// **'Knockout Only'**
  String get arenaStructKnockoutOnly;

  /// No description provided for @arenaHintSingleLeague.
  ///
  /// In en, this message translates to:
  /// **'Everyone plays everyone in one table.'**
  String get arenaHintSingleLeague;

  /// No description provided for @arenaHintMultipleLeagues.
  ///
  /// In en, this message translates to:
  /// **'Participants are split into several independent leagues.'**
  String get arenaHintMultipleLeagues;

  /// No description provided for @arenaHintGroupsOnly.
  ///
  /// In en, this message translates to:
  /// **'One league divided into groups, each with its own table.'**
  String get arenaHintGroupsOnly;

  /// No description provided for @arenaHintGroupsKnockout.
  ///
  /// In en, this message translates to:
  /// **'Group stage, then the best qualify for a knockout bracket.'**
  String get arenaHintGroupsKnockout;

  /// No description provided for @arenaHintLeaguesGroupsKnockout.
  ///
  /// In en, this message translates to:
  /// **'Several leagues, each with groups; qualifiers meet in one knockout.'**
  String get arenaHintLeaguesGroupsKnockout;

  /// No description provided for @arenaHintKnockoutOnly.
  ///
  /// In en, this message translates to:
  /// **'Single-elimination bracket with byes when needed.'**
  String get arenaHintKnockoutOnly;

  /// No description provided for @arenaDetailUpTo48Players.
  ///
  /// In en, this message translates to:
  /// **'up to 48 players'**
  String get arenaDetailUpTo48Players;

  /// No description provided for @arenaDetailDuo.
  ///
  /// In en, this message translates to:
  /// **'up to 24 teams · 2 players each'**
  String get arenaDetailDuo;

  /// No description provided for @arenaDetailSquad.
  ///
  /// In en, this message translates to:
  /// **'up to 12 teams · 4 players each'**
  String get arenaDetailSquad;

  /// No description provided for @arenaDetailOnePerTeam.
  ///
  /// In en, this message translates to:
  /// **'1 player per team'**
  String get arenaDetailOnePerTeam;

  /// No description provided for @arenaDetailUpTo2.
  ///
  /// In en, this message translates to:
  /// **'up to 2 players per team'**
  String get arenaDetailUpTo2;

  /// No description provided for @arenaDetailUpTo4.
  ///
  /// In en, this message translates to:
  /// **'up to 4 players per team'**
  String get arenaDetailUpTo4;

  /// No description provided for @arenaDetailUpTo8.
  ///
  /// In en, this message translates to:
  /// **'up to 8 players per team'**
  String get arenaDetailUpTo8;

  /// No description provided for @arenaDetail1v1.
  ///
  /// In en, this message translates to:
  /// **'1 vs 1'**
  String get arenaDetail1v1;

  /// No description provided for @arenaDetailCoop.
  ///
  /// In en, this message translates to:
  /// **'team vs team · up to 3 players per team'**
  String get arenaDetailCoop;

  /// No description provided for @arenaDetailCustom.
  ///
  /// In en, this message translates to:
  /// **'custom team size'**
  String get arenaDetailCustom;

  /// No description provided for @arenaTbHeadToHead.
  ///
  /// In en, this message translates to:
  /// **'Head-to-head'**
  String get arenaTbHeadToHead;

  /// No description provided for @arenaTbGoalDifference.
  ///
  /// In en, this message translates to:
  /// **'Goal difference'**
  String get arenaTbGoalDifference;

  /// No description provided for @arenaTbGoalsScored.
  ///
  /// In en, this message translates to:
  /// **'Goals scored'**
  String get arenaTbGoalsScored;

  /// No description provided for @arenaTbGoalsAgainst.
  ///
  /// In en, this message translates to:
  /// **'Goals against'**
  String get arenaTbGoalsAgainst;

  /// No description provided for @arenaTbShortH2h.
  ///
  /// In en, this message translates to:
  /// **'H2H'**
  String get arenaTbShortH2h;

  /// No description provided for @arenaTbShortGd.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get arenaTbShortGd;

  /// No description provided for @arenaTbShortGf.
  ///
  /// In en, this message translates to:
  /// **'GF'**
  String get arenaTbShortGf;

  /// No description provided for @arenaTbShortGa.
  ///
  /// In en, this message translates to:
  /// **'GA'**
  String get arenaTbShortGa;

  /// No description provided for @arenaTbExplainH2h.
  ///
  /// In en, this message translates to:
  /// **'Teams level on points are ranked by the matches they played against each other: points first, then goal difference in those matches.'**
  String get arenaTbExplainH2h;

  /// No description provided for @arenaTbExplainGd.
  ///
  /// In en, this message translates to:
  /// **'Goals scored minus goals conceded over all matches.'**
  String get arenaTbExplainGd;

  /// No description provided for @arenaTbExplainGf.
  ///
  /// In en, this message translates to:
  /// **'The team that scored more goals ranks higher.'**
  String get arenaTbExplainGf;

  /// No description provided for @arenaTbExplainGa.
  ///
  /// In en, this message translates to:
  /// **'The team that conceded fewer goals ranks higher.'**
  String get arenaTbExplainGa;

  /// No description provided for @arenaKoPenalties.
  ///
  /// In en, this message translates to:
  /// **'Penalties'**
  String get arenaKoPenalties;

  /// No description provided for @arenaKoExtraTime.
  ///
  /// In en, this message translates to:
  /// **'Extra time'**
  String get arenaKoExtraTime;

  /// No description provided for @arenaKoReplay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get arenaKoReplay;

  /// No description provided for @arenaKoHintPenalties.
  ///
  /// In en, this message translates to:
  /// **'Level after normal time: decided by a penalty shoot-out.'**
  String get arenaKoHintPenalties;

  /// No description provided for @arenaKoHintExtraTime.
  ///
  /// In en, this message translates to:
  /// **'Level after normal time: extra time is played. If still level, penalties decide.'**
  String get arenaKoHintExtraTime;

  /// No description provided for @arenaKoHintReplay.
  ///
  /// In en, this message translates to:
  /// **'Level after normal time: the match is played again until there is a winner.'**
  String get arenaKoHintReplay;

  /// No description provided for @arenaAet.
  ///
  /// In en, this message translates to:
  /// **'a.e.t.'**
  String get arenaAet;

  /// No description provided for @arenaPens.
  ///
  /// In en, this message translates to:
  /// **'pens'**
  String get arenaPens;

  /// No description provided for @arenaColPldShort.
  ///
  /// In en, this message translates to:
  /// **'Pld'**
  String get arenaColPldShort;

  /// No description provided for @arenaColWShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get arenaColWShort;

  /// No description provided for @arenaColDShort.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get arenaColDShort;

  /// No description provided for @arenaColLShort.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get arenaColLShort;

  /// No description provided for @arenaColGfShort.
  ///
  /// In en, this message translates to:
  /// **'GF'**
  String get arenaColGfShort;

  /// No description provided for @arenaColGaShort.
  ///
  /// In en, this message translates to:
  /// **'GA'**
  String get arenaColGaShort;

  /// No description provided for @arenaColGdShort.
  ///
  /// In en, this message translates to:
  /// **'GD'**
  String get arenaColGdShort;

  /// No description provided for @arenaColPtsShort.
  ///
  /// In en, this message translates to:
  /// **'Pts'**
  String get arenaColPtsShort;

  /// No description provided for @arenaColPlayed.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get arenaColPlayed;

  /// No description provided for @arenaColWins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get arenaColWins;

  /// No description provided for @arenaColDraws.
  ///
  /// In en, this message translates to:
  /// **'Draws'**
  String get arenaColDraws;

  /// No description provided for @arenaColLosses.
  ///
  /// In en, this message translates to:
  /// **'Losses'**
  String get arenaColLosses;

  /// No description provided for @arenaColGoalsFor.
  ///
  /// In en, this message translates to:
  /// **'Goals for'**
  String get arenaColGoalsFor;

  /// No description provided for @arenaColGoalsAgainst.
  ///
  /// In en, this message translates to:
  /// **'Goals against'**
  String get arenaColGoalsAgainst;

  /// No description provided for @arenaColGoalDifference.
  ///
  /// In en, this message translates to:
  /// **'Goal difference'**
  String get arenaColGoalDifference;

  /// No description provided for @arenaColPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get arenaColPoints;

  /// No description provided for @arenaScorePens.
  ///
  /// In en, this message translates to:
  /// **'{score} ({pens} pens)'**
  String arenaScorePens(String score, String pens);

  /// No description provided for @arenaErrKillPoints.
  ///
  /// In en, this message translates to:
  /// **'Kill points cannot be negative.'**
  String get arenaErrKillPoints;

  /// No description provided for @arenaErrPlacementRows.
  ///
  /// In en, this message translates to:
  /// **'The placement table needs exactly {slots} rows (one per participant or team); it has {count}.'**
  String arenaErrPlacementRows(int slots, int count);

  /// No description provided for @arenaErrPlacementNegative.
  ///
  /// In en, this message translates to:
  /// **'Placement points cannot be negative.'**
  String get arenaErrPlacementNegative;

  /// No description provided for @arenaErrPlacementOrder.
  ///
  /// In en, this message translates to:
  /// **'A lower placement cannot score more than a higher one (#{lower} scores more than #{higher}).'**
  String arenaErrPlacementOrder(int lower, int higher);

  /// No description provided for @arenaErrFirstPlace.
  ///
  /// In en, this message translates to:
  /// **'1st place must score more than 0.'**
  String get arenaErrFirstPlace;

  /// No description provided for @arenaErrZeroTail.
  ///
  /// In en, this message translates to:
  /// **'The last {count} placements must score 0 placement points.'**
  String arenaErrZeroTail(int count);

  /// No description provided for @arenaTbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get arenaTbd;

  /// No description provided for @arenaUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get arenaUnknown;

  /// No description provided for @arenaErrNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Tournament name is required.'**
  String get arenaErrNameRequired;

  /// No description provided for @arenaErrMin2.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 participants.'**
  String get arenaErrMin2;

  /// No description provided for @arenaErrTooMany.
  ///
  /// In en, this message translates to:
  /// **'Participants ({count}) exceed the maximum ({max}).'**
  String arenaErrTooMany(int count, int max);

  /// No description provided for @arenaErrDeadline.
  ///
  /// In en, this message translates to:
  /// **'Registration deadline must be on or before the start date.'**
  String get arenaErrDeadline;

  /// No description provided for @arenaErrWinPoints.
  ///
  /// In en, this message translates to:
  /// **'Win points must be at least the draw points.'**
  String get arenaErrWinPoints;

  /// No description provided for @arenaErrMinColumns.
  ///
  /// In en, this message translates to:
  /// **'Show at least 1 column in the standings table.'**
  String get arenaErrMinColumns;

  /// No description provided for @arenaErrMaxColumns.
  ///
  /// In en, this message translates to:
  /// **'The standings table can show at most {max} columns.'**
  String arenaErrMaxColumns(int max);

  /// No description provided for @arenaErrMinRounds.
  ///
  /// In en, this message translates to:
  /// **'Plan at least 1 round.'**
  String get arenaErrMinRounds;

  /// No description provided for @arenaErrMinLeagues.
  ///
  /// In en, this message translates to:
  /// **'Use at least 2 leagues.'**
  String get arenaErrMinLeagues;

  /// No description provided for @arenaErrMinGroups.
  ///
  /// In en, this message translates to:
  /// **'Use at least 2 groups per league.'**
  String get arenaErrMinGroups;

  /// No description provided for @arenaErrNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Not enough participants: {leagues} league(s) x {groups} group(s) need at least {min}.'**
  String arenaErrNotEnough(int leagues, int groups, int min);

  /// No description provided for @arenaErrMinQualifier.
  ///
  /// In en, this message translates to:
  /// **'At least 1 qualifier per group is required.'**
  String get arenaErrMinQualifier;

  /// No description provided for @arenaErrQualifiersExceed.
  ///
  /// In en, this message translates to:
  /// **'Qualifiers per group ({q}) exceed the smallest group size ({min}).'**
  String arenaErrQualifiersExceed(int q, int min);

  /// No description provided for @arenaErrMin2Qualify.
  ///
  /// In en, this message translates to:
  /// **'At least 2 participants must qualify for the knockout.'**
  String get arenaErrMin2Qualify;

  /// No description provided for @arenaErrWinnerColumns.
  ///
  /// In en, this message translates to:
  /// **'{mode} is decided by the winner: pick at least one of {columns}.'**
  String arenaErrWinnerColumns(String mode, String columns);

  /// No description provided for @arenaErrMaxTeams.
  ///
  /// In en, this message translates to:
  /// **'{mode} allows at most {cap} teams (you have {count}).'**
  String arenaErrMaxTeams(String mode, int cap, int count);

  /// No description provided for @arenaErrMaxPlayers.
  ///
  /// In en, this message translates to:
  /// **'{mode} allows at most {cap} players (you have {count}).'**
  String arenaErrMaxPlayers(String mode, int cap, int count);

  /// No description provided for @arenaErrMinTeamsBr.
  ///
  /// In en, this message translates to:
  /// **'{mode} needs at least {min} teams (placement points are not awarded to the last {tail} places).'**
  String arenaErrMinTeamsBr(String mode, int min, int tail);

  /// No description provided for @arenaErrMinPlayersBr.
  ///
  /// In en, this message translates to:
  /// **'{mode} needs at least {min} players (placement points are not awarded to the last {tail} places).'**
  String arenaErrMinPlayersBr(String mode, int min, int tail);

  /// No description provided for @arenaErrExactPlayers.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" must have exactly {size} players.'**
  String arenaErrExactPlayers(String name, int size);

  /// No description provided for @arenaErrBetweenPlayers.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" must have between 1 and {size} players.'**
  String arenaErrBetweenPlayers(String name, int size);

  /// No description provided for @arenaErrAssignedTwice.
  ///
  /// In en, this message translates to:
  /// **'Player \"{name}\" is assigned twice.'**
  String arenaErrAssignedTwice(String name);

  /// No description provided for @arenaErrAppearsTwice.
  ///
  /// In en, this message translates to:
  /// **'Player \"{name}\" appears more than once.'**
  String arenaErrAppearsTwice(String name);

  /// No description provided for @arenaErrMinTotalPlayers.
  ///
  /// In en, this message translates to:
  /// **'At least {min} players must be registered in total (currently {total}).'**
  String arenaErrMinTotalPlayers(int min, int total);

  /// No description provided for @arenaLogCreatedBr.
  ///
  /// In en, this message translates to:
  /// **'Tournament created: {count} Battle Royale round(s)'**
  String arenaLogCreatedBr(int count);

  /// No description provided for @arenaLogCreatedKo.
  ///
  /// In en, this message translates to:
  /// **'Tournament created: knockout bracket generated'**
  String get arenaLogCreatedKo;

  /// No description provided for @arenaLogCreatedFixtures.
  ///
  /// In en, this message translates to:
  /// **'Tournament created: {count} fixtures generated'**
  String arenaLogCreatedFixtures(int count);

  /// No description provided for @arenaLeague.
  ///
  /// In en, this message translates to:
  /// **'League'**
  String get arenaLeague;

  /// No description provided for @arenaLeagueLetter.
  ///
  /// In en, this message translates to:
  /// **'League {letter}'**
  String arenaLeagueLetter(String letter);

  /// No description provided for @arenaGroupName.
  ///
  /// In en, this message translates to:
  /// **'Group {name}'**
  String arenaGroupName(String name);

  /// No description provided for @arenaFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get arenaFinal;

  /// No description provided for @arenaSemiFinals.
  ///
  /// In en, this message translates to:
  /// **'Semi-finals'**
  String get arenaSemiFinals;

  /// No description provided for @arenaQuarterFinals.
  ///
  /// In en, this message translates to:
  /// **'Quarter-finals'**
  String get arenaQuarterFinals;

  /// No description provided for @arenaRoundOf.
  ///
  /// In en, this message translates to:
  /// **'Round of {count}'**
  String arenaRoundOf(int count);

  /// No description provided for @arenaCritPoints.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get arenaCritPoints;

  /// No description provided for @arenaCritAllLevel.
  ///
  /// In en, this message translates to:
  /// **'Level on all criteria (name order)'**
  String get arenaCritAllLevel;

  /// No description provided for @arenaNoteMorePoints.
  ///
  /// In en, this message translates to:
  /// **'{a} has more points ({pa} vs {pb}).'**
  String arenaNoteMorePoints(String a, int pa, int pb);

  /// No description provided for @arenaNoteH2hBeat.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts. Head-to-head: {a} beat {b} {score} in their direct match.'**
  String arenaNoteH2hBeat(int points, String a, String b, String score);

  /// No description provided for @arenaNoteH2hRecord.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts. Head-to-head: {a} has the better record in the matches between the tied teams.'**
  String arenaNoteH2hRecord(int points, String a);

  /// No description provided for @arenaNoteGd.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts. Goal difference: {a} {va} vs {b} {vb}.'**
  String arenaNoteGd(int points, String a, String va, String b, String vb);

  /// No description provided for @arenaNoteGf.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts. Goals scored: {a} {va} vs {b} {vb}.'**
  String arenaNoteGf(int points, String a, int va, String b, int vb);

  /// No description provided for @arenaNoteGa.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts. Goals against: {a} {va} vs {b} {vb} (fewer is better).'**
  String arenaNoteGa(int points, String a, int va, String b, int vb);

  /// No description provided for @arenaNoteByName.
  ///
  /// In en, this message translates to:
  /// **'Level on every criterion: ranked by name.'**
  String get arenaNoteByName;

  /// No description provided for @arenaErrNoGroupStage.
  ///
  /// In en, this message translates to:
  /// **'This tournament has no group stage to qualify from.'**
  String get arenaErrNoGroupStage;

  /// No description provided for @arenaErrKoAlready.
  ///
  /// In en, this message translates to:
  /// **'The knockout stage was already generated.'**
  String get arenaErrKoAlready;

  /// No description provided for @arenaErrConfirmGroups.
  ///
  /// In en, this message translates to:
  /// **'Confirm every group match before generating the knockout.'**
  String get arenaErrConfirmGroups;

  /// No description provided for @arenaErrMin2Qualified.
  ///
  /// In en, this message translates to:
  /// **'At least 2 participants must qualify.'**
  String get arenaErrMin2Qualified;

  /// No description provided for @arenaLogKoGenerated.
  ///
  /// In en, this message translates to:
  /// **'Knockout generated from group standings ({count} qualifiers)'**
  String arenaLogKoGenerated(int count);

  /// No description provided for @arenaErrScoredMode.
  ///
  /// In en, this message translates to:
  /// **'This mode is scored with a result, not by picking a winner.'**
  String get arenaErrScoredMode;

  /// No description provided for @arenaErrMatchNotFound.
  ///
  /// In en, this message translates to:
  /// **'Match not found.'**
  String get arenaErrMatchNotFound;

  /// No description provided for @arenaErrWinnerSide.
  ///
  /// In en, this message translates to:
  /// **'The winner must be one of the two sides.'**
  String get arenaErrWinnerSide;

  /// No description provided for @arenaErrByeNoResult.
  ///
  /// In en, this message translates to:
  /// **'A bye has no result.'**
  String get arenaErrByeNoResult;

  /// No description provided for @arenaErrCancelled.
  ///
  /// In en, this message translates to:
  /// **'This match was cancelled.'**
  String get arenaErrCancelled;

  /// No description provided for @arenaErrBothKnown.
  ///
  /// In en, this message translates to:
  /// **'Both participants must be known first.'**
  String get arenaErrBothKnown;

  /// No description provided for @arenaErrNegativeScore.
  ///
  /// In en, this message translates to:
  /// **'Scores cannot be negative.'**
  String get arenaErrNegativeScore;

  /// No description provided for @arenaErrKoLocksGroups.
  ///
  /// In en, this message translates to:
  /// **'The knockout stage is already generated. Reset results to change group scores.'**
  String get arenaErrKoLocksGroups;

  /// No description provided for @arenaErrNextRoundPlayed.
  ///
  /// In en, this message translates to:
  /// **'The next round was already played. Reset results to change this score.'**
  String get arenaErrNextRoundPlayed;

  /// No description provided for @arenaLogReplay.
  ///
  /// In en, this message translates to:
  /// **'Draw {score}: {home} vs {away} will be replayed (replay #{n})'**
  String arenaLogReplay(String score, String home, String away, int n);

  /// No description provided for @arenaErrEnterPensAfterNormal.
  ///
  /// In en, this message translates to:
  /// **'Level after normal time: enter the penalty shoot-out score.'**
  String get arenaErrEnterPensAfterNormal;

  /// No description provided for @arenaErrEnterPensAfterExtra.
  ///
  /// In en, this message translates to:
  /// **'Level after extra time: enter the penalty shoot-out score.'**
  String get arenaErrEnterPensAfterExtra;

  /// No description provided for @arenaErrNegativePens.
  ///
  /// In en, this message translates to:
  /// **'Penalty scores cannot be negative.'**
  String get arenaErrNegativePens;

  /// No description provided for @arenaErrPensWinner.
  ///
  /// In en, this message translates to:
  /// **'A penalty shoot-out needs a winner.'**
  String get arenaErrPensWinner;

  /// No description provided for @arenaLogAmended.
  ///
  /// In en, this message translates to:
  /// **'Result amended: {names}'**
  String arenaLogAmended(String names);

  /// No description provided for @arenaLogConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Result confirmed: {names}'**
  String arenaLogConfirmed(String names);

  /// No description provided for @arenaLockBrConfirmed.
  ///
  /// In en, this message translates to:
  /// **'A Battle Royale round is already confirmed. Reset results to change rosters.'**
  String get arenaLockBrConfirmed;

  /// No description provided for @arenaLockPlayed.
  ///
  /// In en, this message translates to:
  /// **'A match of these teams was already played. Reset results to make this change.'**
  String get arenaLockPlayed;

  /// No description provided for @arenaErrParticipantNotFound.
  ///
  /// In en, this message translates to:
  /// **'Participant not found.'**
  String get arenaErrParticipantNotFound;

  /// No description provided for @arenaErrNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'The name cannot be empty.'**
  String get arenaErrNameEmpty;

  /// No description provided for @arenaLogRenamed.
  ///
  /// In en, this message translates to:
  /// **'Renamed: {old} -> {name}'**
  String arenaLogRenamed(String old, String name);

  /// No description provided for @arenaErrNoRosters.
  ///
  /// In en, this message translates to:
  /// **'This mode has no team rosters.'**
  String get arenaErrNoRosters;

  /// No description provided for @arenaErrTeamNeedsPlayer.
  ///
  /// In en, this message translates to:
  /// **'A team needs at least 1 player.'**
  String get arenaErrTeamNeedsPlayer;

  /// No description provided for @arenaErrMaxPerTeam.
  ///
  /// In en, this message translates to:
  /// **'{mode} allows at most {size} players per team.'**
  String arenaErrMaxPerTeam(String mode, int size);

  /// No description provided for @arenaErrExactPerTeam.
  ///
  /// In en, this message translates to:
  /// **'Every team must have exactly {size} players.'**
  String arenaErrExactPerTeam(int size);

  /// No description provided for @arenaErrPlayerNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Player names cannot be empty.'**
  String get arenaErrPlayerNameEmpty;

  /// No description provided for @arenaErrAlreadyInTeam.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" is already assigned to a team.'**
  String arenaErrAlreadyInTeam(String name);

  /// No description provided for @arenaErrAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" is already registered.'**
  String arenaErrAlreadyRegistered(String name);

  /// No description provided for @arenaLogRoster.
  ///
  /// In en, this message translates to:
  /// **'Roster updated: {team} ({count} players)'**
  String arenaLogRoster(String team, int count);

  /// No description provided for @arenaErrChooseTwo.
  ///
  /// In en, this message translates to:
  /// **'Choose two different ones.'**
  String get arenaErrChooseTwo;

  /// No description provided for @arenaLogSwapped.
  ///
  /// In en, this message translates to:
  /// **'Swapped: {a} <-> {b}'**
  String arenaLogSwapped(String a, String b);

  /// No description provided for @arenaErrChooseTwoPlayers.
  ///
  /// In en, this message translates to:
  /// **'Choose two different players.'**
  String get arenaErrChooseTwoPlayers;

  /// No description provided for @arenaErrPlayerNotInTeam.
  ///
  /// In en, this message translates to:
  /// **'Player not found in that team.'**
  String get arenaErrPlayerNotInTeam;

  /// No description provided for @arenaLogPlayersSwapped.
  ///
  /// In en, this message translates to:
  /// **'Players swapped: {a} ({ta}) <-> {b} ({tb})'**
  String arenaLogPlayersSwapped(String a, String ta, String b, String tb);

  /// No description provided for @arenaErrOnlyBrRounds.
  ///
  /// In en, this message translates to:
  /// **'Only Battle Royale tournaments have rounds.'**
  String get arenaErrOnlyBrRounds;

  /// No description provided for @arenaLogRoundAdded.
  ///
  /// In en, this message translates to:
  /// **'Round {n} added'**
  String arenaLogRoundAdded(int n);

  /// No description provided for @arenaErrRoundNotFound.
  ///
  /// In en, this message translates to:
  /// **'Round not found.'**
  String get arenaErrRoundNotFound;

  /// No description provided for @arenaErrUnknownInResults.
  ///
  /// In en, this message translates to:
  /// **'Unknown participant in results.'**
  String get arenaErrUnknownInResults;

  /// No description provided for @arenaErrEnterPlacements.
  ///
  /// In en, this message translates to:
  /// **'Enter a placement for every participant.'**
  String get arenaErrEnterPlacements;

  /// No description provided for @arenaErrPlacementRange.
  ///
  /// In en, this message translates to:
  /// **'Placements must be between 1 and {n}.'**
  String arenaErrPlacementRange(int n);

  /// No description provided for @arenaErrSamePlacement.
  ///
  /// In en, this message translates to:
  /// **'Two participants have placement {n}.'**
  String arenaErrSamePlacement(int n);

  /// No description provided for @arenaErrNegativeKills.
  ///
  /// In en, this message translates to:
  /// **'Kills cannot be negative.'**
  String get arenaErrNegativeKills;

  /// No description provided for @arenaLogRoundAmended.
  ///
  /// In en, this message translates to:
  /// **'Round {n} amended'**
  String arenaLogRoundAmended(int n);

  /// No description provided for @arenaLogRoundConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Round {n} confirmed'**
  String arenaLogRoundConfirmed(int n);

  /// No description provided for @arenaCritWins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get arenaCritWins;

  /// No description provided for @arenaCritKills.
  ///
  /// In en, this message translates to:
  /// **'Kills'**
  String get arenaCritKills;

  /// No description provided for @arenaCritLastRound.
  ///
  /// In en, this message translates to:
  /// **'Last round placement'**
  String get arenaCritLastRound;

  /// No description provided for @arenaCritNameOrder.
  ///
  /// In en, this message translates to:
  /// **'Name order'**
  String get arenaCritNameOrder;

  /// No description provided for @arenaBrNoteWins.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts. Wins (1st places): {a} {wa} vs {b} {wb}.'**
  String arenaBrNoteWins(int points, String a, int wa, String b, int wb);

  /// No description provided for @arenaBrNoteKills.
  ///
  /// In en, this message translates to:
  /// **'Level on {points} pts and wins. Kills: {a} {ka} vs {b} {kb}.'**
  String arenaBrNoteKills(int points, String a, int ka, String b, int kb);

  /// No description provided for @arenaBrNoteLastRound.
  ///
  /// In en, this message translates to:
  /// **'Level on points, wins and kills. Better placement in the latest round: {a}.'**
  String arenaBrNoteLastRound(String a);

  /// No description provided for @arenaLogReset.
  ///
  /// In en, this message translates to:
  /// **'All results were reset by the organizer'**
  String get arenaLogReset;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @noTournamentsYet.
  ///
  /// In en, this message translates to:
  /// **'No tournaments yet'**
  String get noTournamentsYet;

  /// No description provided for @createFirstTournament.
  ///
  /// In en, this message translates to:
  /// **'Create your first league, groups or knockout competition.'**
  String get createFirstTournament;

  /// No description provided for @tournamentsOnDevice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tournament on this device} other{{count} tournaments on this device}}'**
  String tournamentsOnDevice(int count);

  /// No description provided for @participantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 participant} other{{count} participants}}'**
  String participantsCount(int count);

  /// No description provided for @champion.
  ///
  /// In en, this message translates to:
  /// **'Champion: {name}'**
  String champion(String name);

  /// No description provided for @roundsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} rounds confirmed'**
  String roundsConfirmed(int done, int total);

  /// No description provided for @matchesConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} matches confirmed'**
  String matchesConfirmed(int done, int total);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @renamePlayer.
  ///
  /// In en, this message translates to:
  /// **'Rename player'**
  String get renamePlayer;

  /// No description provided for @nameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Name updated.'**
  String get nameUpdated;

  /// No description provided for @swapTeams.
  ///
  /// In en, this message translates to:
  /// **'Swap Teams'**
  String get swapTeams;

  /// No description provided for @swapPlayers.
  ///
  /// In en, this message translates to:
  /// **'Swap Players'**
  String get swapPlayers;

  /// No description provided for @teamA.
  ///
  /// In en, this message translates to:
  /// **'Team A'**
  String get teamA;

  /// No description provided for @teamB.
  ///
  /// In en, this message translates to:
  /// **'Team B'**
  String get teamB;

  /// No description provided for @playerA.
  ///
  /// In en, this message translates to:
  /// **'Player A'**
  String get playerA;

  /// No description provided for @playerB.
  ///
  /// In en, this message translates to:
  /// **'Player B'**
  String get playerB;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @swapQuestion.
  ///
  /// In en, this message translates to:
  /// **'Swap {a} and {b}?'**
  String swapQuestion(String a, String b);

  /// No description provided for @swapTeamsBody.
  ///
  /// In en, this message translates to:
  /// **'{a} takes the place of {b} in the draw, and the other way round. Each team keeps its own players.'**
  String swapTeamsBody(String a, String b);

  /// No description provided for @swapSoloBody.
  ///
  /// In en, this message translates to:
  /// **'{a} takes the place of {b} in the draw, and the other way round.'**
  String swapSoloBody(String a, String b);

  /// No description provided for @swapped.
  ///
  /// In en, this message translates to:
  /// **'{a} and {b} swapped.'**
  String swapped(String a, String b);

  /// No description provided for @addPlayersFirst.
  ///
  /// In en, this message translates to:
  /// **'Add player names to at least two spots first.'**
  String get addPlayersFirst;

  /// No description provided for @swapPlayersBody.
  ///
  /// In en, this message translates to:
  /// **'{a} ({ta}) and {b} ({tb}) exchange teams. Team sizes do not change.'**
  String swapPlayersBody(String a, String ta, String b, String tb);

  /// No description provided for @teamsAndPlayers.
  ///
  /// In en, this message translates to:
  /// **'Teams and players'**
  String get teamsAndPlayers;

  /// No description provided for @tournamentGone.
  ///
  /// In en, this message translates to:
  /// **'This tournament no longer exists.'**
  String get tournamentGone;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @searchTeamsOrPlayers.
  ///
  /// In en, this message translates to:
  /// **'Search teams or players'**
  String get searchTeamsOrPlayers;

  /// No description provided for @searchPlayers.
  ///
  /// In en, this message translates to:
  /// **'Search players'**
  String get searchPlayers;

  /// No description provided for @teamsAndPlayersCount.
  ///
  /// In en, this message translates to:
  /// **'{teams} teams · {players} players'**
  String teamsAndPlayersCount(int teams, int players);

  /// No description provided for @playersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 player} other{{count} players}}'**
  String playersCount(int count);

  /// No description provided for @playedTeamsLocked.
  ///
  /// In en, this message translates to:
  /// **'Played teams are locked'**
  String get playedTeamsLocked;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found.'**
  String get nothingFound;

  /// No description provided for @playersOfMax.
  ///
  /// In en, this message translates to:
  /// **'{count} / {max} players'**
  String playersOfMax(int count, int max);

  /// No description provided for @noPlayerNamesTap.
  ///
  /// In en, this message translates to:
  /// **'No player names yet. Tap to add them.'**
  String get noPlayerNamesTap;

  /// No description provided for @teamNotFound.
  ///
  /// In en, this message translates to:
  /// **'Team not found.'**
  String get teamNotFound;

  /// No description provided for @renameTeam.
  ///
  /// In en, this message translates to:
  /// **'Rename team'**
  String get renameTeam;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Team name'**
  String get teamName;

  /// No description provided for @teamRenamed.
  ///
  /// In en, this message translates to:
  /// **'Team renamed.'**
  String get teamRenamed;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add player'**
  String get addPlayer;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get playerName;

  /// No description provided for @nameAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added.'**
  String nameAdded(String name);

  /// No description provided for @playerRenamed.
  ///
  /// In en, this message translates to:
  /// **'Player renamed.'**
  String get playerRenamed;

  /// No description provided for @removeNameQ.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String removeNameQ(String name);

  /// No description provided for @leavesTeam.
  ///
  /// In en, this message translates to:
  /// **'{name} leaves {team}.'**
  String leavesTeam(String name, String team);

  /// No description provided for @nameRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed.'**
  String nameRemoved(String name);

  /// No description provided for @fixedTeamSizeNote.
  ///
  /// In en, this message translates to:
  /// **'Teams in {mode} always have exactly {size} players. Use Swap Players to exchange members.'**
  String fixedTeamSizeNote(String mode, int size);

  /// No description provided for @noPlayerNamesYet.
  ///
  /// In en, this message translates to:
  /// **'No player names yet.'**
  String get noPlayerNamesYet;

  /// No description provided for @tournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament'**
  String get tournament;

  /// No description provided for @tabStandings.
  ///
  /// In en, this message translates to:
  /// **'Standings'**
  String get tabStandings;

  /// No description provided for @tabRounds.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get tabRounds;

  /// No description provided for @tabMatches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get tabMatches;

  /// No description provided for @tabBracket.
  ///
  /// In en, this message translates to:
  /// **'Bracket'**
  String get tabBracket;

  /// No description provided for @tabInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get tabInfo;

  /// No description provided for @resetAllResultsQ.
  ///
  /// In en, this message translates to:
  /// **'Reset all results?'**
  String get resetAllResultsQ;

  /// No description provided for @resetBodyKo.
  ///
  /// In en, this message translates to:
  /// **'Every confirmed result is cleared and the knockout bracket is removed. The reset is recorded in the audit log.'**
  String get resetBodyKo;

  /// No description provided for @resetBody.
  ///
  /// In en, this message translates to:
  /// **'Every confirmed result is cleared. The reset is recorded in the audit log.'**
  String get resetBody;

  /// No description provided for @deleteTournamentQ.
  ///
  /// In en, this message translates to:
  /// **'Delete tournament?'**
  String get deleteTournamentQ;

  /// No description provided for @cannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get cannotBeUndone;

  /// No description provided for @resetResults.
  ///
  /// In en, this message translates to:
  /// **'Reset results'**
  String get resetResults;

  /// No description provided for @deleteTournament.
  ///
  /// In en, this message translates to:
  /// **'Delete tournament'**
  String get deleteTournament;

  /// No description provided for @knockoutStage.
  ///
  /// In en, this message translates to:
  /// **'Knockout stage'**
  String get knockoutStage;

  /// No description provided for @topNOfEveryGroup.
  ///
  /// In en, this message translates to:
  /// **'Top {n} of every group qualify.'**
  String topNOfEveryGroup(int n);

  /// No description provided for @generateKnockout.
  ///
  /// In en, this message translates to:
  /// **'Generate knockout'**
  String get generateKnockout;

  /// No description provided for @confirmGroupMatchesFirst.
  ///
  /// In en, this message translates to:
  /// **'Confirm all group matches first'**
  String get confirmGroupMatchesFirst;

  /// No description provided for @championCaps.
  ///
  /// In en, this message translates to:
  /// **'CHAMPION'**
  String get championCaps;

  /// No description provided for @topNQualify.
  ///
  /// In en, this message translates to:
  /// **'Top {n} qualify'**
  String topNQualify(int n);

  /// No description provided for @howTiesResolved.
  ///
  /// In en, this message translates to:
  /// **'How ties were resolved'**
  String get howTiesResolved;

  /// No description provided for @matchday.
  ///
  /// In en, this message translates to:
  /// **'Matchday {n}'**
  String matchday(int n);

  /// No description provided for @toPlay.
  ///
  /// In en, this message translates to:
  /// **'To play'**
  String get toPlay;

  /// No description provided for @filterPlayed.
  ///
  /// In en, this message translates to:
  /// **'Played'**
  String get filterPlayed;

  /// No description provided for @noMatchesHere.
  ///
  /// In en, this message translates to:
  /// **'No matches here.'**
  String get noMatchesHere;

  /// No description provided for @bye.
  ///
  /// In en, this message translates to:
  /// **'BYE'**
  String get bye;

  /// No description provided for @win.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get win;

  /// No description provided for @vs.
  ///
  /// In en, this message translates to:
  /// **'vs'**
  String get vs;

  /// No description provided for @enterBothScores.
  ///
  /// In en, this message translates to:
  /// **'Enter both scores as whole numbers.'**
  String get enterBothScores;

  /// No description provided for @pickWinner.
  ///
  /// In en, this message translates to:
  /// **'Pick the winner.'**
  String get pickWinner;

  /// No description provided for @amendResult.
  ///
  /// In en, this message translates to:
  /// **'Amend result'**
  String get amendResult;

  /// No description provided for @whoWon.
  ///
  /// In en, this message translates to:
  /// **'Who won?'**
  String get whoWon;

  /// No description provided for @pickWinningSide.
  ///
  /// In en, this message translates to:
  /// **'Pick the winning side.'**
  String get pickWinningSide;

  /// No description provided for @amendmentsRecorded.
  ///
  /// In en, this message translates to:
  /// **'Amendments are recorded in the audit log.'**
  String get amendmentsRecorded;

  /// No description provided for @saveAmendment.
  ///
  /// In en, this message translates to:
  /// **'Save amendment'**
  String get saveAmendment;

  /// No description provided for @confirmResult.
  ///
  /// In en, this message translates to:
  /// **'Confirm result'**
  String get confirmResult;

  /// No description provided for @enterResult.
  ///
  /// In en, this message translates to:
  /// **'Enter result'**
  String get enterResult;

  /// No description provided for @decidedInExtraTime.
  ///
  /// In en, this message translates to:
  /// **'Decided in extra time'**
  String get decidedInExtraTime;

  /// No description provided for @penaltyShootout.
  ///
  /// In en, this message translates to:
  /// **'Penalty shoot-out'**
  String get penaltyShootout;

  /// No description provided for @levelReplayNote.
  ///
  /// In en, this message translates to:
  /// **'Level score: this match goes back to \"to play\" and is played again.'**
  String get levelReplayNote;

  /// No description provided for @earlierDraws.
  ///
  /// In en, this message translates to:
  /// **'Earlier draws: {list}'**
  String earlierDraws(String list);

  /// No description provided for @overallStandings.
  ///
  /// In en, this message translates to:
  /// **'Overall standings'**
  String get overallStandings;

  /// No description provided for @brRoundsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total} rounds'**
  String brRoundsProgress(int done, int total);

  /// No description provided for @brTotalFormula.
  ///
  /// In en, this message translates to:
  /// **'Total = placement points + kills x {k}'**
  String brTotalFormula(int k);

  /// No description provided for @colRnd.
  ///
  /// In en, this message translates to:
  /// **'Rnd'**
  String get colRnd;

  /// No description provided for @colPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get colPlace;

  /// No description provided for @colKills.
  ///
  /// In en, this message translates to:
  /// **'Kills'**
  String get colKills;

  /// No description provided for @colKillPts.
  ///
  /// In en, this message translates to:
  /// **'Kill pts'**
  String get colKillPts;

  /// No description provided for @colTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get colTotal;

  /// No description provided for @roundN.
  ///
  /// In en, this message translates to:
  /// **'Round {n}'**
  String roundN(int n);

  /// No description provided for @roundConfirmedTap.
  ///
  /// In en, this message translates to:
  /// **'Confirmed · tap to amend'**
  String get roundConfirmedTap;

  /// No description provided for @roundTapToEnter.
  ///
  /// In en, this message translates to:
  /// **'Tap to enter placements and kills'**
  String get roundTapToEnter;

  /// No description provided for @addRound.
  ///
  /// In en, this message translates to:
  /// **'Add a round'**
  String get addRound;

  /// No description provided for @enterPlacementKills.
  ///
  /// In en, this message translates to:
  /// **'Enter a placement and a kill count (0 or more) for \"{name}\".'**
  String enterPlacementKills(String name);

  /// No description provided for @placementHelp.
  ///
  /// In en, this message translates to:
  /// **'Placement 1 to {n} (no repeats). Each kill = {k} points.'**
  String placementHelp(int n, int k);

  /// No description provided for @confirmRound.
  ///
  /// In en, this message translates to:
  /// **'Confirm round'**
  String get confirmRound;

  /// No description provided for @bracketLater.
  ///
  /// In en, this message translates to:
  /// **'The bracket appears after the group stage is complete.\nOpen Standings and tap \"Generate knockout\".'**
  String get bracketLater;

  /// No description provided for @editParticipant.
  ///
  /// In en, this message translates to:
  /// **'Edit participant'**
  String get editParticipant;

  /// No description provided for @teamClub.
  ///
  /// In en, this message translates to:
  /// **'Team / club'**
  String get teamClub;

  /// No description provided for @logParticipantEdited.
  ///
  /// In en, this message translates to:
  /// **'Participant edited: {old} -> {name}'**
  String logParticipantEdited(String old, String name);

  /// No description provided for @rowScoring.
  ///
  /// In en, this message translates to:
  /// **'Scoring'**
  String get rowScoring;

  /// No description provided for @scoringBr.
  ///
  /// In en, this message translates to:
  /// **'Placement points + kills x {k} ({n} planned rounds)'**
  String scoringBr(int k, int n);

  /// No description provided for @rowStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get rowStructure;

  /// No description provided for @rowOrganizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get rowOrganizer;

  /// No description provided for @rowStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get rowStart;

  /// No description provided for @rowRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get rowRegistration;

  /// No description provided for @untilDate.
  ///
  /// In en, this message translates to:
  /// **'until {date}'**
  String untilDate(String date);

  /// No description provided for @pointsWinLoss.
  ///
  /// In en, this message translates to:
  /// **'Win {w} · Loss {l}'**
  String pointsWinLoss(int w, int l);

  /// No description provided for @pointsWdl.
  ///
  /// In en, this message translates to:
  /// **'W {w} · D {d} · L {l}'**
  String pointsWdl(int w, int d, int l);

  /// No description provided for @rowRanking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get rowRanking;

  /// No description provided for @rowIfLevel.
  ///
  /// In en, this message translates to:
  /// **'If level'**
  String get rowIfLevel;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @participantsTitle.
  ///
  /// In en, this message translates to:
  /// **'Participants ({count})'**
  String participantsTitle(int count);

  /// No description provided for @editSwapPlayers.
  ///
  /// In en, this message translates to:
  /// **'Edit and swap players'**
  String get editSwapPlayers;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get auditLog;

  /// No description provided for @noEventsYet.
  ///
  /// In en, this message translates to:
  /// **'No events yet.'**
  String get noEventsYet;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @roomIdValue.
  ///
  /// In en, this message translates to:
  /// **'Room ID: {id}'**
  String roomIdValue(String id);

  /// No description provided for @passwordValue.
  ///
  /// In en, this message translates to:
  /// **'Password: {pw}'**
  String passwordValue(String pw);

  /// No description provided for @roomStoredNote.
  ///
  /// In en, this message translates to:
  /// **'Stored on this device only. Never shared automatically.'**
  String get roomStoredNote;

  /// No description provided for @stepSelectGame.
  ///
  /// In en, this message translates to:
  /// **'Select game'**
  String get stepSelectGame;

  /// No description provided for @stepTypeMode.
  ///
  /// In en, this message translates to:
  /// **'Type and mode'**
  String get stepTypeMode;

  /// No description provided for @stepSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get stepSetup;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details and confirm'**
  String get stepDetails;

  /// No description provided for @maxReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum reached ({cap}).'**
  String maxReached(int cap);

  /// No description provided for @enterTeamPlayers.
  ///
  /// In en, this message translates to:
  /// **'Enter the players of the team, separated by commas.'**
  String get enterTeamPlayers;

  /// No description provided for @everyTeamExactly.
  ///
  /// In en, this message translates to:
  /// **'Every team needs exactly {size} players.'**
  String everyTeamExactly(int size);

  /// No description provided for @createTournament.
  ///
  /// In en, this message translates to:
  /// **'Create Tournament'**
  String get createTournament;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @selectGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Game'**
  String get selectGameTitle;

  /// No description provided for @selectGameSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the game for your tournament.'**
  String get selectGameSub;

  /// No description provided for @selectTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Tournament Type'**
  String get selectTypeTitle;

  /// No description provided for @selectTypeSub.
  ///
  /// In en, this message translates to:
  /// **'Choose the mode you want to organize in {game}.'**
  String selectTypeSub(String game);

  /// No description provided for @selectModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Mode'**
  String get selectModeTitle;

  /// No description provided for @selectModeSub.
  ///
  /// In en, this message translates to:
  /// **'Pick the format for your {type}.'**
  String selectModeSub(String type);

  /// No description provided for @infoPointsSystem.
  ///
  /// In en, this message translates to:
  /// **'Points system'**
  String get infoPointsSystem;

  /// No description provided for @infoTwoPlayers.
  ///
  /// In en, this message translates to:
  /// **'Two players per match'**
  String get infoTwoPlayers;

  /// No description provided for @infoMin2Teams.
  ///
  /// In en, this message translates to:
  /// **'Minimum: 2 teams'**
  String get infoMin2Teams;

  /// No description provided for @infoMinPlayers.
  ///
  /// In en, this message translates to:
  /// **'Minimum players: {n}'**
  String infoMinPlayers(int n);

  /// No description provided for @infoHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get infoHowItWorks;

  /// No description provided for @infoBrText.
  ///
  /// In en, this message translates to:
  /// **'Total = placement points + 2 points per kill. The last three placements score 0 placement points. {detail}.'**
  String infoBrText(String detail);

  /// No description provided for @infoCs1v1.
  ///
  /// In en, this message translates to:
  /// **'Each match needs two players, both slots filled. Register at least 2 players. A match is won or lost: no goals, no draws.'**
  String get infoCs1v1;

  /// No description provided for @infoCsTeams.
  ///
  /// In en, this message translates to:
  /// **'At least 2 teams are needed. Teams can have different numbers of players (for example 2 against 1), up to {size} per team. A match is won or lost: no goals, no draws.'**
  String infoCsTeams(int size);

  /// No description provided for @infoMinTotal.
  ///
  /// In en, this message translates to:
  /// **'{n} registered players in total are needed to start. The team size ({size}) is a maximum: you do not have to fill every slot.'**
  String infoMinTotal(int n, int size);

  /// No description provided for @info1v1.
  ///
  /// In en, this message translates to:
  /// **'Each match has two players. Results decide the standings.'**
  String get info1v1;

  /// No description provided for @setupSub.
  ///
  /// In en, this message translates to:
  /// **'Registration, format and rules.'**
  String get setupSub;

  /// No description provided for @setupValid.
  ///
  /// In en, this message translates to:
  /// **'Setup is valid. Continue to the last step.'**
  String get setupValid;

  /// No description provided for @toContinue.
  ///
  /// In en, this message translates to:
  /// **'To continue'**
  String get toContinue;

  /// No description provided for @registrationPanel.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registrationPanel;

  /// No description provided for @maxTeams.
  ///
  /// In en, this message translates to:
  /// **'Maximum teams'**
  String get maxTeams;

  /// No description provided for @maxPlayers.
  ///
  /// In en, this message translates to:
  /// **'Maximum players'**
  String get maxPlayers;

  /// No description provided for @limitTeams.
  ///
  /// In en, this message translates to:
  /// **'Limit: up to {max} teams ({detail}).'**
  String limitTeams(int max, String detail);

  /// No description provided for @limitPlayers.
  ///
  /// In en, this message translates to:
  /// **'Limit: up to {max} players ({detail}).'**
  String limitPlayers(int max, String detail);

  /// No description provided for @atLeastPlayersTotal.
  ///
  /// In en, this message translates to:
  /// **'At least {n} players in total. Teams do not have to be full.'**
  String atLeastPlayersTotal(int n);

  /// No description provided for @playersCommaLabel.
  ///
  /// In en, this message translates to:
  /// **'Players (names separated by commas)'**
  String get playersCommaLabel;

  /// No description provided for @playersCommaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ali, Sara'**
  String get playersCommaHint;

  /// No description provided for @exactlyPerTeam.
  ///
  /// In en, this message translates to:
  /// **'Exactly {size} players per team.'**
  String exactlyPerTeam(int size);

  /// No description provided for @oneToPerTeam.
  ///
  /// In en, this message translates to:
  /// **'1 to {size} players per team. Teams do not have to be full.'**
  String oneToPerTeam(int size);

  /// No description provided for @teamsRegistered.
  ///
  /// In en, this message translates to:
  /// **'{count} / {cap} teams · {players} players'**
  String teamsRegistered(int count, int cap, int players);

  /// No description provided for @playersRegistered.
  ///
  /// In en, this message translates to:
  /// **'{count} / {cap} players'**
  String playersRegistered(int count, int cap);

  /// No description provided for @formatPanel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get formatPanel;

  /// No description provided for @tournamentFormat.
  ///
  /// In en, this message translates to:
  /// **'Tournament format'**
  String get tournamentFormat;

  /// No description provided for @numberOfLeagues.
  ///
  /// In en, this message translates to:
  /// **'Number of leagues'**
  String get numberOfLeagues;

  /// No description provided for @groupsPerLeague.
  ///
  /// In en, this message translates to:
  /// **'Groups per league'**
  String get groupsPerLeague;

  /// No description provided for @qualifiersPerGroup.
  ///
  /// In en, this message translates to:
  /// **'Qualifiers per group'**
  String get qualifiersPerGroup;

  /// No description provided for @doubleRoundRobin.
  ///
  /// In en, this message translates to:
  /// **'Double round-robin'**
  String get doubleRoundRobin;

  /// No description provided for @doubleRoundRobinSub.
  ///
  /// In en, this message translates to:
  /// **'Home and away: everyone plays everyone twice'**
  String get doubleRoundRobinSub;

  /// No description provided for @randomDraw.
  ///
  /// In en, this message translates to:
  /// **'Random draw'**
  String get randomDraw;

  /// No description provided for @randomDrawSub.
  ///
  /// In en, this message translates to:
  /// **'Off: participants are placed in the order they were added'**
  String get randomDrawSub;

  /// No description provided for @ifKoLevel.
  ///
  /// In en, this message translates to:
  /// **'If a knockout match ends level'**
  String get ifKoLevel;

  /// No description provided for @pointsAndRanking.
  ///
  /// In en, this message translates to:
  /// **'Points and ranking'**
  String get pointsAndRanking;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @lossLabel.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get lossLabel;

  /// No description provided for @tiebreakerOrder.
  ///
  /// In en, this message translates to:
  /// **'Tie-breaker order'**
  String get tiebreakerOrder;

  /// No description provided for @directMatchFirst.
  ///
  /// In en, this message translates to:
  /// **'Direct match first'**
  String get directMatchFirst;

  /// No description provided for @goalDiffFirst.
  ///
  /// In en, this message translates to:
  /// **'Goal difference first'**
  String get goalDiffFirst;

  /// No description provided for @rulesNoteWinnerOnly.
  ///
  /// In en, this message translates to:
  /// **'The winner of a match takes the win points. Teams level on points are ranked by their direct match, then by name. Locked once the tournament starts.'**
  String get rulesNoteWinnerOnly;

  /// No description provided for @rulesNote.
  ///
  /// In en, this message translates to:
  /// **'These rules are locked once the tournament starts. Teams still level after every criterion are ordered by name.'**
  String get rulesNote;

  /// No description provided for @standingsColumns.
  ///
  /// In en, this message translates to:
  /// **'Standings columns'**
  String get standingsColumns;

  /// No description provided for @columnsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 column selected. Rank and name are always shown.} other{{count} columns selected. Rank and name are always shown.}}'**
  String columnsSelected(int count);

  /// No description provided for @roundsAndScoring.
  ///
  /// In en, this message translates to:
  /// **'Rounds and scoring'**
  String get roundsAndScoring;

  /// No description provided for @plannedRounds.
  ///
  /// In en, this message translates to:
  /// **'Planned rounds'**
  String get plannedRounds;

  /// No description provided for @brFormulaTitle.
  ///
  /// In en, this message translates to:
  /// **'Total = placement points + kills x 2'**
  String get brFormulaTitle;

  /// No description provided for @brFormulaText.
  ///
  /// In en, this message translates to:
  /// **'For duo and squad, the kills of all team members are added together.'**
  String get brFormulaText;

  /// No description provided for @placementPoints.
  ///
  /// In en, this message translates to:
  /// **'Placement points'**
  String get placementPoints;

  /// No description provided for @registerTeamsFirst.
  ///
  /// In en, this message translates to:
  /// **'Register at least {n} teams to configure the table (it has one row per team).'**
  String registerTeamsFirst(int n);

  /// No description provided for @registerPlayersFirst.
  ///
  /// In en, this message translates to:
  /// **'Register at least {n} players to configure the table (it has one row per player).'**
  String registerPlayersFirst(int n);

  /// No description provided for @lastPlacementsZero.
  ///
  /// In en, this message translates to:
  /// **'The last {n} placements always score 0 placement points.'**
  String lastPlacementsZero(int n);

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @tournamentSettings.
  ///
  /// In en, this message translates to:
  /// **'Tournament Settings'**
  String get tournamentSettings;

  /// No description provided for @tournamentSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Set the final details of your tournament.'**
  String get tournamentSettingsSub;

  /// No description provided for @tournamentNameReq.
  ///
  /// In en, this message translates to:
  /// **'Tournament name *'**
  String get tournamentNameReq;

  /// No description provided for @tournamentNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SPHERA Cup'**
  String get tournamentNameHint;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @startDateTime.
  ///
  /// In en, this message translates to:
  /// **'Start date and time'**
  String get startDateTime;

  /// No description provided for @registrationDeadline.
  ///
  /// In en, this message translates to:
  /// **'Registration deadline'**
  String get registrationDeadline;

  /// No description provided for @rulesAndPenalties.
  ///
  /// In en, this message translates to:
  /// **'Rules and penalties'**
  String get rulesAndPenalties;

  /// No description provided for @roomIdOptional.
  ///
  /// In en, this message translates to:
  /// **'Room ID (optional)'**
  String get roomIdOptional;

  /// No description provided for @roomPasswordOptional.
  ///
  /// In en, this message translates to:
  /// **'Room password (optional)'**
  String get roomPasswordOptional;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @participantsRow.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participantsRow;

  /// No description provided for @participantsSummaryTeams.
  ///
  /// In en, this message translates to:
  /// **'{count} ({players} players) · max {max}'**
  String participantsSummaryTeams(int count, int players, int max);

  /// No description provided for @participantsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} · max {max}'**
  String participantsSummary(int count, int max);

  /// No description provided for @scoringBrShort.
  ///
  /// In en, this message translates to:
  /// **'Placement points + kills x 2'**
  String get scoringBrShort;

  /// No description provided for @columnsRow.
  ///
  /// In en, this message translates to:
  /// **'Columns'**
  String get columnsRow;

  /// No description provided for @readAndConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please read and confirm: the ranking rules lock when the tournament starts.'**
  String get readAndConfirm;

  /// No description provided for @validRounds.
  ///
  /// In en, this message translates to:
  /// **'Everything looks valid. Creating generates the rounds.'**
  String get validRounds;

  /// No description provided for @validFixtures.
  ///
  /// In en, this message translates to:
  /// **'Everything looks valid. Creating generates the fixtures.'**
  String get validFixtures;

  /// No description provided for @stepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total} · {title}'**
  String stepOf(int step, int total, String title);

  /// No description provided for @rankingOrder.
  ///
  /// In en, this message translates to:
  /// **'Ranking order'**
  String get rankingOrder;

  /// No description provided for @teamColumn.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamColumn;

  /// No description provided for @filterAllCount.
  ///
  /// In en, this message translates to:
  /// **'All {count}'**
  String filterAllCount(int count);

  /// No description provided for @filterActiveCount.
  ///
  /// In en, this message translates to:
  /// **'Active {count}'**
  String filterActiveCount(int count);

  /// No description provided for @filterSoldCount.
  ///
  /// In en, this message translates to:
  /// **'Sold {count}'**
  String filterSoldCount(int count);

  /// No description provided for @arenaLoadError.
  ///
  /// In en, this message translates to:
  /// **'Saved tournaments could not be read ({error}).'**
  String arenaLoadError(String error);

  /// No description provided for @ratesServerError.
  ///
  /// In en, this message translates to:
  /// **'Rates server answered {code}.'**
  String ratesServerError(int code);

  /// No description provided for @ratesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Rates are not available right now.'**
  String get ratesUnavailable;

  /// No description provided for @ratesNoInternet.
  ///
  /// In en, this message translates to:
  /// **'Could not update rates. Check your internet connection.'**
  String get ratesNoInternet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
