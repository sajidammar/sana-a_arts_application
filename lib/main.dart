import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/auth_provider.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/exhibition/navigation_provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/themes/app_theme.dart';
import 'package:sanaa_artl/views/exhibitions/home/home_page.dart';
import 'package:sanaa_artl/views/home/home_view.dart';
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

void main() {
  runApp(
    MultiProvider(
      providers: [
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
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'فنون صنعاء التشكيلية',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode ? AppTheme.dark : AppTheme.light,
          home: const Home_Page(),
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
