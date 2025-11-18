import 'package:flutter/material.dart';
import '../../utils/store/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppConstants.primaryColor,
      primaryColorDark: AppConstants.primaryDark,
      colorScheme: ColorScheme.light(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.primaryColor.withValues(alpha:0.8),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppConstants.textColor,
      ),
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppConstants.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'Tajawal',
        ),
        iconTheme: IconThemeData(color: AppConstants.textColor),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
          fontFamily: 'Tajawal',
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
          fontFamily: 'Tajawal',
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppConstants.textColor,
          fontFamily: 'Tajawal',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppConstants.secondaryTextColor,
          fontFamily: 'Tajawal',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppConstants.secondaryTextColor,
          fontFamily: 'Tajawal',
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Tajawal',
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        color: Colors.white,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: AppConstants.primaryColor,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade300,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFFD4AF37),
      primaryColorDark: Color(0xFFB8860B),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFD4AF37),
        secondary: Color(0xFFFFD700),
        surface: Color(0xFF1E1E1E),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Color(0xFF121212),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'Tajawal',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Tajawal',
        ),
        displayMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Tajawal',
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Tajawal',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade300,
          fontFamily: 'Tajawal',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
          fontFamily: 'Tajawal',
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontFamily: 'Tajawal',
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        color: Color(0xFF1E1E1E),
        shadowColor: Colors.black.withValues(alpha:0.4),
        surfaceTintColor: Colors.transparent,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFD4AF37),
          foregroundColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        filled: true,
        fillColor: Color(0xFF2D2D2D),
        hintStyle: TextStyle(color: Colors.grey.shade500),
        labelStyle: TextStyle(color: Colors.grey.shade300),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFD4AF37),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade700,
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFD4AF37),
        foregroundColor: Colors.black,
        elevation: 6,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey.shade500,
        elevation: 4,
      ),
    );
  }

  // Custom decorations that work with both themes
  static BoxDecoration getCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black54 : Colors.black12,
          blurRadius: 8,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration getGradientDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [Color(0xFF2D2D2D), Color(0xFF404040), Color(0xFF5A5A5A)]
            : [Color(0xFF8B4513), Color(0xFFD2691E), Color(0xFFDEB887)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static BoxDecoration getGoldGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFB8860B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppConstants.textColor;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade300
        : AppConstants.secondaryTextColor;
  }
}