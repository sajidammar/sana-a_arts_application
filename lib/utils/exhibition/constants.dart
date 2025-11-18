import 'package:flutter/material.dart';

class AppConstants {

  
  // معلومات التطبيق الأساسية
  static const String appName = 'فنون صنعاء';
  static const String appDescription = 'منصة فنون صنعاء التشكيلية';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

    // أنصاف الأقطار


  static const double smallBorderRadius = 8.0;
  static const double borderRadius = 15.0; // إضافة هذا السطر
  static const double defaultBorderRadius = 15.0;
  static const double mediumBorderRadius = 20.0;
  static const double largeBorderRadius = 30.0;
  static const double extraLargeBorderRadius = 40.0;
  static const double buttonBorderRadius = 25.0;
  static const double cardBorderRadius = 15.0;
  static const double dialogBorderRadius = 20.0;

  // الرسوم المتحركة
  static const Duration defaultAnimationDuration = Duration(milliseconds: 400);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 600);
  static const Duration longAnimationDuration = Duration(milliseconds: 800);
  static const Duration veryLongAnimationDuration = Duration(milliseconds: 1200);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 200);
  static const Duration notificationDuration = Duration(seconds: 3);

  // المسافات والحشوات
  static const double extraSmallPadding = 4.0;
  static const double smallPadding = 8.0;
  static const double defaultPadding = 16.0;
  static const double mediumPadding = 20.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  static const double sectionPadding = 40.0;
  
  static const double smallSpacing = 8.0;
  static const double defaultSpacing = 16.0;
  static const double mediumSpacing = 20.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;



  // الأحجام والأبعاد
  static const double appBarHeight = 80.0;
  static const double bottomNavigationBarHeight = 70.0;
  static const double tabBarHeight = 48.0;
  static const double buttonHeight = 50.0;
  static const double smallButtonHeight = 40.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 48.0;
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 60.0;
  static const double avatarSizeLarge = 80.0;
  static const double logoSize = 120.0;

  // نقاط التوقف للتصميم المتجاوب
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;
  static const double largeDesktopBreakpoint = 1600.0;

  // حدود وأحجام أخرى
  static const double maxButtonWidth = 300.0;
  static const double minButtonWidth = 120.0;
  static const double maxDialogWidth = 500.0;
  static const double maxFormWidth = 400.0;
  static const double gridMaxWidth = 1400.0;

  

  // الظلال
  static const BoxShadow smallShadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
  
  static const BoxShadow mediumShadow = BoxShadow(
    color: Color(0x26000000),
    blurRadius: 8,
    offset: Offset(0, 4),
  );
  
  static const BoxShadow largeShadow = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 16,
    offset: Offset(0, 8),
  );
  
  static const BoxShadow extraLargeShadow = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 24,
    offset: Offset(0, 12),
  );

  // التقدير والتصنيف
  static const int maxRating = 5;
  static const int minRating = 1;
  static const double defaultRating = 4.0;

  // التحجيم والتكبير
  static const double minZoomLevel = 0.5;
  static const double maxZoomLevel = 5.0;
  static const double defaultZoomLevel = 1.0;
  static const double zoomStep = 0.25;

  // الأزمنة والفترات
  static const int autoTourIntervalSeconds = 8;
  static const int splashScreenDuration = 2000;
  static const int debounceDuration = 500;
  static const int pullToRefreshTimeout = 10000;

  // البيانات الافتراضية
  static const int defaultArtworksCount = 10;
  static const int defaultExhibitionsCount = 6;
  static const int itemsPerPage = 12;
  static const int featuredItemsCount = 3;

  // المفاتيح والتخزين
  static const String themeModeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String favoritesKey = 'favorites';
  static const String cartKey = 'cart_items';
  static const String settingsKey = 'app_settings';

  // النصوص الثابتة
  static const String loadingText = 'جاري التحميل...';
  static const String errorText = 'حدث خطأ ما';
  static const String noDataText = 'لا توجد بيانات';
  static const String retryText = 'إعادة المحاولة';
  static const String successText = 'تمت العملية بنجاح';
  static const String confirmText = 'تأكيد';
  static const String cancelText = 'إلغاء';
  static const String saveText = 'حفظ';
  static const String deleteText = 'حذف';
  static const String editText = 'تعديل';
  static const String viewText = 'عرض';
  static const String shareText = 'مشاركة';
  static const String downloadText = 'تحميل';

  // روابط ومسارات API (في التطبيق الحقيقي)
  static const String baseUrl = 'https://api.sanaa-arts.com';
  static const String exhibitionsEndpoint = '/api/exhibitions';
  static const String artworksEndpoint = '/api/artworks';
  static const String artistsEndpoint = '/api/artists';
  static const String usersEndpoint = '/api/users';
  static const String uploadEndpoint = '/api/upload';
  static const String authEndpoint = '/api/auth';

  // مسارات الصور والأصول
  static const String imagesBasePath = 'assets/images/';
  static const String iconsBasePath = 'assets/icons/';
  static const String animationsBasePath = 'assets/animations/';
  static const String patternsBasePath = 'assets/patterns/';
  static const String backgroundsBasePath = 'assets/backgrounds/';

  // أسماء الملفات
  static const String appLogo = '${imagesBasePath}logo.png';
  static const String placeholderImage = '${imagesBasePath}placeholder.jpg';
  static const String userPlaceholder = '${imagesBasePath}user_placeholder.png';
  static const String artworkPlaceholder = '${imagesBasePath}artwork_placeholder.png';
  static const String exhibitionPattern = '${patternsBasePath}exhibition_pattern.svg';
  static const String vrGridPattern = '${patternsBasePath}vr_grid.svg';
  static const String loadingAnimation = '${animationsBasePath}loading.json';
  static const String successAnimation = '${animationsBasePath}success.json';

  // التكوينات الخاصة بـ VR
  static const double vrRotationSpeed = 0.01;
  static const double vrMaxRotation = 0.5;
  static const double vrSensitivity = 1.0;
  static const int vrFrameRate = 60;

  // إعدادات الوسائط
  static const double audioVolume = 1.0;
  static const double audioGuideSpeed = 1.0;
  static const bool enableHaptics = true;
  static const bool enableAnimations = true;

  // الأخطاء والشفرات
  static const String networkError = 'NETWORK_ERROR';
  static const String serverError = 'SERVER_ERROR';
  static const String authError = 'AUTH_ERROR';
  static const String notFoundError = 'NOT_FOUND_ERROR';
  static const String validationError = 'VALIDATION_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';
}


  // أنماط النص الرئيسية (باستخدام خط Tajawal
