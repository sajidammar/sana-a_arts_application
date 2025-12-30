import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/registration_provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/providers/exhibition/auth_provider.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/exhibition/navigation_provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/providers/community/community_provider.dart';
import 'package:sanaa_artl/providers/user_provider.dart';
import 'package:sanaa_artl/themes/app_theme.dart';
import 'package:sanaa_artl/views/exhibitions/home/home_page.dart';
import 'package:sanaa_artl/views/home/home_view.dart';
import 'package:sanaa_artl/views/profile/user_editing.dart';
import 'package:sanaa_artl/views/store/cart/cart_page.dart';
import 'package:sanaa_artl/views/store/home_page.dart';
import 'package:sanaa_artl/views/store/invoice/invoice_page.dart';
import 'package:sanaa_artl/views/store/order/order_history_page.dart';
// Providers
import 'providers/theme_provider.dart';
import 'providers/store/cart_provider.dart';
import 'providers/store/order_provider.dart';
import 'providers/store/product_provider.dart';
import 'providers/store/invoice_provider.dart';
import 'providers/wishlist_provider.dart';
import 'management/providers/management_provider.dart';

void main() async {
  // ضمان تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [

        // مزود المستخدم - يجب أن يكون أولاً لتهيئة قاعدة البيانات
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WorkshopProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => CommunityProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => ManagementProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider1()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ExhibitionProvider()),
        ChangeNotifierProvider(create: (_) => VRProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => WorkshopProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),

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
    final _ = Provider.of<UserProvider1>(context, listen: false);
    final communityProvider = Provider.of<CommunityProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // تهيئة قاعدة البيانات والمستخدم
    // await userProvider.initialize();

    // تحميل جلسة المستخدم المحفوظة
    await authProvider.loadSavedSession();

    // تهيئة بيانات المجتمع
    await communityProvider.initialize();

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'فنون صنعاء التشكيلية',
          debugShowCheckedModeBanner: false,
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('ar', 'AE')],
          locale: const Locale('ar', 'AE'),
          theme: themeProvider.isDarkMode ? AppTheme.dark : AppTheme.light,
          home: _isInitialized ? const HomePage() : const _LoadingScreen(),
          routes: {
            '/exhibition': (context) => ExhibitionHomePage(),
            '/home': (context) => StorePage(),
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
