import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryColor = Color(0xFFB8860B);
  static const Color primaryDark = Color(0xFF8B6914);
  static const Color backgroundColor = Color(0xFFFDF6E3);
  static const Color textColor = Color(0xFF675550);
  static const Color secondaryTextColor = Color(0xFF5D4E37);
  static const Color accentColor = Color(0xFFF5E6D3);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimary = Color(0xFFD4AF37);
  static const Color darkAccent = Color(0xFFFFD700);

  // Sizes
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Strings
  static const String appName = 'فنون صنعاء';
  static const String appDescription = 'منصة فنون صنعاء التشكيلية';

  // Animations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Curve animationCurve = Curves.easeInOut;
}