class AppAssets {
  // الأيقونات
  static const String appIcon = 'assets/icons/app_icon.png';
  static const String logo = 'assets/icons/logo.png';
  static const String logoWhite = 'assets/icons/logo_white.png';
  
  // الصور
  static const String heroBackground = 'assets/images/hero_background.jpg';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String userAvatar = 'assets/images/user_avatar.png';
  static const String artworkPlaceholder = 'assets/images/artwork_placeholder.jpg';
  static const String exhibitionPlaceholder = 'assets/images/exhibition_placeholder.jpg';
  static const String artistPlaceholder = 'assets/images/artist_placeholder.jpg';
  
  // الأنماط
  static const String exhibitionPattern = 'assets/patterns/exhibition_pattern.svg';
  static const String vrGridPattern = 'assets/patterns/vr_grid.svg';
  static const String backgroundPattern = 'assets/patterns/background_pattern.svg';
  
  // الخلفيات
  static const String virtualBackground = 'assets/backgrounds/virtual_gradient.png';
  static const String realityBackground = 'assets/backgrounds/reality_gradient.png';
  static const String openBackground = 'assets/backgrounds/open_gradient.png';
  static const String goldBackground = 'assets/backgrounds/gold_gradient.png';
  
  // الرسوم المتحركة
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String emptyAnimation = 'assets/animations/empty.json';
  static const String vrLoadingAnimation = 'assets/animations/vr_loading.json';
}

class AppRoutes {
  // مسارات التطبيق
  static const String home = '/';
  static const String exhibitions = '/exhibitions';
  static const String exhibitionDetail = '/exhibitions/:id';
  static const String vrExhibition = '/vr-exhibition';
  static const String artworks = '/artworks';
  static const String artworkDetail = '/artworks/:id';
  static const String artists = '/artists';
  static const String artistDetail = '/artists/:id';
  static const String workshops = '/workshops';
  static const String workshopDetail = '/workshops/:id';
  static const String store = '/store';
  static const String productDetail = '/store/:id';
  static const String news = '/news';
  static const String newsDetail = '/news/:id';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  
  // مسارات التبويب
  static const String homeTab = '/home';
  static const String exhibitionsTab = '/exhibitions-tab';
  static const String workshopsTab = '/workshops-tab';
  static const String storeTab = '/store-tab';
  static const String profileTab = '/profile-tab';
}

