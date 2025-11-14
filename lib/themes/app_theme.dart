import 'package:flutter/material.dart';

class AppTheme {
  // الوضع النهاري - الألوان الجديدة
  static final ThemeData light = ThemeData(
    primaryColor: const Color(0xFFB8860B),
    scaffoldBackgroundColor: const Color(0xFFFDF6E3),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      elevation: 2,
      foregroundColor: Color(0xFFB8860B),
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFB8860B),
      secondary: Color(0xFF8B6914),
    ),
  );

  // الوضع الليلي - الألوان الجديدة
  static final ThemeData dark = ThemeData(
    primaryColor: const Color(0xFFD4AF37),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 2,
      foregroundColor: Color(0xFFD4AF37),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD4AF37),
      secondary: Color(0xFFB8860B),
    ),
  );
}