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
