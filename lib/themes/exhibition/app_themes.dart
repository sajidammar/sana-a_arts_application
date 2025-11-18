import 'package:flutter/material.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart' show AppConstants;
import 'colors.dart';
import 'text_styles.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    hoverColor: Colors.grey[900],
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.primaryDark,
    colorScheme: ColorScheme.light(
      primary:  Color.fromARGB(255, 227, 170, 26),
      secondary: AppColors.secondaryColor,
      surface: Colors.white,
      error: AppColors.error,
      onPrimary: Colors.grey,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundMain,
    fontFamily: 'Tajawal',

    // Text Themes
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: 'Tajawal',
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: 'Tajawal',
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
        fontFamily: 'Tajawal',
      ),
      titleMedium: AppTextStyles.titleMedium,
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textSecondary,
        fontFamily: 'Tajawal',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        fontFamily: 'Tajawal',
      ),
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontFamily: 'Tajawal',
      ),
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'Tajawal',
      ),
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
      hintStyle: TextStyle(
        color: AppColors.textSecondary,
        fontFamily: 'Tajawal',
      ),
      labelStyle: TextStyle(
        color: AppColors.textSecondary,
        fontFamily: 'Tajawal',
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      color: AppColors.white,
      shadowColor: AppColors.lightGrey,
      surfaceTintColor: Colors.transparent,
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: AppColors.primaryColor),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.lightGrey,
      thickness: 1,
      space: 1,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.white,
      elevation: 4,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      elevation: 2,
    ),

    // Tab Bar Theme
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.textSecondary,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    ),

    // SnackBar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkGrey,
      contentTextStyle: TextStyle(
        color: AppColors.white,
        fontFamily: 'Tajawal',
      ),
      actionTextColor: AppColors.accentColor,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundSecondary,
      selectedColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: AppColors.textPrimary,
        fontFamily: 'Tajawal',
      ),
      secondaryLabelStyle: TextStyle(
        color: AppColors.white,
        fontFamily: 'Tajawal',
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      surface: Color(0xFF1E1E1E),
      error: AppColors.error,
      onPrimary: AppColors.black,
      onSecondary: AppColors.black,
      onSurface: AppColors.white,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Tajawal',

    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        fontFamily: 'Tajawal',
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        fontFamily: 'Tajawal',
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
        fontFamily: 'Tajawal',
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.grey,
        fontFamily: 'Tajawal',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.lightGrey,
        fontFamily: 'Tajawal',
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.lightGrey),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
        fontFamily: 'Tajawal',
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        fontFamily: 'Tajawal',
      ),
      iconTheme: IconThemeData(color: AppColors.white),
    ),

    cardTheme: CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      color: const Color(0xFF1E1E1E),
      shadowColor: AppColors.black.withOpacity(0.4),
      surfaceTintColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.black,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.darkGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.darkGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
      hintStyle: TextStyle(color: AppColors.grey),
      labelStyle: TextStyle(color: AppColors.lightGrey),
    ),

    // Icon Theme for Dark Mode
    iconTheme: IconThemeData(color: AppColors.primaryColor),

    // Divider Theme for Dark Mode
    dividerTheme: DividerThemeData(
      color: AppColors.darkGrey,
      thickness: 1,
      space: 1,
    ),

    // Floating Action Button Theme for Dark Mode
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.black,
      elevation: 6,
    ),

    // Bottom Navigation Bar Theme for Dark Mode
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      elevation: 4,
    ),

    // Dialog Theme for Dark Mode
    dialogTheme: DialogThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),

    // Tab Bar Theme for Dark Mode
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.grey,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),
    ),

    // SnackBar Theme for Dark Mode
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkGrey,
      contentTextStyle: TextStyle(
        color: AppColors.white,
        fontFamily: 'Tajawal',
      ),
      actionTextColor: AppColors.accentColor,
    ),

    // Chip Theme for Dark Mode
    chipTheme: ChipThemeData(
      backgroundColor: Color(0xFF2D2D2D),
      selectedColor: AppColors.primaryColor,
      labelStyle: TextStyle(color: AppColors.white, fontFamily: 'Tajawal'),
      secondaryLabelStyle: TextStyle(
        color: AppColors.black,
        fontFamily: 'Tajawal',
      ),
    ),
  );

  // Custom decorations that work with both themes
  static BoxDecoration getCardDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      boxShadow: [
        BoxShadow(
          color:
              isDark
                  ? AppColors.black.withValues(alpha: 0.4)
                  : AppColors.lightGrey,
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
      gradient:
          isDark
              ? LinearGradient(
                colors: [
                  Color(0xFF2D2D2D),
                  Color(0xFF404040),
                  Color(0xFF5A5A5A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              : AppColors.sunsetGradient,
    );
  }

  static BoxDecoration getGoldGradientDecoration() {
    return BoxDecoration(gradient: AppColors.goldGradient);
  }

  static BoxDecoration getVirtualGradientDecoration() {
    return BoxDecoration(gradient: AppColors.virtualGradient);
  }

  static BoxDecoration getRealityGradientDecoration() {
    return BoxDecoration(gradient: AppColors.realityGradient);
  }

  static BoxDecoration getOpenGradientDecoration() {
    return BoxDecoration(gradient: AppColors.openGradient);
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.white
        : AppColors.textPrimary;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.grey
        : AppColors.textSecondary;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF121212)
        : AppColors.backgroundMain;
  }

  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : AppColors.white;
  }

  // Semantic color getters
  static Color getSuccessColor(BuildContext context) {
    return AppColors.success;
  }

  static Color getWarningColor(BuildContext context) {
    return AppColors.warning;
  }

  static Color getErrorColor(BuildContext context) {
    return AppColors.error;
  }

  static Color getInfoColor(BuildContext context) {
    return AppColors.info;
  }

  // Border radius helper
  static BorderRadius getBorderRadius() {
    return BorderRadius.circular(AppConstants.defaultBorderRadius);
  }
}
