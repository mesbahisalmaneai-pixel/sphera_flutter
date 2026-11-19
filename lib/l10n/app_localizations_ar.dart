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
}