class AppStrings {
  // النصوص الثابتة للتطبيق
  static const String appName = 'فنون صنعاء';
  static const String appSlogan = 'منصة الفنون التشكيلية اليمنية';
  static const String welcome = 'مرحباً بك';
  static const String exploreExhibitions = 'استكشف المعارض';
  static const String virtualExhibitions = 'المعارض الافتراضية';
  static const String realityExhibitions = 'المعارض الواقعية';
  static const String openExhibitions = 'المعارض المفتوحة';
  static const String currentExhibitions = 'المعارض الحالية';
  static const String featuredExhibitions = 'المعارض المميزة';
  static const String upcomingExhibitions = 'المعارض القادمة';
  static const String pastExhibitions = 'المعارض المنتهية';
  static const String artworks = 'الأعمال الفنية';
  static const String artists = 'الفنانين';
  static const String workshops = 'الدورات';
  static const String news = 'الأخبار';
  static const String about = 'من نحن';
  static const String contact = 'اتصل بنا';
  static const String profile = 'الملف الشخصي';
  static const String settings = 'الإعدادات';
  static const String login = 'تسجيل الدخول';
  static const String register = 'إنشاء حساب';
  static const String logout = 'تسجيل الخروج';
  static const String search = 'بحث';
  static const String filter = 'تصفية';
  static const String sort = 'ترتيب';
  static const String viewAll = 'عرض الكل';
  static const String seeMore = 'المزيد';
  static const String readMore = 'اقرأ المزيد';
  static const String bookNow = 'احجز الآن';
  static const String buyNow = 'اشتري الآن';
  static const String addToCart = 'أضف إلى السلة';
  static const String addToFavorites = 'أضف إلى المفضلة';
  static const String removeFromFavorites = 'إزالة من المفضلة';
  static const String share = 'مشاركة';
  static const String download = 'تحميل';
  static const String rate = 'تقييم';
  static const String comment = 'تعليق';
  static const String like = 'إعجاب';
  static const String follow = 'متابعة';
  static const String unfollow = 'إلغاء المتابعة';
  static const String submit = 'إرسال';
  static const String cancel = 'إلغاء';
  static const String save = 'حفظ';
  static const String delete = 'حذف';
  static const String edit = 'تعديل';
  static const String create = 'إنشاء';
  static const String update = 'تحديث';
  static const String confirm = 'تأكيد';
  static const String back = 'رجوع';
  static const String next = 'التالي';
  static const String previous = 'السابق';
  static const String finish = 'إنهاء';
  static const String skip = 'تخطي';
  static const String done = 'تم';
  static const String ok = 'موافق';
  static const String yes = 'نعم';
  static const String no = 'لا';
  static const String retry = 'إعادة المحاولة';
  static const String loading = 'جاري التحميل...';
  static const String processing = 'جاري المعالجة...';
  static const String success = 'تمت العملية بنجاح';
  static const String error = 'حدث خطأ ما';
  static const String warning = 'تحذير';
  static const String info = 'معلومة';
  static const String attention = 'انتباه';
  static const String congratulations = 'مبروك';
  static const String thankYou = 'شكراً لك';
  static const String welcomeBack = 'مرحباً بعودتك';
  static const String newHere = 'جديد هنا؟';
  static const String forgotPassword = 'نسيت كلمة المرور؟';
  static const String resetPassword = 'إعادة تعيين كلمة المرور';
  static const String changePassword = 'تغيير كلمة المرور';
  static const String email = 'البريد الإلكتروني';
  static const String password = 'كلمة المرور';
  static const String confirmPassword = 'تأكيد كلمة المرور';
  static const String firstName = 'الاسم الأول';
  static const String lastName = 'اسم العائلة';
  static const String fullName = 'الاسم الكامل';
  static const String phone = 'رقم الهاتف';
  static const String address = 'العنوان';
  static const String city = 'المدينة';
  static const String country = 'البلد';
  static const String bio = 'السيرة الذاتية';
  static const String website = 'الموقع الإلكتروني';
  static const String socialMedia = 'وسائل التواصل الاجتماعي';
  static const String notifications = 'الإشعارات';
  static const String privacy = 'الخصوصية';
  static const String terms = 'الشروط والأحكام';
  static const String help = 'المساعدة';
  static const String support = 'الدعم';
  static const String feedback = 'الملاحظات';
  static const String report = 'الإبلاغ عن مشكلة';
  static const String version = 'الإصدار';
  static const String build = 'رقم البناء';
  static const String developer = 'المطور';
  static const String copyright = 'حقوق النشر';
  static const String allRightsReserved = 'جميع الحقوق محفوظة';
  
