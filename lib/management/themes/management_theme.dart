import 'package:flutter/material.dart';
import 'management_colors.dart';

class ManagementTheme {
  static ThemeData getTheme(bool isDark) {
    return isDark ? darkTheme : lightTheme;
  }

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ManagementColors.primaryColor,
    scaffoldBackgroundColor: ManagementColors.backgroundLight,
    fontFamily: 'Tajawal',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ManagementColors.primaryColor),
      titleTextStyle: TextStyle(
        color: ManagementColors.primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: ManagementColors.primaryColor,
      secondary: ManagementColors.accentColor,
      surface: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ManagementColors.accentColor,
    scaffoldBackgroundColor: ManagementColors.backgroundDark,
    fontFamily: 'Tajawal',
    appBarTheme: const AppBarTheme(
      backgroundColor: ManagementColors.cardDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: ManagementColors.accentColor),
      titleTextStyle: TextStyle(
        color: ManagementColors.accentColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: ManagementColors.accentColor,
      secondary: ManagementColors.primaryColor,
      surface: ManagementColors.cardDark,
    ),
    cardTheme: CardThemeData(
      color: ManagementColors.cardDark,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

