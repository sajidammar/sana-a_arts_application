import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/themes/app_theme.dart';
import 'package:sanaa_artl/views/home/home_view.dart';
import 'providers/theme_provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
          home: const HomePage(),
        );
      },
    );
  }
}