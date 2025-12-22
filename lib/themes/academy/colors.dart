// theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFFB8860B);
  static const Color primaryDark = Color(0xFF8B6914);
  static const Color secondaryColor = Color(0xFF8B4513);
  static const Color accentColor = Color(0xFFFF6B35);

  // Text Colors
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF5D4E37);

  // Background Colors - Light Mode
  static const Color backgroundMain = Color(0xFFFDF6E3);
  static const Color backgroundSecondary = Color(0xFFF5E6D3);
  static const Color white = Color(0xFFFFFFFF);

  // Background Colors - Dark Mode
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkPrimary = Color(0xFFD4AF37);

  // Special Colors
  static const Color starGold = Color(0xFFFFD700);

  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFB8860B), Color(0xFF8B6914)],
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFF7931E), Color(0xFFFFD700)],
  );

  static const LinearGradient learningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );

  // Helper Methods
  static Color getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'مبتدئ':
        return const Color(0xFF28a745);
      case 'متوسط':
        return const Color(0xFFffc107);
      case 'متقدم':
        return const Color(0xFFdc3545);
      default:
        return primaryColor;
    }
  }

  // Theme-aware color getters
  static Color getPrimaryColor(bool isDark) =>
      isDark ? darkPrimary : primaryColor;
  static Color getBackgroundColor(bool isDark) =>
      isDark ? darkBackground : backgroundMain;
  static Color getCardColor(bool isDark) => isDark ? darkCard : white;
  static Color getTextColor(bool isDark) => isDark ? white : textPrimary;
  static Color getSubtextColor(bool isDark) =>
      isDark ? const Color(0xFFB0B0B0) : textSecondary;
}
