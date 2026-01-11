import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/academies/controllers/registration_provider.dart';
import 'package:sanaa_artl/features/academies/controllers/workshop_provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/navigation_provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/vr_provider.dart';
import 'package:sanaa_artl/features/community/controllers/community_provider.dart';
import 'package:sanaa_artl/features/community/controllers/reel_provider.dart';
import 'package:sanaa_artl/features/chat/controllers/chat_provider.dart';
import 'package:sanaa_artl/core/localization/app_localizations.dart';
import 'package:sanaa_artl/core/localization/language_provider.dart';
import 'package:sanaa_artl/features/auth/controllers/user_controller.dart';
import 'package:sanaa_artl/features/auth/controllers/provider.dart';
import 'package:sanaa_artl/core/themes/app_theme.dart';
import 'package:sanaa_artl/features/exhibitions/views/home/home_page.dart';
import 'package:sanaa_artl/features/home/views/home_view.dart';
import 'package:sanaa_artl/features/store/views/cart/cart_page.dart';
import 'package:sanaa_artl/features/store/views/invoice/invoice_page.dart';
import 'package:sanaa_artl/features/store/views/order/order_history_page.dart';
// Providers
import 'package:sanaa_artl/core/services/storage_service.dart';
import 'package:sanaa_artl/core/services/connectivity_service.dart';
import 'package:sanaa_artl/core/services/notification_service.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/store/controllers/cart_provider.dart';
import 'package:sanaa_artl/features/store/controllers/order_provider.dart';
import 'package:sanaa_artl/features/store/controllers/product_provider.dart';
import 'package:sanaa_artl/features/store/controllers/invoice_provider.dart';
import 'package:sanaa_artl/features/wishlist/controllers/wishlist_provider.dart';
import 'package:sanaa_artl/features/admin/controllers/admin_provider.dart';
import 'package:sanaa_artl/core/controllers/app_status_provider.dart';
import 'package:sanaa_artl/core/widgets/global_status_banner.dart';
import 'package:sanaa_artl/core/widgets/coming_soon_page.dart';

void main() async {
  // ضمان تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) => CartProvider()..loadCartItems(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider()..loadOrders(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider()..loadProducts(),
        ),
        ChangeNotifierProvider(
          create: (context) => InvoiceProvider()..loadInvoice('ORD-2024-001'),
        ),
        ChangeNotifierProvider(create: (context) => ExhibitionProvider()),
        ChangeNotifierProvider(create: (context) => VRProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => WorkshopProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => CommunityProvider()),
        ChangeNotifierProvider(create: (context) => ReelProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => AdminProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => AppStatusProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => CheckboxProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _initializeApp();
    });
  }

  /// تهيئة التطبيق وقاعدة البيانات
  Future<void> _initializeApp() async {
    // الحصول على الـ providers بدون الاستماع للتغييرات
    final statusProvider = Provider.of<AppStatusProvider>(
      context,
      listen: false,
    );
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final communityProvider = Provider.of<CommunityProvider>(
      context,
      listen: false,
    );

    // تهيئة نظام التخزين والمجلدات
    final storageService = StorageService();
    await storageService.initialize(statusProvider);

    // تهيئة خدمات الاتصال والإشعارات
    final connectivityService = ConnectivityService();
    await connectivityService.initialize(statusProvider);

    final notificationService = NotificationService();
    await notificationService.initialize(statusProvider);

    // تهيئة ReelProvider
    if (!mounted) return;
    final reelProvider = Provider.of<ReelProvider>(context, listen: false);

    // تهيئة قاعدة البيانات والمستخدم
    await userProvider.initialize();

    // تهيئة بيانات المجتمع والريلز
    reelProvider.initialize();
    communityProvider.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'فنون صنعاء التشكيلية',
          debugShowCheckedModeBanner: false,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: Column(
              children: [
                const GlobalStatusBanner(),
                Expanded(child: child!),
              ],
            ),
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar', 'AE'), Locale('en', 'US')],
          locale: languageProvider.locale,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          home: _isInitialized ? const HomePage() : const _LoadingScreen(),
          routes: {
            '/exhibition': (context) => ExhibitionHomePage(),
            '/home': (context) => const ComingSoonPage(
              featureName: 'المتجر',
              description:
                  'متجر الأعمال الفنية قيد التطوير\nسيتم إطلاقه قريباً مع مجموعة رائعة من اللوحات والمنتجات الفنية',
              icon: Icons.store_rounded,
            ),
            '/cart': (context) => CartPage(),
            '/order-history': (context) => OrderHistoryPage(),
            '/invoice': (context) => InvoicePage(),
          },
        );
      },
    );
  }
}

/// شاشة التحميل أثناء تهيئة قاعدة البيانات
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFF4E4BC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.palette,
                size: 60,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 32),
            // عنوان التطبيق
            const Text(
              'فنون صنعاء التشكيلية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 16),
            // نص التحميل
            const Text(
              'جاري التحميل...',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontSize: 16,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 24),
            // مؤشر التحميل
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
