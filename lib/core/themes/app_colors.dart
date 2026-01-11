import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFFB8860B);
  static const Color primaryDark = Color(0xFF8B6914);
  static const Color secondaryColor = Color(0xFF8B4513);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color starGold = Color(0xFFFFD700);

  // Auth Colors (from new Authentication module)
  static const Color authPrimary = Color(0xFFF57C00); // orange.shade700
  static const Color authSecondary = Color(0xFFFFB74D); // orange.shade300

  // Text Colors
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF5D4E37);

  // Background Colors - Light Mode
  static const Color backgroundMain = Color(0xFFFDF6E3);
  static const Color backgroundSecondary = Color(0xFFF5E6D3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);
  static const Color black = Color(0xFF000000);

  // Background Colors - Dark Mode
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkPrimary = Color(0xFFD4AF37);

  // Status Colors
  static const Color openColor = Color(0xFF38ef7d);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Module Specific Colors
  static const Color exhibitionColor = Color(0xFFFF6D8E);
  static const Color storeColor = Color(0xFF4CAF50);
  static const Color communityColor = Color(0xFF2196F3);
  static const Color profileColor = Color(0xFF9C27B0);

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

  static const LinearGradient virtualGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFD4AF37), Color(0xFFB8860B)],
  );

  static const LinearGradient openGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38ef7d), Color(0xFF11998e)],
  );

  static const LinearGradient exhibitionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFff9a9e), Color(0xFFfecfef)],
  );

  static const LinearGradient storeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
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
      isDark ? const Color(0xFF121212) : backgroundMain;
  static Color getCardColor(bool isDark) => isDark ? darkCard : white;
  static Color getTextColor(bool isDark) => isDark ? white : textPrimary;
  static Color getSubtextColor(bool isDark) =>
      isDark ? const Color(0xFFB0B0B0) : textSecondary;
  static Color getSurfaceColor(bool isDark) =>
      isDark ? const Color(0xFF1E1E1E) : backgroundSecondary;
}
