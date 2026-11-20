// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navStats => 'الإحصائيات';

  @override
  String get navOrbit => 'المدار';

  @override
  String get navCards => 'البطاقات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get askSphera => 'اسأل SPHERA';

  @override
  String get settings => 'الإعدادات';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get forSale => 'للبيع';

  @override
  String get addAccount => 'إضافة حساب';

  @override
  String get searchAccount => 'البحث عن حساب';

  @override
  String get manageGames => 'إدارة الألعاب';

  @override
  String get netProfit => 'صافي الربح';

  @override
  String vsLastMonth(String arrow, String pct) {
    return '⁦$arrow $pct%⁩ مقارنة بالشهر الماضي';
  }

  @override
  String thisMonthAmount(String amount) {
    return 'هذا الشهر $amount';
  }

  @override
  String get totalAccounts => 'مجموع الحسابات';

  @override
  String get noneAddedThisMonth => 'لم تتم إضافة أي حساب هذا الشهر';

  @override
  String addedThisMonth(int count) {
    return '⁦+$count⁩ هذا الشهر';
  }

  @override
  String get activeAccounts => 'الحسابات النشطة';

  @override
  String get noAccountsYet => 'لا توجد حسابات بعد';

  @override
  String percentOfTotal(int pct) {
    return '$pct% من المجموع';
  }

  @override
  String get nothingListed => 'لا شيء معروض';

  @override
  String get listedNoPrice => 'معروض، بدون سعر';

  @override
  String get sold => 'المبيعة';

  @override
  String get performance => 'الأداء';

  @override
  String get profitByDateAdded => 'الربح حسب تاريخ الإضافة';

  @override
  String get daily => 'يومي';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get monthly => 'شهري';

  @override
  String accountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب',
      many: '$count حسابًا',
      few: '$count حسابات',
      two: 'حسابان',
      one: 'حساب واحد',
      zero: '0 حساب',
    );
    return '$_temp0';
  }

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لعبة',
      many: '$count لعبة',
      few: '$count ألعاب',
      two: 'لعبتان',
      one: 'لعبة واحدة',
      zero: '0 لعبة',
    );
    return '$_temp0';
  }

  @override
  String weekOf(String date) {
    return 'أسبوع $date';
  }

  @override
  String get noAccountsInPeriod => 'لم تتم إضافة أي حساب في هذه الفترة';

  @override
  String get actionAdded => 'أُضيف';

  @override
  String get actionUpdated => 'عُدّل';

  @override
  String get actionStatusChanged => 'تغيّرت الحالة';

  @override
  String get actionMovedToTrash => 'نُقل إلى المهملات';

  @override
  String get actionRestored => 'استُعيد';

  @override
  String get actionDeleted => 'حُذف';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    return 'منذ $count د';
  }

  @override
  String hoursAgo(int count) {
    return 'منذ $count س';
  }

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count يومًا',
      few: 'منذ $count أيام',
      two: 'منذ يومين',
      one: 'منذ يوم',
    );
    return '$_temp0';
  }

  @override
  String get noActivityYet => 'لا يوجد نشاط بعد.\nستظهر هنا الإجراءات الجديدة.';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get analyticsCenter => 'مركز التحليلات';

  @override
  String get profitCenter => 'مركز الأرباح';

  @override
  String get profitCenterSub =>
      'المبيعات، المصاريف، سعر الشراء والبيع، صافي الربح';

  @override
  String get activityCenter => 'مركز النشاط';

  @override
  String get activityCenterSub => 'سجل النشاط، تصفية حسب التاريخ والنوع';

  @override
  String get performanceCenter => 'مركز الأداء';

  @override
  String get performanceCenterSub => 'يومي، أسبوعي، شهري والأهداف';

  @override
  String get spheraIntelligence => 'SPHERA Intelligence';

  @override
  String get spheraIntelligenceSub => 'تحليل حساباتك بدون إنترنت';

  @override
  String get gradeStatistics => 'إحصائيات الدرجات';

  @override
  String get gradeStatisticsSub => 'برونزي، فضي، ذهبي، بلاتيني، ماسي وممنوع';

  @override
  String get statusStatistics => 'إحصائيات الحالات';

  @override
  String get statusStatisticsSub =>
      'صناديق Google وحسابات الألعاب، كلٌّ على حدة';

  @override
  String get gamesStatistics => 'إحصائيات الألعاب';

  @override
  String get gamesStatisticsSub => 'الربح والعدد والحالة لكل لعبة';

  @override
  String get cards => 'البطاقات';

  @override
  String get googlePlayAccounts => 'حسابات Google Play';

  @override
  String get googlePlayAccountsSub => 'الدرجات وصناديق الألعاب';

  @override
  String get games => 'الألعاب';

  @override
  String get gamesSub => 'مخزون حسابات الألعاب';

  @override
  String get statisticsSub => 'الربح والأعداد والحالات';

  @override
  String get toolsSettings => 'الأدوات والإعدادات';

  @override
  String get toolsSettingsSub => 'النسخ الاحتياطي، المهملات، الملف الشخصي';

  @override
  String get manage => 'إدارة';

  @override
  String get arenaTitle => 'SPHERA TOURNAMENT ARENA';

  @override
  String get arenaSub => 'دوريات، مجموعات وأدوار إقصائية';

  @override
  String get createOne => 'أنشئ بطولة';

  @override
  String tournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بطولة',
      many: '$count بطولة',
      few: '$count بطولات',
      two: 'بطولتان',
      one: 'بطولة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get achievements => 'الإنجازات';

  @override
  String get achievementsSub => 'الشارات والمراحل';

  @override
  String achievementsUnlocked(int done, int total) {
    return '⁦$done / $total⁩ مفتوحة';
  }

  @override
  String get smartTools => 'الأدوات الذكية';

  @override
  String get duplicateScanner => 'كاشف التكرار';

  @override
  String get duplicateScannerSub => 'اعثر على الحسابات المكررة وراجعها بنفسك';

  @override
  String get noDuplicates => 'لا يوجد تكرار';

  @override
  String toReview(int count) {
    return '$count للمراجعة';
  }

  @override
  String get smartOrganizer => 'المنظم الذكي';

  @override
  String get smartOrganizerSub => 'البحث والتصفية والترتيب';

  @override
  String get smartOrganizerSummary => 'حسب اللعبة والحالة والدرجة والتاريخ';

  @override
  String get inventoryVault => 'خزنة المخزون';

  @override
  String get inventoryVaultSub => 'الحسابات المفضلة والنادرة وعالية القيمة';

  @override
  String inVault(int count) {
    return '$count في الخزنة';
  }

  @override
  String get securityCenter => 'مركز الأمان';

  @override
  String get securityCenterSub => 'سلامة البيانات، النسخ الاحتياطي والمزامنة';

  @override
  String get allGood => 'كل شيء على ما يرام';

  @override
  String get language => 'اللغة';

  @override
  String get profileSecurity => 'الملف الشخصي والأمان';

  @override
  String get localMode => 'الوضع المحلي';

  @override
  String get localModeSub =>
      'لم تسجّل الدخول. بياناتك محفوظة على هذا الجهاز فقط. تسجيل الدخول والمزامنة السحابية غير متوفرين بعد.';

  @override
  String get protectionPrivacy => 'الحماية والخصوصية';

  @override
  String get appearance => 'المظهر';

  @override
  String get mode => 'الوضع';

  @override
  String get dark => 'داكن';

  @override
  String get light => 'فاتح';

  @override
  String get auto => 'تلقائي';

  @override
  String get style => 'النمط';

  @override
  String get autoFollowsPhone =>
      'الوضع التلقائي يتبع إعداد الداكن / الفاتح في هاتفك.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get off => 'متوقفة';

  @override
  String get onRemindersOn => 'مفعّلة · التذكيرات مفعّلة';

  @override
  String get onRemindersOff => 'مفعّلة · التذكيرات متوقفة';

  @override
  String get currency => 'العملة';

  @override
  String get data => 'البيانات';

  @override
  String get trash => 'المهملات';

  @override
  String get empty => 'فارغة';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get storedItems => 'العناصر والأصول المحفوظة';

  @override
  String get aboutSphera => 'حول SPHERA';

  @override
  String version(String version) {
    return 'الإصدار $version';
  }

  @override
  String get aboutText =>
      'حسابات Google Play وحسابات الألعاب والأسعار والإحصائيات في مكان واحد.';

  @override
  String get ratesUpdated => 'تم تحديث أسعار الصرف.';

  @override
  String get dhIsBase => 'الدرهم هو العملة الأساسية: تُحفظ المبالغ بالدرهم.';

  @override
  String liveRate(String when) {
    return 'سعر مباشر، حُدّث في $when';
  }

  @override
  String get approximateRate =>
      'سعر تقريبي، ليس مباشرًا بعد. اضغط «تحديث الأسعار» عند الاتصال بالإنترنت.';

  @override
  String get conversionNote =>
      'يُحوَّل كل سعر بهذا المعدل عند العرض، وما تكتبه يُعاد تحويله إلى الدرهم عند الحفظ.';

  @override
  String get updateRates => 'تحديث الأسعار';

  @override
  String get authNeedHelp => 'تحتاج مساعدة؟';

  @override
  String get authHelpBody =>
      'جديد هنا؟ اختر «إنشاء حساب جديد».\n\nمسجّل من قبل على هذا الجهاز؟ اختر «لدي حساب بالفعل».\n\nلا تستطيع الدخول؟ استعمل «لدي مشكلة في تسجيل الدخول وكلمة المرور».';

  @override
  String get gotIt => 'فهمت';

  @override
  String get cancel => 'إلغاء';

  @override
  String get back => 'رجوع';

  @override
  String get help => 'مساعدة';

  @override
  String get authVerifyUnavailableTitle => 'التحقق غير متوفر بعد';

  @override
  String get authVerifyUnavailableBody =>
      'الرموز عبر البريد الإلكتروني أو الرسائل القصيرة تحتاج خدمة عبر الإنترنت غير متصلة بـ SPHERA بعد.\n\nيمكنك بدلًا من ذلك إعادة تعيين تسجيل الدخول على هذا الجهاز وإنشاء واحد جديد. حساباتك وألعابك وإحصائياتك تبقى محفوظة.\n\nتسجيل الدخول هذا يحمي فقط الوصول العابر إلى التطبيق على هذا الجهاز.';

  @override
  String get authResetLogin => 'إعادة تعيين الدخول';

  @override
  String get authOops => 'عذرًا!';

  @override
  String get authHintEmailOrPhone => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get authHintCode => 'رمز التحقق';

  @override
  String get authLogin => 'دخول';

  @override
  String get authEnterUserAndPassword => 'أدخل اسم المستخدم وكلمة المرور.';

  @override
  String get authWelcomeTitle => 'أهلًا بك!';

  @override
  String get authHintUsername => 'اسم المستخدم';

  @override
  String get authHintPassword => 'كلمة المرور';

  @override
  String get authForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get authProfilePhotoOptional => 'صورة الملف الشخصي (اختيارية)';

  @override
  String get authHintChooseUsername => 'اختر اسم مستخدم';

  @override
  String get authHintCreatePassword => 'أنشئ كلمة مرور';

  @override
  String get authHintConfirmPassword => 'أكّد كلمة المرور';

  @override
  String get authConfirmInfo => 'أؤكد أن معلوماتي صحيحة';

  @override
  String get authCreateAccount => 'إنشاء الحساب';

  @override
  String get authYourAge => 'عمرك';

  @override
  String get authHelloTitle => 'مرحبًا!';

  @override
  String get authCreateNewAccount => 'إنشاء حساب جديد';

  @override
  String get authHaveAccount => 'لدي حساب بالفعل';

  @override
  String get authLoginProblem => 'لدي مشكلة في تسجيل الدخول وكلمة المرور';

  @override
  String get valEnterIdentifier => 'أدخل بريدك الإلكتروني أو رقم هاتفك';

  @override
  String get valInvalidIdentifier =>
      'أدخل بريدًا إلكترونيًا أو رقم هاتف صالحًا';

  @override
  String get valChooseUsername => 'اختر اسم مستخدم';

  @override
  String get valUsernameRule => 'من 3 إلى 20 حرفًا: حروف أو أرقام أو _ أو .';

  @override
  String get valCreatePassword => 'أنشئ كلمة مرور';

  @override
  String get valPasswordLength => '8 أحرف على الأقل';

  @override
  String get valPasswordMix => 'استعمل حروفًا وأرقامًا معًا';

  @override
  String get valConfirmPassword => 'أكّد كلمة المرور';

  @override
  String get valPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String valMinAge(int age) {
    return 'SPHERA مخصص لمن عمرهم $age سنة فأكثر';
  }

  @override
  String get valInvalidAge => 'أدخل عمرًا صالحًا';

  @override
  String get authErrAccountExists =>
      'يوجد حساب بالفعل على هذا الجهاز. سجّل الدخول بدلًا من ذلك.';

  @override
  String get authErrWrongCredentials =>
      'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get authNoCode => 'لم أتلقَّ رمز التحقق';

  @override
  String get boxEmpty => 'فارغ';

  @override
  String get boxDone => 'تم';

  @override
  String get boxNotYet => 'ليس بعد';

  @override
  String get boxComing => 'قريبًا';

  @override
  String get gradeBronze => 'برونزي';

  @override
  String get gradeSilver => 'فضي';

  @override
  String get gradeGold => 'ذهبي';

  @override
  String get gradePlatinum => 'بلاتيني';

  @override
  String get gradeDiamond => 'ماسي';

  @override
  String get gradeInterdit => 'ممنوع';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusSold => 'مُباع';

  @override
  String get statusForSale => 'للبيع';

  @override
  String get done => 'تم';

  @override
  String couldNotSave(String error) {
    return 'تعذّر الحفظ: $error';
  }

  @override
  String errDuplicateEmail(String email) {
    return 'يوجد بالفعل حساب Google بالبريد $email.';
  }

  @override
  String errDuplicateGame(String name) {
    return 'توجد بالفعل لعبة باسم «$name».';
  }

  @override
  String get editGoogleAccount => 'تعديل حساب Google';

  @override
  String get addGoogleAccount => 'إضافة حساب Google';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا';

  @override
  String get grade => 'الدرجة';

  @override
  String get gameBoxes => 'صناديق الألعاب';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get addAccountShort => 'إضافة الحساب';

  @override
  String movedToTrash(String name) {
    return 'نُقل $name إلى المهملات';
  }

  @override
  String get undo => 'تراجع';

  @override
  String get manageGamesLower => 'إدارة الألعاب';

  @override
  String couldNotLoadAccounts(String error) {
    return 'تعذّر تحميل الحسابات: $error';
  }

  @override
  String get searchByEmail => 'ابحث بالبريد الإلكتروني';

  @override
  String get allGrades => 'كل الدرجات';

  @override
  String get anyStatus => 'كل الحالات';

  @override
  String boxesSet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صندوق محدد',
      many: '$count صندوقًا محددًا',
      few: '$count صناديق محددة',
      two: 'صندوقان محددان',
      one: 'صندوق واحد محدد',
      zero: 'لا صناديق محددة',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'تعديل';

  @override
  String get moveToTrash => 'نقل إلى المهملات';

  @override
  String get setBoxes => 'تحديد الصناديق';

  @override
  String get box => 'صندوق';

  @override
  String get noAccountMatches => 'لا يوجد حساب يطابق عوامل التصفية';

  @override
  String get noGoogleAccountsYet => 'لا توجد حسابات Google بعد';

  @override
  String get addFirstAccount => 'أضف حسابك الأول';

  @override
  String get enterGameName => 'أدخل اسم لعبة';

  @override
  String couldNotAddGame(String error) {
    return 'تعذّرت إضافة اللعبة: $error';
  }

  @override
  String removeGameTitle(String name) {
    return 'إزالة $name؟';
  }

  @override
  String removeGameWithAccounts(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب ألعاب',
      many: '$count حساب ألعاب',
      few: '$count حسابات ألعاب',
      two: 'حسابا ألعاب',
      one: 'حساب ألعاب واحد',
    );
    return 'لدى $name $_temp0. ستبقى محفوظة، لكن اللعبة وصناديقها ستُخفى من القوائم.';
  }

  @override
  String get removeGameNoAccounts => 'ستُخفى اللعبة وصناديقها من القوائم.';

  @override
  String get remove => 'إزالة';

  @override
  String get newGameName => 'اسم اللعبة الجديدة';

  @override
  String get add => 'إضافة';

  @override
  String get removeGame => 'إزالة اللعبة';

  @override
  String get accountNoLongerAvailable => 'لم يعد هذا الحساب متاحًا';

  @override
  String couldNotSetPhoto(String error) {
    return 'تعذّر تعيين الصورة: $error';
  }

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get game => 'اللعبة';

  @override
  String get removedGame => 'لعبة محذوفة';

  @override
  String get idCompte => 'معرّف الحساب';

  @override
  String get purchasePrice => 'سعر الشراء';

  @override
  String get salePrice => 'سعر البيع';

  @override
  String get profit => 'الربح';

  @override
  String get loss => 'الخسارة';

  @override
  String get enterNumber => 'أدخل رقمًا';

  @override
  String get mustBeZeroOrMore => 'يجب أن يكون 0 أو أكثر';

  @override
  String get chooseGame => 'اختر لعبة';

  @override
  String get editAccount => 'تعديل الحساب';

  @override
  String get idCompteRequired => 'معرّف الحساب مطلوب';

  @override
  String get accountName => 'اسم الحساب';

  @override
  String get nameRequired => 'الاسم مطلوب';

  @override
  String get status => 'الحالة';

  @override
  String get notesOptional => 'ملاحظات (اختيارية)';

  @override
  String get noAccountsYetShort => 'لا توجد حسابات بعد';

  @override
  String get gameName => 'اسم اللعبة';

  @override
  String get save => 'حفظ';

  @override
  String get addGame => 'إضافة لعبة';

  @override
  String get renameGame => 'إعادة تسمية اللعبة';

  @override
  String couldNotSetImage(String error) {
    return 'تعذّر تعيين الصورة: $error';
  }

  @override
  String removeGameKeepsAccounts(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب',
      many: '$count حسابًا',
      few: '$count حسابات',
      two: 'حسابان',
      one: 'حساب واحد',
    );
    return 'لدى $name $_temp0. ستبقى محفوظة، لكن اللعبة ستُخفى من القوائم.';
  }

  @override
  String get removeGameHidden => 'ستُخفى اللعبة من القوائم.';

  @override
  String get noGamesYet => 'لا توجد ألعاب بعد';

  @override
  String get rename => 'إعادة التسمية';

  @override
  String get changeGameImage => 'تغيير صورة اللعبة';

  @override
  String get changeAccountPhoto => 'تغيير صورة الحسابات';

  @override
  String get resetImages => 'إعادة تعيين الصور';

  @override
  String get today => 'اليوم';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      many: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String accountsForSaleList(int count) {
    return 'الحسابات المعروضة للبيع ($count):';
  }

  @override
  String get listCopied => 'تم نسخ القائمة (بدون أسعار)';

  @override
  String forSaleCount(int count) {
    return 'للبيع ($count)';
  }

  @override
  String get copyListNoPrices => 'نسخ القائمة بدون أسعار';

  @override
  String get nothingForSale =>
      'لا يوجد شيء معروض للبيع.\nافتح حسابًا واختر «عرض للبيع».';

  @override
  String get listed => 'معروض';

  @override
  String gamesWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'لعبة',
      few: 'ألعاب',
      two: 'لعبتان',
      one: 'لعبة',
    );
    return '$_temp0';
  }

  @override
  String get longestWait => 'أطول انتظار';

  @override
  String get searchNameIdGame => 'ابحث بالاسم أو المعرّف أو اللعبة';

  @override
  String allCount(int count) {
    return 'الكل ($count)';
  }

  @override
  String get noMatch => 'لا توجد نتائج';

  @override
  String waitingFor(String time) {
    return 'في الانتظار منذ $time';
  }

  @override
  String get searchAccounts => 'البحث في الحسابات';

  @override
  String get clear => 'مسح';

  @override
  String noAccountFoundFor(String query) {
    return 'لم يُعثر على حساب لـ «$query»';
  }

  @override
  String marginPct(String pct) {
    return 'هامش $pct%';
  }

  @override
  String get salesSalePrice => 'المبيعات (سعر البيع)';

  @override
  String get expensesPurchasePrice => 'المصاريف (سعر الشراء)';

  @override
  String get perGame => 'حسب اللعبة';

  @override
  String salesAndExpenses(String sales, String expenses) {
    return 'المبيعات $sales · المصاريف $expenses';
  }

  @override
  String get topProfit => 'أعلى الأرباح';

  @override
  String get losses => 'الخسائر';

  @override
  String get todayCap => 'اليوم';

  @override
  String get typeGoogle => 'Google';

  @override
  String get typeGaming => 'الألعاب';

  @override
  String get typeGames => 'قائمة الألعاب';

  @override
  String get typeSystem => 'النظام';

  @override
  String get last7Days => '7 أيام';

  @override
  String get last30Days => '30 يومًا';

  @override
  String get allTypes => 'كل الأنواع';

  @override
  String get noActivityFromNow =>
      'لا يوجد نشاط بعد.\nستظهر هنا الإجراءات الجديدة من الآن فصاعدًا.';

  @override
  String perfAddedVsPrev(int added, int prev, String prevLabel) {
    return '$added مضافة · $prev $prevLabel';
  }

  @override
  String perfSameProfit(String prevLabel) {
    return 'نفس الربح ($prevLabel)';
  }

  @override
  String perfVsPrev(String amount, String prevLabel) {
    return '$amount مقارنة مع $prevLabel';
  }

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get prevYesterday => 'أمس';

  @override
  String get prevLastWeek => 'الأسبوع الماضي';

  @override
  String get prevLastMonth => 'الشهر الماضي';

  @override
  String get goalReached => 'تحقق';

  @override
  String get goalOnTrack => 'على المسار';

  @override
  String get goalBehind => 'متأخر';

  @override
  String goalProgress(String current, String target, String pct) {
    return '$current من $target · $pct%';
  }

  @override
  String get performanceCenterTitle => 'مركز الأداء';

  @override
  String get monthlyGoals => 'الأهداف الشهرية';

  @override
  String get setGoals => 'تحديد الأهداف';

  @override
  String get noGoalsYet =>
      'لا توجد أهداف بعد. حدّد هدفًا شهريًا للربح أو لعدد الحسابات لتتابع وتيرتك.';

  @override
  String get accountsAdded => 'الحسابات المضافة';

  @override
  String get highlights => 'أبرز النتائج';

  @override
  String get addStreak => 'سلسلة الإضافة';

  @override
  String get addStreakSub => 'أيام متتالية بحساب جديد';

  @override
  String get bestDay30 => 'أفضل يوم (30 يومًا)';

  @override
  String get bestWeek12 => 'أفضل أسبوع (12 أسبوعًا)';

  @override
  String get bestMonth12 => 'أفضل شهر (12 شهرًا)';

  @override
  String get perfNote =>
      'تُحتسب الحسابات في الفترة التي أُضيفت فيها. الحسابات المعروضة للبيع ليس لها ربح بعد.';

  @override
  String profitGoalCurrency(String currency) {
    return 'هدف الربح ($currency)';
  }

  @override
  String get emptyNoGoal => 'فارغ = بدون هدف';

  @override
  String get accountsToAdd => 'حسابات للإضافة';

  @override
  String googleAccountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب Google',
      many: '$count حساب Google',
      few: '$count حسابات Google',
      two: 'حسابا Google',
      one: 'حساب Google واحد',
      zero: 'لا حسابات Google',
    );
    return '$_temp0';
  }

  @override
  String get googlePlayBoxes => 'صناديق Google Play';

  @override
  String get gamingAccounts => 'حسابات الألعاب';

  @override
  String get totalProfitLoss => 'إجمالي الربح / الخسارة';

  @override
  String get pricePerGame => 'السعر حسب اللعبة';

  @override
  String accountsIncluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب مشمول',
      many: '$count حسابًا مشمولًا',
      few: '$count حسابات مشمولة',
      two: 'حسابان مشمولان',
      one: 'حساب واحد مشمول',
      zero: 'لا حسابات مشمولة',
    );
    return '$_temp0';
  }

  @override
  String get accountsPerGame => 'عدد الحسابات حسب اللعبة';

  @override
  String get statusPerGame => 'حالة الحسابات حسب اللعبة';

  @override
  String get noAccountsInGrade => 'لا توجد حسابات في هذه الدرجة';

  @override
  String get noAccounts => 'لا توجد حسابات';

  @override
  String get nothingHere => 'لا شيء هنا';

  @override
  String get howMatchingWorks => 'كيف تعمل المطابقة';

  @override
  String get matchingRules =>
      'حسابات Google: نفس البريد الإلكتروني (مع تجاهل حالة الأحرف والمسافات، والنقاط و«+tags» في Gmail).\nحسابات الألعاب: نفس معرّف الحساب داخل نفس اللعبة.\nالمطابقة برقم الهاتف غير متوفرة: أرقام الهواتف غير محفوظة بعد.';

  @override
  String get nothingMergedAutomatically =>
      'لا يُحذف أو يُدمج أي شيء تلقائيًا. أنت من يراجع كل حساب بنفسه.';

  @override
  String get noDuplicatesFound => 'لم يُعثر على تكرار';

  @override
  String get googleAccountsSection => 'حسابات Google';

  @override
  String get gameAccountsSection => 'حسابات الألعاب';

  @override
  String showDismissedAgain(int count) {
    return 'إظهار $count مستبعدة مجددًا';
  }

  @override
  String get markedNotDuplicates => 'تم التعليم كغير مكررة';

  @override
  String similarAccounts(int count) {
    return '$count حسابات متشابهة';
  }

  @override
  String addedOn(String date) {
    return 'أُضيف في $date';
  }

  @override
  String get openToReview => 'افتح للمراجعة';

  @override
  String get notDuplicates => 'ليست مكررة';

  @override
  String accountsWithId(int count, String id) {
    return '$count حسابات بالمعرّف $id';
  }

  @override
  String get unknownGame => 'لعبة غير معروفة';

  @override
  String buySell(String buy, String sell) {
    return 'شراء $buy ← بيع $sell';
  }

  @override
  String get openGame => 'فتح اللعبة';

  @override
  String saleAmount(String amount) {
    return 'البيع $amount';
  }

  @override
  String get addToVault => 'إضافة إلى الخزنة';

  @override
  String get all => 'الكل';

  @override
  String get vaultEmpty => 'خزنتك فارغة';

  @override
  String get nothingWithTag => 'لا شيء بهذه العلامة';

  @override
  String get vaultHint =>
      'اضغط «إضافة إلى الخزنة» لتمييز الحسابات المفضلة أو النادرة أو عالية القيمة.';

  @override
  String get search => 'بحث';

  @override
  String get highestSaleFirst => 'أعلى سعر بيع أولًا';

  @override
  String get noAccount => 'لا يوجد حساب';

  @override
  String get tagFavorite => 'مفضل';

  @override
  String get tagRare => 'نادر';

  @override
  String get tagHighValue => 'قيمة عالية';

  @override
  String get everythingGood => 'كل شيء يبدو جيدًا';

  @override
  String itemsToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر للمراجعة',
      many: '$count عنصرًا للمراجعة',
      few: '$count عناصر للمراجعة',
      two: 'عنصران للمراجعة',
      one: 'عنصر واحد للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String get basedOnDeviceData =>
      'استنادًا إلى البيانات المحفوظة على هذا الجهاز.';

  @override
  String get dataHealth => 'سلامة البيانات';

  @override
  String get duplicateAccounts => 'الحسابات المكررة';

  @override
  String get noneFound => 'لا يوجد';

  @override
  String groupsToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مجموعة للمراجعة',
      many: '$count مجموعة للمراجعة',
      few: '$count مجموعات للمراجعة',
      two: 'مجموعتان للمراجعة',
      one: 'مجموعة واحدة للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String get duplicateGameIds => 'معرّفات حسابات ألعاب مكررة';

  @override
  String get accountsWithoutId => 'حسابات ألعاب بدون معرّف';

  @override
  String get allHaveId => 'لكلها معرّف حساب';

  @override
  String accountsMissingId(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب بدون معرّف',
      many: '$count حسابًا بدون معرّف',
      few: '$count حسابات بدون معرّف',
      two: 'حسابان بدون معرّف',
      one: 'حساب واحد بدون معرّف',
    );
    return '$_temp0';
  }

  @override
  String get invalidEmails => 'بريد إلكتروني غير صالح';

  @override
  String get allEmailsValid => 'كل عناوين البريد تبدو صالحة';

  @override
  String accountsWrongEmail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب ببريد غير صحيح',
      many: '$count حسابًا ببريد غير صحيح',
      few: '$count حسابات ببريد غير صحيح',
      two: 'حسابان ببريد غير صحيح',
      one: 'حساب واحد ببريد غير صحيح',
    );
    return '$_temp0';
  }

  @override
  String get accountsNoBoxes => 'حسابات بدون صناديق محددة';

  @override
  String justInformational(int count) {
    return '$count (للعلم فقط)';
  }

  @override
  String get itemsInTrash => 'العناصر في المهملات';

  @override
  String trashKept(int count) {
    return '$count محفوظة، لا يُحذف شيء تلقائيًا';
  }

  @override
  String get protection => 'الحماية';

  @override
  String get appLock => 'قفل التطبيق';

  @override
  String get notEnabledYet => 'غير مفعّل بعد';

  @override
  String get localStorage => 'التخزين المحلي';

  @override
  String get dataStaysOnDevice => 'بياناتك تبقى على هذا الجهاز';

  @override
  String get backup => 'النسخ الاحتياطي';

  @override
  String get noBackupYet =>
      'لا توجد نسخة احتياطية. النسخ الاحتياطي غير متوفر في هذا الإصدار.';

  @override
  String get syncStatus => 'حالة المزامنة';

  @override
  String get cloudSync => 'المزامنة السحابية';

  @override
  String get localOnly => 'محلي فقط. المزامنة غير متصلة بعد.';

  @override
  String get safetyRules => 'قواعد الأمان';

  @override
  String get noAutoDeletion => 'لا حذف تلقائي';

  @override
  String get nothingDeletedWithoutYou => 'لا يُحذف شيء دون موافقتك';

  @override
  String get noAutoMerging => 'لا دمج تلقائي';

  @override
  String get neverMerge => 'الفحص والتنظيم لا يدمجان الحسابات أبدًا';

  @override
  String get manualReviewFirst => 'المراجعة اليدوية أولًا';

  @override
  String get changesByYou => 'كل تغيير تقوم به أنت بعد المراجعة';

  @override
  String get sortRecentActivity => 'النشاط الأحدث';

  @override
  String get sortOldestActivity => 'النشاط الأقدم';

  @override
  String get sortNewestAdded => 'الأحدث إضافة';

  @override
  String get sortOldestAdded => 'الأقدم إضافة';

  @override
  String get sortEmailAz => 'البريد A–Z';

  @override
  String get sortEmailZa => 'البريد Z–A';

  @override
  String get sortGrade => 'الدرجة';

  @override
  String get sortNewest => 'الأحدث';

  @override
  String get sortOldest => 'الأقدم';

  @override
  String get sortSaleHigh => 'أعلى سعر بيع';

  @override
  String get sortSaleLow => 'أدنى سعر بيع';

  @override
  String get sortBuyHigh => 'أعلى سعر شراء';

  @override
  String get sortNameAz => 'الاسم A–Z';

  @override
  String get sort => 'ترتيب';

  @override
  String get searchByNameOrId => 'ابحث بالاسم أو معرّف الحساب';

  @override
  String get allGames => 'كل الألعاب';

  @override
  String shownOfTotal(int shown, int total) {
    return '$shown من $total حساب';
  }

  @override
  String sortedBy(String sort) {
    return 'الترتيب: $sort';
  }

  @override
  String get noAccountMatchesShort => 'لا يوجد حساب مطابق';

  @override
  String get noActivity => 'لا نشاط';

  @override
  String get emptyTrashTitle => 'إفراغ المهملات؟';

  @override
  String emptyTrashBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سيُحذف $count عنصرًا نهائيًا. لا يمكن التراجع عن ذلك.',
      few: 'ستُحذف $count عناصر نهائيًا. لا يمكن التراجع عن ذلك.',
      two: 'سيُحذف العنصران نهائيًا. لا يمكن التراجع عن ذلك.',
      one: 'سيُحذف عنصر واحد نهائيًا. لا يمكن التراجع عن ذلك.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'حذف الكل';

  @override
  String get emptyAction => 'إفراغ';

  @override
  String googleTabCount(int count) {
    return 'Google ($count)';
  }

  @override
  String gamesTabCount(int count) {
    return 'الألعاب ($count)';
  }

  @override
  String googleAccountDeleted(String grade, String when) {
    return 'حساب Google · $grade\nحُذف في $when';
  }

  @override
  String deletedWhen(String when) {
    return 'حُذف في $when';
  }

  @override
  String get removedSuffix => ' (محذوفة)';

  @override
  String get restore => 'استعادة';

  @override
  String get deletePermanently => 'حذف نهائي';

  @override
  String get deletePermanentlyTitle => 'حذف نهائي؟';

  @override
  String deletedForGood(String name) {
    return 'سيُحذف $name نهائيًا. لا يمكن التراجع عن ذلك.';
  }

  @override
  String get delete => 'حذف';

  @override
  String get trashIsEmpty => 'المهملات فارغة';

  @override
  String get phoneNotifsMobileOnly =>
      'إشعارات الهاتف تعمل على Android وiOS فقط.';

  @override
  String get notifsBlocked =>
      'الإشعارات محظورة لـ SPHERA. اسمح بها من إعدادات هاتفك ثم أعد المحاولة.';

  @override
  String get notifsSub => 'التحذيرات والتذكيرات في SPHERA';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get remindersSub => 'عروض بيع قديمة، صناديق «قريبًا»، أهداف متأخرة';

  @override
  String get alertsNote =>
      'تظهر التنبيهات دائمًا في مركز الإشعارات (أيقونة الجرس) مع عدّاد أحمر.';

  @override
  String get phoneNotifications => 'إشعارات الهاتف';

  @override
  String get phoneNotificationsSub =>
      'عرض التنبيهات الجديدة على هاتفك عند مغادرة التطبيق';

  @override
  String get dailySummary => 'الملخص اليومي';

  @override
  String get dailySummarySub => 'التنبيهات وصافي الربح والحسابات، مرة في اليوم';

  @override
  String get summaryTime => 'وقت الملخص';

  @override
  String get sendTestNotification => 'إرسال إشعار تجريبي';

  @override
  String get phoneNotifsNote =>
      'تُنشأ إشعارات الهاتف على هذا الجهاز دون حساب أو إنترنت. قد يصل الملخص اليومي متأخرًا ببضع دقائق لتوفير البطارية. بعض الهواتف (Xiaomi وHuawei...) تحظر الإشعارات في الخلفية ما لم تسمح لـ SPHERA في إعدادات البطارية.';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notifsOff => 'الإشعارات متوقفة';

  @override
  String get turnOnInSettings => 'فعّلها من إعدادات الإشعارات.';

  @override
  String get allClear => 'لا شيء يستدعي الانتباه';

  @override
  String get noWarningsNow => 'لا توجد تحذيرات أو تذكيرات الآن.';

  @override
  String get remindersMuted => 'التذكيرات مكتومة في إعدادات الإشعارات.';

  @override
  String notificationsNew(int count) {
    return 'الإشعارات ($count جديدة)';
  }

  @override
  String get chooseFromGallery => 'اختيار من المعرض';

  @override
  String get removePhoto => 'إزالة الصورة';

  @override
  String get logOutTitle => 'تسجيل الخروج؟';

  @override
  String get logOutBody =>
      'ستحتاج إلى تسجيل الدخول مجددًا. ملفك الشخصي وحساباتك وألعابك وإحصائياتك تبقى على هذا الجهاز.';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get spheraUser => 'مستخدم SPHERA';

  @override
  String rankPts(String rank, int points) {
    return '$rank · ⁦$points⁩ نقطة';
  }

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get activitySummary => 'ملخص النشاط';

  @override
  String get googleAccountsLabel => 'حسابات Google';

  @override
  String get gameAccountsLabel => 'حسابات الألعاب';

  @override
  String get profitLoss => 'الربح / الخسارة';

  @override
  String get rank => 'الرتبة';

  @override
  String rankName(String rank) {
    return 'الرتبة: $rank';
  }

  @override
  String rankPoints(int points) {
    return '⁦$points⁩ نقطة رتبة';
  }

  @override
  String get topRankReached => 'بلغت أعلى رتبة';

  @override
  String ptsToRank(int points, String rank) {
    return '⁦$points⁩ نقطة للوصول إلى $rank';
  }

  @override
  String unlockedOfTotal(int done, int total) {
    return '⁦$done / $total⁩ مفتوحة';
  }

  @override
  String get allAchievementsUnlocked => 'تم فتح كل الإنجازات.';

  @override
  String fraction(int a, int b) {
    return '⁦$a / $b⁩';
  }

  @override
  String get session => 'الجلسة';

  @override
  String get currentSession => 'الجلسة الحالية';

  @override
  String startedAt(String time) {
    return 'بدأت في $time';
  }

  @override
  String get dataOnDeviceOnly => 'بياناتك محفوظة على هذا الجهاز فقط.';

  @override
  String get name => 'الاسم';

  @override
  String get profilePhotosPhoneOnly =>
      'صور الملف الشخصي تعمل في تطبيق الهاتف، وليس في المتصفح.';

  @override
  String achievementPoints(int earned, int total) {
    return '⁦$earned / $total⁩ نقطة إنجاز';
  }

  @override
  String get achievementPointsNote =>
      'نقاط الإنجازات منفصلة عن نقاط الرتبة وعن درجات Google Play.';

  @override
  String get unlocked => 'مفتوحة';

  @override
  String get inProgress => 'قيد التقدم';

  @override
  String get locked => 'مقفلة';

  @override
  String get nothingHereYet => 'لا شيء هنا بعد';

  @override
  String get achievementDatesNote =>
      'تُظهر التواريخ متى رُصد الإنجاز لأول مرة على هذا الجهاز. تُحتسب مبالغ الربح بالدرهم.';

  @override
  String unlockCondition(String condition) {
    return 'للفتح: $condition';
  }

  @override
  String unlockedOn(String date) {
    return 'فُتح في $date';
  }

  @override
  String plusPts(int points) {
    return '⁦+$points⁩ نقطة';
  }

  @override
  String progressPct(int a, int b, int pct) {
    return '⁦$a / $b⁩  ·  $pct%';
  }

  @override
  String get catAccounts => 'الحسابات';

  @override
  String get catGames => 'الألعاب';

  @override
  String get catSales => 'المبيعات';

  @override
  String get catProfits => 'الأرباح';

  @override
  String get catOrganization => 'التنظيم';

  @override
  String get achAcc1 => 'الحساب الأول';

  @override
  String get achAcc1Desc => 'أضف أول حساب Google لك.';

  @override
  String get achAcc10 => 'جامع';

  @override
  String get achAcc10Desc => 'امتلك 10 حسابات Google.';

  @override
  String get achAcc25 => 'مجموعة كبيرة';

  @override
  String get achAcc25Desc => 'امتلك 25 حساب Google.';

  @override
  String get achGacc10 => 'حسابات الألعاب ×10';

  @override
  String get achGacc10Desc => 'امتلك 10 حسابات ألعاب.';

  @override
  String get achGacc50 => 'حسابات الألعاب ×50';

  @override
  String get achGacc50Desc => 'امتلك 50 حساب ألعاب.';

  @override
  String get achGacc100 => 'حسابات الألعاب ×100';

  @override
  String get achGacc100Desc => 'امتلك 100 حساب ألعاب.';

  @override
  String get achGame1 => 'اللعبة الأولى';

  @override
  String get achGame1Desc => 'أضف لعبتك الأولى.';

  @override
  String get achGame5 => 'رف الألعاب';

  @override
  String get achGame5Desc => 'امتلك 5 ألعاب.';

  @override
  String get achGame10 => 'مكتبة الألعاب';

  @override
  String get achGame10Desc => 'امتلك 10 ألعاب.';

  @override
  String get achSell1 => 'أول عملية بيع';

  @override
  String get achSell1Desc => 'علّم أول حساب لك كمُباع.';

  @override
  String get achSell10 => 'بائع';

  @override
  String get achSell10Desc => 'امتلك 10 حسابات معلّمة كمُباعة.';

  @override
  String get achSell50 => 'بائع كبير';

  @override
  String get achSell50Desc => 'امتلك 50 حسابًا معلّمًا كمُباع.';

  @override
  String get achProfit1 => 'في ربح';

  @override
  String get achProfit1Desc => 'حقّق ربحًا إجماليًا موجبًا.';

  @override
  String get achProfit1k => 'ربح ⁦1,000 DH⁩';

  @override
  String get achProfit1kDesc => 'حقّق ربحًا إجماليًا قدره ⁦1,000 DH⁩.';

  @override
  String get achProfit10k => 'ربح ⁦10,000 DH⁩';

  @override
  String get achProfit10kDesc => 'حقّق ربحًا إجماليًا قدره ⁦10,000 DH⁩.';

  @override
  String get achProfitGames3 => 'ألعاب رابحة';

  @override
  String get achProfitGames3Desc => 'امتلك 3 ألعاب بربح موجب.';

  @override
  String get achBoxes10 => 'منظّم';

  @override
  String get achBoxes10Desc => 'حدّد 10 صناديق ألعاب (غير فارغة).';

  @override
  String get achBoxes50 => 'منظّم جدًا';

  @override
  String get achBoxes50Desc => 'حدّد 50 صندوق ألعاب (غير فارغ).';

  @override
  String get achFull => 'تغطية كاملة';

  @override
  String get achFullDesc =>
      'امتلك حسابًا واحدًا على الأقل في كل لعبة (3 ألعاب على الأقل).';

  @override
  String get askSpheraAnything => 'اسأل SPHERA عن أي شيء';

  @override
  String get aiModeOnHint =>
      'وضع الذكاء الاصطناعي مفعّل: يجيب Claude اعتمادًا على ملخص لأرقامك.';

  @override
  String get offlineHint =>
      'ربحك وألعابك وحساباتك ودرجاتك وأهدافك والمشاكل، أو طريقة استعمال أي شاشة. يعمل دون إنترنت بالإنجليزية أو الفرنسية أو العربية.';

  @override
  String get askQuestionHint => 'اطرح سؤالًا…';

  @override
  String get send => 'إرسال';

  @override
  String get thinking => 'جارٍ التفكير…';

  @override
  String get sourceOffline => 'دون إنترنت';

  @override
  String get sourceNotice => 'تنبيه';

  @override
  String get aiMode => 'وضع الذكاء الاصطناعي';

  @override
  String get aiModeExplain =>
      'دون إنترنت، يجيب المساعد من بياناتك ودليل التطبيق. مع وضع الذكاء الاصطناعي، يجيب Claude (من Anthropic) عن أي سؤال وبأي لغة.';

  @override
  String get useClaudeAi => 'استعمال Claude';

  @override
  String get apiKeySaved => 'مفتاح API محفوظ على هذا الهاتف';

  @override
  String get addApiKeyFirst => 'أضف مفتاح API أولًا';

  @override
  String get replaceApiKey => 'استبدال مفتاح API';

  @override
  String get anthropicApiKey => 'مفتاح API من Anthropic';

  @override
  String get keysStartWith => 'تبدأ المفاتيح بـ sk-ant-';

  @override
  String get hide => 'إخفاء';

  @override
  String get show => 'إظهار';

  @override
  String get saveKey => 'حفظ المفتاح';

  @override
  String get removeKey => 'حذف المفتاح';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get aiPrivacyText =>
      'عند تفعيل وضع الذكاء الاصطناعي، يُرسل سؤالك وملخص لأرقامك (الأعداد، الأرباح، أسماء الألعاب، أسماء الحسابات، الدرجات، التنبيهات) إلى Anthropic لكتابة الإجابة. لا تُرسل أبدًا عناوين البريد أو معرّفات الحسابات أو الملاحظات أو الصور. يُحفظ المفتاح مشفّرًا على هذا الهاتف.\n\nاحصل على مفتاح من console.anthropic.com (يُحتسب استخدام API على حسابك في Anthropic).';

  @override
  String get targetGoogleAccounts => 'حسابات Google';

  @override
  String get tournamentArena => 'ساحة البطولات';

  @override
  String get newChat => 'محادثة جديدة';

  @override
  String get aiModeOn => 'وضع الذكاء الاصطناعي: مفعّل';

  @override
  String get aiModeOff => 'وضع الذكاء الاصطناعي: متوقف';

  @override
  String get ask => 'اسأل';

  @override
  String get insights => 'التحليلات';

  @override
  String get levelAttention => 'انتباه';

  @override
  String get levelTips => 'نصائح';

  @override
  String get levelGood => 'أخبار جيدة';

  @override
  String insightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تحليل',
      many: '$count تحليلًا',
      few: '$count تحليلات',
      two: 'تحليلان',
      one: 'تحليل واحد',
      zero: 'لا تحليلات',
    );
    return '$_temp0';
  }

  @override
  String attentionAndGood(int attention, int good) {
    return '$attention تحتاج انتباهًا · $good أخبار جيدة';
  }

  @override
  String get nothingHereNow => 'لا شيء هنا الآن.';

  @override
  String get analysisOnDevice =>
      'يجري التحليل على هذا الجهاز من بياناتك ويتحدّث كلما عدّلت الحسابات.';

  @override
  String get contNorthAmerica => 'أمريكا الشمالية';

  @override
  String get contSouthAmerica => 'أمريكا الجنوبية';

  @override
  String get contEurope => 'أوروبا';

  @override
  String get contAfrica => 'أفريقيا';

  @override
  String get contAsia => 'آسيا';

  @override
  String get contOceania => 'أوقيانوسيا';

  @override
  String get globeSemantics =>
      'الكرة الأرضية. كل قارة قسم من أقسام التطبيق. استعمل زر «كل الأقسام» لعرضها.';

  @override
  String get backToGlobe => 'العودة إلى الكرة الأرضية';

  @override
  String get allSections => 'كل الأقسام';

  @override
  String get close => 'إغلاق';

  @override
  String get purpose => 'الغرض';

  @override
  String get tellWhereToGo => 'أخبرني إلى أين تريد الذهاب';

  @override
  String get explore => 'استكشاف';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String openScreen(String name) {
    return 'فتح $name';
  }

  @override
  String get screens => 'الشاشات';

  @override
  String get smallerPanel => 'لوحة أصغر';

  @override
  String get biggerPanel => 'لوحة أكبر';

  @override
  String get nothingHereYetDot => 'لا شيء هنا بعد.';

  @override
  String get noStatsForSection => 'لا توجد إحصائيات لهذا القسم.';

  @override
  String get secStatsTagline => 'التحليلات والأداء';

  @override
  String get destPerformanceSub => 'اليوم وهذا الأسبوع وهذا الشهر والأهداف';

  @override
  String get destGradeStatsSub => 'من البرونزي إلى الماسي والممنوع';

  @override
  String get secCardsTagline => 'الأدوات الذكية والساحة';

  @override
  String get secGamesTagline => 'حسابات ألعابك';

  @override
  String get destAllGames => 'كل الألعاب';

  @override
  String get destForSaleSub => 'الحسابات المعروضة للبيع حاليًا';

  @override
  String get destGameSub => 'حسابات هذه اللعبة وحالاتها';

  @override
  String get secGoogle => 'Google';

  @override
  String get secGoogleTagline => 'حسابات Google Play';

  @override
  String get destGoogleAddSub => 'إضافة حساب Google Play جديد';

  @override
  String get destGrades => 'الدرجات';

  @override
  String get destGradesSub => 'إحصائيات حسب الدرجة';

  @override
  String get destBoxStatus => 'حالة الصناديق';

  @override
  String get destBoxStatusSub => 'إحصائيات حسب حالة صندوق اللعبة';

  @override
  String get secProfileTagline => 'أنت وتقدّمك';

  @override
  String get destMyProfile => 'ملفي الشخصي';

  @override
  String get destMyProfileSub => 'الصورة والمعلومات والرتبة والجلسة';

  @override
  String get destAchievementsSub => 'الشارات والتقدم وتواريخ الفتح';

  @override
  String get secSettingsTagline => 'التفضيلات والأمان';

  @override
  String get destSettingsSub => 'المظهر واللغة والعملة والبيانات';

  @override
  String get destNotificationsSub => 'التحذيرات والتذكيرات';

  @override
  String get destTrashSub => 'استعادة الحسابات المحذوفة';

  @override
  String get orbScreens => 'الشاشات';

  @override
  String get orbSystem => 'النظام';

  @override
  String get orbNetProfit => 'صافي الربح';

  @override
  String get orbAccounts => 'الحسابات';

  @override
  String get orbSold => 'المبيعة';

  @override
  String get orbForSale => 'للبيع';

  @override
  String get orbActive => 'النشطة';

  @override
  String get orbAddedThisMonth => 'المضافة هذا الشهر';

  @override
  String get orbGoogleAccounts => 'حسابات Google';

  @override
  String get orbGamingAccounts => 'حسابات الألعاب';

  @override
  String get orbDuplicates => 'التكرارات';

  @override
  String get orbInVault => 'في الخزنة';

  @override
  String get orbClean => 'سليمة';

  @override
  String get orbGoogleDuplicates => 'تكرارات Google';

  @override
  String get orbSameAccountId => 'نفس معرّف الحساب';

  @override
  String get orbGames => 'الألعاب';

  @override
  String get orbListed => 'معروضة';

  @override
  String get orbBoxesSet => 'صناديق محددة';

  @override
  String get orbDone => 'منجزة';

  @override
  String get orbPremium => 'مميزة';

  @override
  String get orbName => 'الاسم';

  @override
  String get orbNotSet => 'غير محدد';

  @override
  String get orbUnlocked => 'مفتوحة';

  @override
  String get orbPoints => 'النقاط';

  @override
  String get orbNextGoal => 'الهدف التالي';

  @override
  String get orbAllDone => 'اكتمل كل شيء';

  @override
  String get orbTheme => 'السمة';

  @override
  String get orbMode => 'الوضع';

  @override
  String get orbCurrency => 'العملة';

  @override
  String get orbLanguage => 'اللغة';

  @override
  String get orbAlerts => 'التنبيهات';

  @override
  String get orbReminders => 'التذكيرات';

  @override
  String get orbNotifications => 'الإشعارات';

  @override
  String get orbOn => 'مفعّل';

  @override
  String get orbOff => 'متوقف';

  @override
  String get orbInTrash => 'في المهملات';

  @override
  String get orbDataIssues => 'مشاكل البيانات';

  @override
  String get orbNoMonthToCompare => 'لا يوجد شهر للمقارنة بعد';

  @override
  String orbPctOnLastMonth(String pct) {
    return '⁦$pct%⁩ مقارنة بالشهر الماضي';
  }

  @override
  String get orbNothingListed => 'لا شيء معروض الآن';

  @override
  String get orbListedNoPrice => 'معروض، دون سعر بعد';

  @override
  String get orbBestGame => 'أفضل لعبة';

  @override
  String get orbNoDataYet => 'لا توجد بيانات بعد';

  @override
  String get orbAddToRank => 'أضف حساب ألعاب لترتيب الألعاب';

  @override
  String orbFromAccounts(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حساب',
      many: '$count حسابًا',
      few: '$count حسابات',
      two: 'حسابين',
      one: 'حساب واحد',
    );
    return '$amount من $_temp0';
  }

  @override
  String get orbDiamondAccounts => 'الحسابات الماسية';

  @override
  String orbOutOfGoogle(int count) {
    return 'من أصل $count حساب Google';
  }

  @override
  String get orbDataHealth => 'سلامة البيانات';

  @override
  String get orbAllClear => 'لا مشاكل';

  @override
  String orbToReview(int count) {
    return '$count للمراجعة';
  }

  @override
  String get orbNoDuplicatesOrIds => 'لا تكرار ولا معرّفات ناقصة';

  @override
  String get orbDuplicatesEmailsIds =>
      'تكرارات أو بريد غير صالح أو معرّفات ناقصة';

  @override
  String get orbAchievements => 'الإنجازات';

  @override
  String get orbEveryBadge => 'تم فتح كل الشارات';

  @override
  String orbNext(String title) {
    return 'التالي: $title';
  }

  @override
  String get searchEveryScreen => 'البحث في كل الشاشات';

  @override
  String get howGlobeWorks => 'كيف تعمل الكرة الأرضية';

  @override
  String percentSemantics(String label, String pct) {
    return '$label $pct بالمئة';
  }

  @override
  String get open => 'فتح';

  @override
  String get whereToGo => 'إلى أين تريد الذهاب؟';

  @override
  String get searchScreenHint => 'ابحث عن شاشة، مثل الربح أو الخزنة';

  @override
  String get noScreenMatches => 'لا توجد شاشة مطابقة.';

  @override
  String screensCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شاشة',
      many: '$count شاشة',
      few: '$count شاشات',
      two: 'شاشتان',
      one: 'شاشة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get globeHelpDrag => 'اسحب الكرة الأرضية لتدويرها.';

  @override
  String get globeHelpTap => 'اضغط على نقطة مضيئة لترى محتوى تلك القارة.';

  @override
  String get globeHelpExplore =>
      'اضغط «استكشاف» للدخول، ثم اضغط على بطاقة لفتح الشاشة.';

  @override
  String get globeHelpSearch => 'الشريط في الأسفل يجد أي شاشة باسمها.';

  @override
  String get arenaStructSingleLeague => 'دوري واحد';

  @override
  String get arenaStructMultipleLeagues => 'عدة دوريات';

  @override
  String get arenaStructGroupsOnly => 'مجموعات فقط';

  @override
  String get arenaStructGroupsKnockout => 'مجموعات + إقصائيات';

  @override
  String get arenaStructLeaguesGroupsKnockout => 'دوريات + مجموعات + إقصائيات';

  @override
  String get arenaStructKnockoutOnly => 'إقصائيات فقط';

  @override
  String get arenaHintSingleLeague => 'الجميع يلعب ضد الجميع في جدول واحد.';

  @override
  String get arenaHintMultipleLeagues =>
      'يُوزَّع المشاركون على عدة دوريات مستقلة.';

  @override
  String get arenaHintGroupsOnly =>
      'دوري واحد مقسّم إلى مجموعات، لكل منها جدولها.';

  @override
  String get arenaHintGroupsKnockout =>
      'دور المجموعات، ثم يتأهل الأفضل إلى الأدوار الإقصائية.';

  @override
  String get arenaHintLeaguesGroupsKnockout =>
      'عدة دوريات، لكل منها مجموعات؛ يلتقي المتأهلون في أدوار إقصائية واحدة.';

  @override
  String get arenaHintKnockoutOnly =>
      'أدوار إقصائية مباشرة مع إعفاءات عند الحاجة.';

  @override
  String get arenaDetailUpTo48Players => 'حتى 48 لاعبًا';

  @override
  String get arenaDetailDuo => 'حتى 24 فريقًا · لاعبان لكل فريق';

  @override
  String get arenaDetailSquad => 'حتى 12 فريقًا · 4 لاعبين لكل فريق';

  @override
  String get arenaDetailOnePerTeam => 'لاعب واحد لكل فريق';

  @override
  String get arenaDetailUpTo2 => 'حتى لاعبَين لكل فريق';

  @override
  String get arenaDetailUpTo4 => 'حتى 4 لاعبين لكل فريق';

  @override
  String get arenaDetailUpTo8 => 'حتى 8 لاعبين لكل فريق';

  @override
  String get arenaDetail1v1 => '1 ضد 1';

  @override
  String get arenaDetailCoop => 'فريق ضد فريق · حتى 3 لاعبين لكل فريق';

  @override
  String get arenaDetailCustom => 'حجم فريق مخصص';

  @override
  String get arenaTbHeadToHead => 'المواجهة المباشرة';

  @override
  String get arenaTbGoalDifference => 'فارق الأهداف';

  @override
  String get arenaTbGoalsScored => 'الأهداف المسجلة';

  @override
  String get arenaTbGoalsAgainst => 'الأهداف المستقبلة';

  @override
  String get arenaTbShortH2h => 'مواجهة';

  @override
  String get arenaTbShortGd => 'فارق';

  @override
  String get arenaTbShortGf => 'له';

  @override
  String get arenaTbShortGa => 'عليه';

  @override
  String get arenaTbExplainH2h =>
      'تُرتَّب الفرق المتساوية في النقاط حسب مبارياتها فيما بينها: النقاط أولًا، ثم فارق الأهداف في تلك المباريات.';

  @override
  String get arenaTbExplainGd =>
      'الأهداف المسجلة ناقص الأهداف المستقبلة في كل المباريات.';

  @override
  String get arenaTbExplainGf => 'الفريق الذي سجّل أهدافًا أكثر يُرتَّب أعلى.';

  @override
  String get arenaTbExplainGa => 'الفريق الذي استقبل أهدافًا أقل يُرتَّب أعلى.';

  @override
  String get arenaKoPenalties => 'ركلات الترجيح';

  @override
  String get arenaKoExtraTime => 'الوقت الإضافي';

  @override
  String get arenaKoReplay => 'إعادة المباراة';

  @override
  String get arenaKoHintPenalties =>
      'تعادل بعد الوقت الأصلي: تُحسم بركلات الترجيح.';

  @override
  String get arenaKoHintExtraTime =>
      'تعادل بعد الوقت الأصلي: يُلعب وقت إضافي. وإن استمر التعادل تُحسم بركلات الترجيح.';

  @override
  String get arenaKoHintReplay =>
      'تعادل بعد الوقت الأصلي: تُعاد المباراة حتى يظهر فائز.';

  @override
  String get arenaAet => 'بعد التمديد';

  @override
  String get arenaPens => 'ترجيح';

  @override
  String get arenaColPldShort => 'لعب';

  @override
  String get arenaColWShort => 'ف';

  @override
  String get arenaColDShort => 'ت';

  @override
  String get arenaColLShort => 'خ';

  @override
  String get arenaColGfShort => 'له';

  @override
  String get arenaColGaShort => 'عليه';

  @override
  String get arenaColGdShort => 'فارق';

  @override
  String get arenaColPtsShort => 'نقاط';

  @override
  String get arenaColPlayed => 'الملعوبة';

  @override
  String get arenaColWins => 'الانتصارات';

  @override
  String get arenaColDraws => 'التعادلات';

  @override
  String get arenaColLosses => 'الهزائم';

  @override
  String get arenaColGoalsFor => 'الأهداف له';

  @override
  String get arenaColGoalsAgainst => 'الأهداف عليه';

  @override
  String get arenaColGoalDifference => 'فارق الأهداف';

  @override
  String get arenaColPoints => 'النقاط';

  @override
  String arenaScorePens(String score, String pens) {
    return '⁦$score⁩ (ترجيح ⁦$pens⁩)';
  }

  @override
  String get arenaErrKillPoints => 'نقاط القتل لا يمكن أن تكون سالبة.';

  @override
  String arenaErrPlacementRows(int slots, int count) {
    return 'جدول المراكز يحتاج بالضبط $slots صفًا (صف لكل مشارك أو فريق)؛ وفيه $count.';
  }

  @override
  String get arenaErrPlacementNegative => 'نقاط المراكز لا يمكن أن تكون سالبة.';

  @override
  String arenaErrPlacementOrder(int lower, int higher) {
    return 'لا يمكن أن يحصل مركز أدنى على نقاط أكثر من مركز أعلى (المركز $lower أكثر من المركز $higher).';
  }

  @override
  String get arenaErrFirstPlace => 'المركز الأول يجب أن يحصل على أكثر من 0.';

  @override
  String arenaErrZeroTail(int count) {
    return 'آخر $count مراكز يجب أن تحصل على 0 نقطة.';
  }

  @override
  String get arenaTbd => 'يُحدَّد لاحقًا';

  @override
  String get arenaUnknown => 'غير معروف';

  @override
  String get arenaErrNameRequired => 'اسم البطولة مطلوب.';

  @override
  String get arenaErrMin2 => 'أضف مشاركَين على الأقل.';

  @override
  String arenaErrTooMany(int count, int max) {
    return 'عدد المشاركين ($count) يتجاوز الحد الأقصى ($max).';
  }

  @override
  String get arenaErrDeadline =>
      'يجب أن يكون آخر موعد للتسجيل في تاريخ البدء أو قبله.';

  @override
  String get arenaErrWinPoints => 'نقاط الفوز يجب ألا تقل عن نقاط التعادل.';

  @override
  String get arenaErrMinColumns =>
      'اعرض عمودًا واحدًا على الأقل في جدول الترتيب.';

  @override
  String arenaErrMaxColumns(int max) {
    return 'يمكن لجدول الترتيب عرض $max أعمدة كحد أقصى.';
  }

  @override
  String get arenaErrMinRounds => 'خطّط لجولة واحدة على الأقل.';

  @override
  String get arenaErrMinLeagues => 'استعمل دوريَين على الأقل.';

  @override
  String get arenaErrMinGroups => 'استعمل مجموعتين على الأقل لكل دوري.';

  @override
  String arenaErrNotEnough(int leagues, int groups, int min) {
    return 'عدد المشاركين غير كافٍ: $leagues دوري × $groups مجموعة يحتاج $min على الأقل.';
  }

  @override
  String get arenaErrMinQualifier => 'يلزم متأهل واحد على الأقل من كل مجموعة.';

  @override
  String arenaErrQualifiersExceed(int q, int min) {
    return 'عدد المتأهلين من كل مجموعة ($q) يتجاوز حجم أصغر مجموعة ($min).';
  }

  @override
  String get arenaErrMin2Qualify =>
      'يجب أن يتأهل مشاركان على الأقل إلى الأدوار الإقصائية.';

  @override
  String arenaErrWinnerColumns(String mode, String columns) {
    return '$mode يُحسم بالفائز: اختر واحدًا على الأقل من $columns.';
  }

  @override
  String arenaErrMaxTeams(String mode, int cap, int count) {
    return '$mode يسمح بـ $cap فريقًا كحد أقصى (لديك $count).';
  }

  @override
  String arenaErrMaxPlayers(String mode, int cap, int count) {
    return '$mode يسمح بـ $cap لاعبًا كحد أقصى (لديك $count).';
  }

  @override
  String arenaErrMinTeamsBr(String mode, int min, int tail) {
    return '$mode يحتاج $min فرق على الأقل (آخر $tail مراكز لا تحصل على نقاط).';
  }

  @override
  String arenaErrMinPlayersBr(String mode, int min, int tail) {
    return '$mode يحتاج $min لاعبين على الأقل (آخر $tail مراكز لا تحصل على نقاط).';
  }

  @override
  String arenaErrExactPlayers(String name, int size) {
    return 'يجب أن يضم «$name» $size لاعبين بالضبط.';
  }

  @override
  String arenaErrBetweenPlayers(String name, int size) {
    return 'يجب أن يضم «$name» بين 1 و$size لاعبين.';
  }

  @override
  String arenaErrAssignedTwice(String name) {
    return 'اللاعب «$name» مسجَّل مرتين.';
  }

  @override
  String arenaErrAppearsTwice(String name) {
    return 'اللاعب «$name» يظهر أكثر من مرة.';
  }

  @override
  String arenaErrMinTotalPlayers(int min, int total) {
    return 'يجب تسجيل $min لاعبين على الأقل إجمالًا (حاليًا $total).';
  }

  @override
  String arenaLogCreatedBr(int count) {
    return 'أُنشئت البطولة: $count جولة Battle Royale';
  }

  @override
  String get arenaLogCreatedKo => 'أُنشئت البطولة: تم توليد جدول الإقصائيات';

  @override
  String arenaLogCreatedFixtures(int count) {
    return 'أُنشئت البطولة: تم توليد $count مباراة';
  }

  @override
  String get arenaLeague => 'الدوري';

  @override
  String arenaLeagueLetter(String letter) {
    return 'الدوري $letter';
  }

  @override
  String arenaGroupName(String name) {
    return 'المجموعة $name';
  }

  @override
  String get arenaFinal => 'النهائي';

  @override
  String get arenaSemiFinals => 'نصف النهائي';

  @override
  String get arenaQuarterFinals => 'ربع النهائي';

  @override
  String arenaRoundOf(int count) {
    return 'دور الـ$count';
  }

  @override
  String get arenaCritPoints => 'النقاط';

  @override
  String get arenaCritAllLevel => 'تعادل في كل المعايير (ترتيب أبجدي)';

  @override
  String arenaNoteMorePoints(String a, int pa, int pb) {
    return 'لدى $a نقاط أكثر (⁦$pa⁩ مقابل ⁦$pb⁩).';
  }

  @override
  String arenaNoteH2hBeat(int points, String a, String b, String score) {
    return 'تعادل بـ$points نقطة. المواجهة المباشرة: فاز $a على $b ⁦$score⁩ في مباراتهما.';
  }

  @override
  String arenaNoteH2hRecord(int points, String a) {
    return 'تعادل بـ$points نقطة. المواجهة المباشرة: لدى $a سجل أفضل في المباريات بين الفرق المتعادلة.';
  }

  @override
  String arenaNoteGd(int points, String a, String va, String b, String vb) {
    return 'تعادل بـ$points نقطة. فارق الأهداف: $a ⁦$va⁩ مقابل $b ⁦$vb⁩.';
  }

  @override
  String arenaNoteGf(int points, String a, int va, String b, int vb) {
    return 'تعادل بـ$points نقطة. الأهداف المسجلة: $a ⁦$va⁩ مقابل $b ⁦$vb⁩.';
  }

  @override
  String arenaNoteGa(int points, String a, int va, String b, int vb) {
    return 'تعادل بـ$points نقطة. الأهداف المستقبلة: $a ⁦$va⁩ مقابل $b ⁦$vb⁩ (الأقل أفضل).';
  }

  @override
  String get arenaNoteByName => 'تعادل في كل المعايير: الترتيب حسب الاسم.';

  @override
  String get arenaErrNoGroupStage =>
      'هذه البطولة ليس فيها دور مجموعات للتأهل منه.';

  @override
  String get arenaErrKoAlready => 'تم توليد الأدوار الإقصائية بالفعل.';

  @override
  String get arenaErrConfirmGroups =>
      'أكّد كل مباريات المجموعات قبل توليد الأدوار الإقصائية.';

  @override
  String get arenaErrMin2Qualified => 'يجب أن يتأهل مشاركان على الأقل.';

  @override
  String arenaLogKoGenerated(int count) {
    return 'تم توليد الإقصائيات من ترتيب المجموعات ($count متأهلين)';
  }

  @override
  String get arenaErrScoredMode =>
      'هذا الوضع يُسجَّل بنتيجة، وليس باختيار فائز.';

  @override
  String get arenaErrMatchNotFound => 'المباراة غير موجودة.';

  @override
  String get arenaErrWinnerSide => 'يجب أن يكون الفائز أحد الطرفين.';

  @override
  String get arenaErrByeNoResult => 'الإعفاء ليس له نتيجة.';

  @override
  String get arenaErrCancelled => 'أُلغيت هذه المباراة.';

  @override
  String get arenaErrBothKnown => 'يجب معرفة المشاركَين أولًا.';

  @override
  String get arenaErrNegativeScore => 'لا يمكن أن تكون النتائج سالبة.';

  @override
  String get arenaErrKoLocksGroups =>
      'تم توليد الإقصائيات بالفعل. أعد تعيين النتائج لتغيير نتائج المجموعات.';

  @override
  String get arenaErrNextRoundPlayed =>
      'الدور التالي لُعب بالفعل. أعد تعيين النتائج لتغيير هذه النتيجة.';

  @override
  String arenaLogReplay(String score, String home, String away, int n) {
    return 'تعادل ⁦$score⁩: ستُعاد مباراة $home ضد $away (إعادة رقم $n)';
  }

  @override
  String get arenaErrEnterPensAfterNormal =>
      'تعادل بعد الوقت الأصلي: أدخل نتيجة ركلات الترجيح.';

  @override
  String get arenaErrEnterPensAfterExtra =>
      'تعادل بعد الوقت الإضافي: أدخل نتيجة ركلات الترجيح.';

  @override
  String get arenaErrNegativePens => 'لا يمكن أن تكون نتائج الترجيح سالبة.';

  @override
  String get arenaErrPensWinner => 'ركلات الترجيح تحتاج فائزًا.';

  @override
  String arenaLogAmended(String names) {
    return 'عُدّلت النتيجة: $names';
  }

  @override
  String arenaLogConfirmed(String names) {
    return 'أُكّدت النتيجة: $names';
  }

  @override
  String get arenaLockBrConfirmed =>
      'جولة Battle Royale مؤكدة بالفعل. أعد تعيين النتائج لتغيير التشكيلات.';

  @override
  String get arenaLockPlayed =>
      'لُعبت بالفعل مباراة لهذه الفرق. أعد تعيين النتائج لإجراء هذا التغيير.';

  @override
  String get arenaErrParticipantNotFound => 'المشارك غير موجود.';

  @override
  String get arenaErrNameEmpty => 'لا يمكن أن يكون الاسم فارغًا.';

  @override
  String arenaLogRenamed(String old, String name) {
    return 'أُعيدت التسمية: $old ← $name';
  }

  @override
  String get arenaErrNoRosters => 'هذا الوضع ليس فيه تشكيلات فرق.';

  @override
  String get arenaErrTeamNeedsPlayer => 'يحتاج الفريق لاعبًا واحدًا على الأقل.';

  @override
  String arenaErrMaxPerTeam(String mode, int size) {
    return '$mode يسمح بـ $size لاعبين لكل فريق كحد أقصى.';
  }

  @override
  String arenaErrExactPerTeam(int size) {
    return 'يجب أن يضم كل فريق $size لاعبين بالضبط.';
  }

  @override
  String get arenaErrPlayerNameEmpty => 'لا يمكن أن تكون أسماء اللاعبين فارغة.';

  @override
  String arenaErrAlreadyInTeam(String name) {
    return '«$name» مسجَّل بالفعل في فريق.';
  }

  @override
  String arenaErrAlreadyRegistered(String name) {
    return '«$name» مسجَّل بالفعل.';
  }

  @override
  String arenaLogRoster(String team, int count) {
    return 'حُدّثت التشكيلة: $team ($count لاعبين)';
  }

  @override
  String get arenaErrChooseTwo => 'اختر عنصرين مختلفين.';

  @override
  String arenaLogSwapped(String a, String b) {
    return 'تم التبديل: $a ↔ $b';
  }

  @override
  String get arenaErrChooseTwoPlayers => 'اختر لاعبَين مختلفَين.';

  @override
  String get arenaErrPlayerNotInTeam => 'اللاعب غير موجود في ذلك الفريق.';

  @override
  String arenaLogPlayersSwapped(String a, String ta, String b, String tb) {
    return 'تم تبديل اللاعبَين: $a ($ta) ↔ $b ($tb)';
  }

  @override
  String get arenaErrOnlyBrRounds => 'بطولات Battle Royale وحدها فيها جولات.';

  @override
  String arenaLogRoundAdded(int n) {
    return 'أُضيفت الجولة $n';
  }

  @override
  String get arenaErrRoundNotFound => 'الجولة غير موجودة.';

  @override
  String get arenaErrUnknownInResults => 'مشارك غير معروف في النتائج.';

  @override
  String get arenaErrEnterPlacements => 'أدخل مركزًا لكل مشارك.';

  @override
  String arenaErrPlacementRange(int n) {
    return 'يجب أن تكون المراكز بين 1 و$n.';
  }

  @override
  String arenaErrSamePlacement(int n) {
    return 'لمشاركَين نفس المركز $n.';
  }

  @override
  String get arenaErrNegativeKills => 'لا يمكن أن يكون عدد القتلى سالبًا.';

  @override
  String arenaLogRoundAmended(int n) {
    return 'عُدّلت الجولة $n';
  }

  @override
  String arenaLogRoundConfirmed(int n) {
    return 'أُكّدت الجولة $n';
  }

  @override
  String get arenaCritWins => 'الانتصارات';

  @override
  String get arenaCritKills => 'القتلى';

  @override
  String get arenaCritLastRound => 'مركز الجولة الأخيرة';

  @override
  String get arenaCritNameOrder => 'الترتيب الأبجدي';

  @override
  String arenaBrNoteWins(int points, String a, int wa, String b, int wb) {
    return 'تعادل بـ$points نقطة. الانتصارات (المراكز الأولى): $a ⁦$wa⁩ مقابل $b ⁦$wb⁩.';
  }

  @override
  String arenaBrNoteKills(int points, String a, int ka, String b, int kb) {
    return 'تعادل بـ$points نقطة وفي الانتصارات. القتلى: $a ⁦$ka⁩ مقابل $b ⁦$kb⁩.';
  }

  @override
  String arenaBrNoteLastRound(String a) {
    return 'تعادل في النقاط والانتصارات والقتلى. مركز أفضل في الجولة الأخيرة: $a.';
  }

  @override
  String get arenaLogReset => 'أعاد المنظّم تعيين كل النتائج';

  @override
  String get create => 'إنشاء';

  @override
  String get noTournamentsYet => 'لا توجد بطولات بعد';

  @override
  String get createFirstTournament =>
      'أنشئ أول دوري أو مجموعات أو منافسة إقصائية.';

  @override
  String tournamentsOnDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بطولة على هذا الجهاز',
      many: '$count بطولة على هذا الجهاز',
      few: '$count بطولات على هذا الجهاز',
      two: 'بطولتان على هذا الجهاز',
      one: 'بطولة واحدة على هذا الجهاز',
      zero: 'لا بطولات على هذا الجهاز',
    );
    return '$_temp0';
  }

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشارك',
      many: '$count مشاركًا',
      few: '$count مشاركين',
      two: 'مشاركان',
      one: 'مشارك واحد',
    );
    return '$_temp0';
  }

  @override
  String champion(String name) {
    return 'البطل: $name';
  }

  @override
  String roundsConfirmed(int done, int total) {
    return '⁦$done / $total⁩ جولات مؤكدة';
  }

  @override
  String matchesConfirmed(int done, int total) {
    return '⁦$done / $total⁩ مباريات مؤكدة';
  }

  @override
  String get confirm => 'تأكيد';

  @override
  String get renamePlayer => 'إعادة تسمية اللاعب';

  @override
  String get nameUpdated => 'تم تحديث الاسم.';

  @override
  String get swapTeams => 'تبديل الفرق';

  @override
  String get swapPlayers => 'تبديل اللاعبين';

  @override
  String get teamA => 'الفريق أ';

  @override
  String get teamB => 'الفريق ب';

  @override
  String get playerA => 'اللاعب أ';

  @override
  String get playerB => 'اللاعب ب';

  @override
  String get swap => 'تبديل';

  @override
  String swapQuestion(String a, String b) {
    return 'تبديل $a و$b؟';
  }

  @override
  String swapTeamsBody(String a, String b) {
    return 'يأخذ $a مكان $b في القرعة والعكس. يحتفظ كل فريق بلاعبيه.';
  }

  @override
  String swapSoloBody(String a, String b) {
    return 'يأخذ $a مكان $b في القرعة والعكس.';
  }

  @override
  String swapped(String a, String b) {
    return 'تم تبديل $a و$b.';
  }

  @override
  String get addPlayersFirst => 'أضف أسماء لاعبين في مكانين على الأقل أولًا.';

  @override
  String swapPlayersBody(String a, String ta, String b, String tb) {
    return 'يتبادل $a ($ta) و$b ($tb) الفريقين. لا يتغير حجم الفرق.';
  }

  @override
  String get teamsAndPlayers => 'الفرق واللاعبون';

  @override
  String get tournamentGone => 'هذه البطولة لم تعد موجودة.';

  @override
  String get players => 'اللاعبون';

  @override
  String get searchTeamsOrPlayers => 'ابحث عن فرق أو لاعبين';

  @override
  String get searchPlayers => 'ابحث عن لاعبين';

  @override
  String teamsAndPlayersCount(int teams, int players) {
    return '$teams فرق · $players لاعبين';
  }

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب',
      many: '$count لاعبًا',
      few: '$count لاعبين',
      two: 'لاعبان',
      one: 'لاعب واحد',
    );
    return '$_temp0';
  }

  @override
  String get playedTeamsLocked => 'الفرق التي لعبت مقفلة';

  @override
  String get nothingFound => 'لم يُعثر على شيء.';

  @override
  String playersOfMax(int count, int max) {
    return '⁦$count / $max⁩ لاعبين';
  }

  @override
  String get noPlayerNamesTap => 'لا أسماء لاعبين بعد. اضغط لإضافتها.';

  @override
  String get teamNotFound => 'الفريق غير موجود.';

  @override
  String get renameTeam => 'إعادة تسمية الفريق';

  @override
  String get teamName => 'اسم الفريق';

  @override
  String get teamRenamed => 'تمت إعادة تسمية الفريق.';

  @override
  String get addPlayer => 'إضافة لاعب';

  @override
  String get playerName => 'اسم اللاعب';

  @override
  String nameAdded(String name) {
    return 'أُضيف $name.';
  }

  @override
  String get playerRenamed => 'تمت إعادة تسمية اللاعب.';

  @override
  String removeNameQ(String name) {
    return 'إزالة $name؟';
  }

  @override
  String leavesTeam(String name, String team) {
    return 'يغادر $name فريق $team.';
  }

  @override
  String nameRemoved(String name) {
    return 'أُزيل $name.';
  }

  @override
  String fixedTeamSizeNote(String mode, int size) {
    return 'الفرق في $mode تضم دائمًا $size لاعبين بالضبط. استعمل «تبديل اللاعبين» لتبادل الأعضاء.';
  }

  @override
  String get noPlayerNamesYet => 'لا أسماء لاعبين بعد.';

  @override
  String get tournament => 'البطولة';

  @override
  String get tabStandings => 'الترتيب';

  @override
  String get tabRounds => 'الجولات';

  @override
  String get tabMatches => 'المباريات';

  @override
  String get tabBracket => 'الجدول الإقصائي';

  @override
  String get tabInfo => 'معلومات';

  @override
  String get resetAllResultsQ => 'إعادة تعيين كل النتائج؟';

  @override
  String get resetBodyKo =>
      'تُمسح كل النتائج المؤكدة ويُحذف جدول الإقصائيات. تُسجَّل إعادة التعيين في سجل الأحداث.';

  @override
  String get resetBody =>
      'تُمسح كل النتائج المؤكدة. تُسجَّل إعادة التعيين في سجل الأحداث.';

  @override
  String get deleteTournamentQ => 'حذف البطولة؟';

  @override
  String get cannotBeUndone => 'لا يمكن التراجع عن ذلك.';

  @override
  String get resetResults => 'إعادة تعيين النتائج';

  @override
  String get deleteTournament => 'حذف البطولة';

  @override
  String get knockoutStage => 'الأدوار الإقصائية';

  @override
  String topNOfEveryGroup(int n) {
    return 'يتأهل أول $n من كل مجموعة.';
  }

  @override
  String get generateKnockout => 'توليد الإقصائيات';

  @override
  String get confirmGroupMatchesFirst => 'أكّد كل مباريات المجموعات أولًا';

  @override
  String get championCaps => 'البطل';

  @override
  String topNQualify(int n) {
    return 'يتأهل أول $n';
  }

  @override
  String get howTiesResolved => 'كيف حُسمت حالات التعادل';

  @override
  String matchday(int n) {
    return 'الجولة $n';
  }

  @override
  String get toPlay => 'لم تُلعب';

  @override
  String get filterPlayed => 'لُعبت';

  @override
  String get noMatchesHere => 'لا توجد مباريات هنا.';

  @override
  String get bye => 'إعفاء';

  @override
  String get win => 'فوز';

  @override
  String get vs => 'ضد';

  @override
  String get enterBothScores => 'أدخل النتيجتين كأعداد صحيحة.';

  @override
  String get pickWinner => 'اختر الفائز.';

  @override
  String get amendResult => 'تعديل النتيجة';

  @override
  String get whoWon => 'من فاز؟';

  @override
  String get pickWinningSide => 'اختر الطرف الفائز.';

  @override
  String get amendmentsRecorded => 'تُسجَّل التعديلات في سجل الأحداث.';

  @override
  String get saveAmendment => 'حفظ التعديل';

  @override
  String get confirmResult => 'تأكيد النتيجة';

  @override
  String get enterResult => 'إدخال النتيجة';

  @override
  String get decidedInExtraTime => 'حُسمت في الوقت الإضافي';

  @override
  String get penaltyShootout => 'ركلات الترجيح';

  @override
  String get levelReplayNote =>
      'نتيجة متعادلة: تعود هذه المباراة إلى «لم تُلعب» وتُعاد.';

  @override
  String earlierDraws(String list) {
    return 'تعادلات سابقة: ⁦$list⁩';
  }

  @override
  String get overallStandings => 'الترتيب العام';

  @override
  String brRoundsProgress(int done, int total) {
    return '⁦$done / $total⁩ جولات';
  }

  @override
  String brTotalFormula(int k) {
    return 'المجموع = نقاط المركز + القتلى × $k';
  }

  @override
  String get colRnd => 'جولات';

  @override
  String get colPlace => 'المركز';

  @override
  String get colKills => 'القتلى';

  @override
  String get colKillPts => 'نقاط القتل';

  @override
  String get colTotal => 'المجموع';

  @override
  String roundN(int n) {
    return 'الجولة $n';
  }

  @override
  String get roundConfirmedTap => 'مؤكدة · اضغط للتعديل';

  @override
  String get roundTapToEnter => 'اضغط لإدخال المراكز والقتلى';

  @override
  String get addRound => 'إضافة جولة';

  @override
  String enterPlacementKills(String name) {
    return 'أدخل مركزًا وعدد قتلى (0 أو أكثر) لـ «$name».';
  }

  @override
  String placementHelp(int n, int k) {
    return 'المركز من 1 إلى $n (دون تكرار). كل قتل = $k نقاط.';
  }

  @override
  String get confirmRound => 'تأكيد الجولة';

  @override
  String get bracketLater =>
      'يظهر الجدول الإقصائي بعد اكتمال دور المجموعات.\nافتح «الترتيب» واضغط «توليد الإقصائيات».';

  @override
  String get editParticipant => 'تعديل المشارك';

  @override
  String get teamClub => 'الفريق / النادي';

  @override
  String logParticipantEdited(String old, String name) {
    return 'عُدّل المشارك: $old ← $name';
  }

  @override
  String get rowScoring => 'التنقيط';

  @override
  String scoringBr(int k, int n) {
    return 'نقاط المركز + القتلى × $k ($n جولات مخططة)';
  }

  @override
  String get rowStructure => 'الهيكل';

  @override
  String get rowOrganizer => 'المنظّم';

  @override
  String get rowStart => 'البداية';

  @override
  String get rowRegistration => 'التسجيل';

  @override
  String untilDate(String date) {
    return 'حتى $date';
  }

  @override
  String pointsWinLoss(int w, int l) {
    return 'فوز $w · خسارة $l';
  }

  @override
  String pointsWdl(int w, int d, int l) {
    return 'فوز $w · تعادل $d · خسارة $l';
  }

  @override
  String get rowRanking => 'الترتيب';

  @override
  String get rowIfLevel => 'عند التعادل';

  @override
  String get rulesTitle => 'القواعد';

  @override
  String participantsTitle(int count) {
    return 'المشاركون ($count)';
  }

  @override
  String get editSwapPlayers => 'تعديل اللاعبين وتبديلهم';

  @override
  String get auditLog => 'سجل الأحداث';

  @override
  String get noEventsYet => 'لا أحداث بعد.';

  @override
  String get room => 'الغرفة';

  @override
  String roomIdValue(String id) {
    return 'معرّف الغرفة: $id';
  }

  @override
  String passwordValue(String pw) {
    return 'كلمة المرور: $pw';
  }

  @override
  String get roomStoredNote =>
      'محفوظ على هذا الجهاز فقط. لا يُشارَك تلقائيًا أبدًا.';

  @override
  String get stepSelectGame => 'اختيار اللعبة';

  @override
  String get stepTypeMode => 'النوع والوضع';

  @override
  String get stepSetup => 'الإعداد';

  @override
  String get stepDetails => 'التفاصيل والتأكيد';

  @override
  String maxReached(int cap) {
    return 'تم بلوغ الحد الأقصى ($cap).';
  }

  @override
  String get enterTeamPlayers => 'أدخل لاعبي الفريق مفصولين بفواصل.';

  @override
  String everyTeamExactly(int size) {
    return 'يحتاج كل فريق $size لاعبين بالضبط.';
  }

  @override
  String get createTournament => 'إنشاء البطولة';

  @override
  String get next => 'التالي';

  @override
  String get selectGameTitle => 'اختر اللعبة';

  @override
  String get selectGameSub => 'اختر لعبة بطولتك.';

  @override
  String get selectTypeTitle => 'اختر نوع البطولة';

  @override
  String selectTypeSub(String game) {
    return 'اختر الوضع الذي تريد تنظيمه في $game.';
  }

  @override
  String get selectModeTitle => 'اختر الوضع';

  @override
  String selectModeSub(String type) {
    return 'اختر صيغة $type.';
  }

  @override
  String get infoPointsSystem => 'نظام النقاط';

  @override
  String get infoTwoPlayers => 'لاعبان في كل مباراة';

  @override
  String get infoMin2Teams => 'الحد الأدنى: فريقان';

  @override
  String infoMinPlayers(int n) {
    return 'الحد الأدنى للاعبين: $n';
  }

  @override
  String get infoHowItWorks => 'طريقة العمل';

  @override
  String infoBrText(String detail) {
    return 'المجموع = نقاط المركز + نقطتان لكل قتل. آخر ثلاثة مراكز تحصل على 0 نقطة. $detail.';
  }

  @override
  String get infoCs1v1 =>
      'تحتاج كل مباراة لاعبَين. سجّل لاعبَين على الأقل. المباراة فوز أو خسارة: لا أهداف ولا تعادل.';

  @override
  String infoCsTeams(int size) {
    return 'يلزم فريقان على الأقل. يمكن أن تختلف أعداد اللاعبين (مثلًا 2 ضد 1)، حتى $size لكل فريق. المباراة فوز أو خسارة: لا أهداف ولا تعادل.';
  }

  @override
  String infoMinTotal(int n, int size) {
    return 'يلزم $n لاعبين مسجلين إجمالًا للبدء. حجم الفريق ($size) حد أقصى: لا يلزم ملء كل الأماكن.';
  }

  @override
  String get info1v1 => 'كل مباراة بين لاعبَين. النتائج تحدد الترتيب.';

  @override
  String get setupSub => 'التسجيل والصيغة والقواعد.';

  @override
  String get setupValid => 'الإعداد صالح. انتقل إلى الخطوة الأخيرة.';

  @override
  String get toContinue => 'للمتابعة';

  @override
  String get registrationPanel => 'التسجيل';

  @override
  String get maxTeams => 'الحد الأقصى للفرق';

  @override
  String get maxPlayers => 'الحد الأقصى للاعبين';

  @override
  String limitTeams(int max, String detail) {
    return 'الحد: حتى $max فريقًا ($detail).';
  }

  @override
  String limitPlayers(int max, String detail) {
    return 'الحد: حتى $max لاعبًا ($detail).';
  }

  @override
  String atLeastPlayersTotal(int n) {
    return '$n لاعبين على الأقل إجمالًا. لا يلزم أن تكون الفرق كاملة.';
  }

  @override
  String get playersCommaLabel => 'اللاعبون (أسماء مفصولة بفواصل)';

  @override
  String get playersCommaHint => 'مثال: علي، سارة';

  @override
  String exactlyPerTeam(int size) {
    return '$size لاعبين بالضبط لكل فريق.';
  }

  @override
  String oneToPerTeam(int size) {
    return 'من 1 إلى $size لاعبين لكل فريق. لا يلزم أن تكون الفرق كاملة.';
  }

  @override
  String teamsRegistered(int count, int cap, int players) {
    return '⁦$count / $cap⁩ فرق · $players لاعبين';
  }

  @override
  String playersRegistered(int count, int cap) {
    return '⁦$count / $cap⁩ لاعبين';
  }

  @override
  String get formatPanel => 'الصيغة';

  @override
  String get tournamentFormat => 'صيغة البطولة';

  @override
  String get numberOfLeagues => 'عدد الدوريات';

  @override
  String get groupsPerLeague => 'المجموعات لكل دوري';

  @override
  String get qualifiersPerGroup => 'المتأهلون من كل مجموعة';

  @override
  String get doubleRoundRobin => 'ذهاب وإياب';

  @override
  String get doubleRoundRobinSub => 'ذهاب وإياب: يلعب الجميع ضد الجميع مرتين';

  @override
  String get randomDraw => 'قرعة عشوائية';

  @override
  String get randomDrawSub =>
      'عند الإيقاف: يُرتَّب المشاركون حسب ترتيب إضافتهم';

  @override
  String get ifKoLevel => 'إذا انتهت مباراة إقصائية بالتعادل';

  @override
  String get pointsAndRanking => 'النقاط والترتيب';

  @override
  String get draw => 'تعادل';

  @override
  String get lossLabel => 'خسارة';

  @override
  String get tiebreakerOrder => 'ترتيب كسر التعادل';

  @override
  String get directMatchFirst => 'المواجهة المباشرة أولًا';

  @override
  String get goalDiffFirst => 'فارق الأهداف أولًا';

  @override
  String get rulesNoteWinnerOnly =>
      'يأخذ الفائز نقاط الفوز. تُرتَّب الفرق المتساوية حسب مواجهتها المباشرة ثم حسب الاسم. تُقفل عند بدء البطولة.';

  @override
  String get rulesNote =>
      'تُقفل هذه القواعد عند بدء البطولة. الفرق التي تبقى متعادلة بعد كل المعايير تُرتَّب حسب الاسم.';

  @override
  String get standingsColumns => 'أعمدة الترتيب';

  @override
  String columnsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عمودًا محددًا. يظهر الترتيب والاسم دائمًا.',
      few: '$count أعمدة محددة. يظهر الترتيب والاسم دائمًا.',
      two: 'عمودان محددان. يظهر الترتيب والاسم دائمًا.',
      one: 'عمود واحد محدد. يظهر الترتيب والاسم دائمًا.',
    );
    return '$_temp0';
  }

  @override
  String get roundsAndScoring => 'الجولات والتنقيط';

  @override
  String get plannedRounds => 'الجولات المخططة';

  @override
  String get brFormulaTitle => 'المجموع = نقاط المركز + القتلى × 2';

  @override
  String get brFormulaText => 'في الثنائي والفريق، تُجمع قتلى كل أعضاء الفريق.';

  @override
  String get placementPoints => 'نقاط المراكز';

  @override
  String registerTeamsFirst(int n) {
    return 'سجّل $n فرق على الأقل لإعداد الجدول (صف لكل فريق).';
  }

  @override
  String registerPlayersFirst(int n) {
    return 'سجّل $n لاعبين على الأقل لإعداد الجدول (صف لكل لاعب).';
  }

  @override
  String lastPlacementsZero(int n) {
    return 'آخر $n مراكز تحصل دائمًا على 0 نقطة.';
  }

  @override
  String get resetToDefault => 'إعادة إلى الافتراضي';

  @override
  String get notSet => 'غير محدد';

  @override
  String get tournamentSettings => 'إعدادات البطولة';

  @override
  String get tournamentSettingsSub => 'حدّد التفاصيل الأخيرة لبطولتك.';

  @override
  String get tournamentNameReq => 'اسم البطولة *';

  @override
  String get tournamentNameHint => 'مثال: كأس SPHERA';

  @override
  String get organizer => 'المنظّم';

  @override
  String get description => 'الوصف';

  @override
  String get startDateTime => 'تاريخ ووقت البدء';

  @override
  String get registrationDeadline => 'آخر موعد للتسجيل';

  @override
  String get rulesAndPenalties => 'القواعد والعقوبات';

  @override
  String get roomIdOptional => 'معرّف الغرفة (اختياري)';

  @override
  String get roomPasswordOptional => 'كلمة مرور الغرفة (اختيارية)';

  @override
  String get review => 'المراجعة';

  @override
  String get participantsRow => 'المشاركون';

  @override
  String participantsSummaryTeams(int count, int players, int max) {
    return '$count ($players لاعبين) · الحد $max';
  }

  @override
  String participantsSummary(int count, int max) {
    return '$count · الحد $max';
  }

  @override
  String get scoringBrShort => 'نقاط المركز + القتلى × 2';

  @override
  String get columnsRow => 'الأعمدة';

  @override
  String get readAndConfirm =>
      'يُرجى القراءة والتأكيد: تُقفل قواعد الترتيب عند بدء البطولة.';

  @override
  String get validRounds => 'كل شيء يبدو صالحًا. الإنشاء يولّد الجولات.';

  @override
  String get validFixtures => 'كل شيء يبدو صالحًا. الإنشاء يولّد المباريات.';

  @override
  String stepOf(int step, int total, String title) {
    return 'الخطوة $step من $total · $title';
  }

  @override
  String get rankingOrder => 'ترتيب التصنيف';

  @override
  String get teamColumn => 'الفريق';

  @override
  String filterAllCount(int count) {
    return 'الكل $count';
  }

  @override
  String filterActiveCount(int count) {
    return 'النشطة $count';
  }

  @override
  String filterSoldCount(int count) {
    return 'المبيعة $count';
  }

  @override
  String arenaLoadError(String error) {
    return 'تعذّرت قراءة البطولات المحفوظة ($error).';
  }

  @override
  String ratesServerError(int code) {
    return 'ردّ خادم الأسعار بالرمز $code.';
  }

  @override
  String get ratesUnavailable => 'الأسعار غير متاحة حاليًا.';

  @override
  String get ratesNoInternet =>
      'تعذّر تحديث الأسعار. تحقّق من اتصالك بالإنترنت.';
}