  // نصوص خاصة بـ VR
  static const String enterVR = 'الدخول إلى الواقع الافتراضي';
  static const String exitVR = 'الخروج من الواقع الافتراضي';
  static const String vrMode = 'وضع VR';
  static const String mode360 = 'وضع 360°';
  static const String mode3D = 'وضع 3D';
  static const String audioGuide = 'الدليل الصوتي';
  static const String autoTour = 'الجولة التلقائية';
  static const String fullscreen = 'شاشة كاملة';
  static const String resetView = 'إعادة تعيين العرض';
  static const String zoomIn = 'تكبير';
  static const String zoomOut = 'تصغير';
  static const String navigate = 'تنقل';
  static const String currentArtwork = 'العمل الحالي';
  static const String artworkDetails = 'تفاصيل العمل';
  static const String interactiveFeatures = 'الميزات التفاعلية';
  static const String artworkActions = 'إجراءات العمل';
  static const String rating = 'التقييم';
  static const String comments = 'التعليقات';
  static const String liveComments = 'التعليقات المباشرة';
  static const String addComment = 'أضف تعليق';
  static const String sendComment = 'إرسال التعليق';
  static const String recentComments = 'آخر التعليقات';
  static const String highQualityDownload = 'تحميل عالي الجودة';
  static const String viewArtist = 'عرض الفنان';
  static const String shareArtwork = 'مشاركة العمل';
  
  // نصوص الأخطاء
  static const String networkError = 'خطأ في الاتصال بالشبكة';
  static const String serverError = 'خطأ في الخادم';
  static const String authError = 'خطأ في المصادقة';
  static const String notFoundError = 'لم يتم العثور على البيانات';
  static const String validationError = 'خطأ في التحقق';
  static const String unknownError = 'خطأ غير معروف';
  static const String timeoutError = 'انتهت مهلة الاتصال';
  static const String noInternet = 'لا يوجد اتصال بالإنترنت';
  static const String tryAgain = 'حاول مرة أخرى';
  static const String checkConnection = 'تحقق من اتصال الإنترنت';
  
  // نصوص النجاح
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String registerSuccess = 'تم إنشاء الحساب بنجاح';
  static const String logoutSuccess = 'تم تسجيل الخروج بنجاح';
  static const String updateSuccess = 'تم التحديث بنجاح';
  static const String deleteSuccess = 'تم الحذف بنجاح';
  static const String saveSuccess = 'تم الحفظ بنجاح';
  static const String addSuccess = 'تم الإضافة بنجاح';
  static const String removeSuccess = 'تم الإزالة بنجاح';
  static const String purchaseSuccess = 'تم الشراء بنجاح';
  static const String bookingSuccess = 'تم الحجز بنجاح';
  static const String uploadSuccess = 'تم الرفع بنجاح';
  static const String downloadSuccess = 'تم التحميل بنجاح';
  static const String shareSuccess = 'تم المشاركة بنجاح';
  static const String rateSuccess = 'تم التقييم بنجاح';
  static const String commentSuccess = 'تم إضافة التعليق بنجاح';
}

class AppConfig {
  // إعدادات التطبيق
  static const bool isDebug = bool.fromEnvironment('dart.vm.product');
  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
  static const bool enableLogging = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  
  // إعدادات التحديث
  static const int cacheDuration = 300; // 5 دقائق
  static const int imageCacheDuration = 3600; // ساعة واحدة
  static const int apiTimeout = 30000; // 30 ثانية
  
  // إعدادات الوسائط
  static const int imageQuality = 80;
  static const int maxImageSize = 2048; // بكسل
  static const int maxFileSize = 10 * 1024 * 1024; // 10 ميجابايت
  
  // إعدادات الأمان
  static const int minPasswordLength = 6;
  static const int maxLoginAttempts = 5;
  static const int lockoutDuration = 900; // 15 دقيقة
  
  // إعدادات التطبيق
  static const String defaultLanguage = 'ar';
  static const String defaultCurrency = 'SAR';
  static const String defaultCountry = 'SA';
  static const String defaultTimeZone = 'Asia/Riyadh';
  
  // إعدادات التخصيص
  static const bool enableDarkMode = true;
  static const bool enableRTL = true;
  static const bool enableAnimations = true;
  static const bool enableHaptics = true;
  static const bool enableSounds = true;
}