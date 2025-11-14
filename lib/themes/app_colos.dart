import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية - الوضع النهاري
  static const lightPrimary = Color(0xFFB8860B);
  static const lightPrimaryDark = Color(0xFF8B6914);
  static const lightBackground = Color(0xFFFDF6E3);
  static const lightTextPrimary = Color(0xFF2C1810);
  static const lightTextSecondary = Color(0xFF5D4E37);
  static const lightSurface = Color(0xFFF5E6D3);
  static const lightCard = Color(0xFFFFFFFF);

  // الألوان الأساسية - الوضع الليلي
  static const darkPrimary = Color(0xFFD4AF37);
  static const darkPrimaryDark = Color(0xFFB8860B);
  static const darkBackground = Color(0xFF121212);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFB0B0B0);
  static const darkCard = Color(0xFF1E1E1E);
  static const darkSurface = Color(0xFF2D2D2D);

  // وظائف مساعدة
  static Color getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? darkBackground : lightBackground;
  }

  static Color getSurfaceColor(bool isDarkMode) {
    return isDarkMode ? darkSurface : lightSurface;
  }

  static Color getCardColor(bool isDarkMode) {
    return isDarkMode ? darkCard : lightCard;
  }

  static Color getPrimaryColor(bool isDarkMode) {
    return isDarkMode ? darkPrimary : lightPrimary;
  }

  static Color getTextPrimaryColor(bool isDarkMode) {
    return isDarkMode ? darkTextPrimary : lightTextPrimary;
  }

  static Color getTextSecondaryColor(bool isDarkMode) {
    return isDarkMode ? darkTextSecondary : lightTextSecondary;
  }
}