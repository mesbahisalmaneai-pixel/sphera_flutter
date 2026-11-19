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
