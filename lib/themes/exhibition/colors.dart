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
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF424242);
  
  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradients
  static const Gradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFB8860B), Color(0xFF8B6914)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient virtualGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient realityGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient openGradient = LinearGradient(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFF7931E), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}