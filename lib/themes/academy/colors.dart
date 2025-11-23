// theme/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFB8860B);
  static const Color primaryDark = Color(0xFF8B6914);
  static const Color secondaryColor = Color(0xFF8B4513);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF5D4E37);
  static const Color backgroundMain = Color(0xFFFDF6E3);
  static const Color backgroundSecondary = Color(0xFFF5E6D3);
  static const Color white = Color(0xFFFFFFFF);
  
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

   static  Color getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'مبتدئ':
        return const Color(0xFF28a745);
      case 'متوسط':
        return const Color(0xFFffc107);
      case 'متقدم':
        return const Color(0xFFdc3545);
      default:
        return const Color(0xFFB8860B);
    }
  }
}