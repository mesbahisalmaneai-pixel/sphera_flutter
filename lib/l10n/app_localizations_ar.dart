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
}
