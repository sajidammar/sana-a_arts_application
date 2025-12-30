import 'package:flutter/material.dart';

class ManagementColors {
  // Primary Management Colors (Deep Royal Blue / Gold for Premium feel)
  static const Color primaryColor = Color(0xFF1E3A8A); // Royal Blue
  static const Color accentColor = Color(0xFFD4AF37); // Gold
  static const Color secondaryColor = Color(0xFF0F172A); // Slate Dark

  // Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);

  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E293B);

  // Text
  static const Color textLight = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF8FAFC);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static LinearGradient adminGradient = const LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getPrimary(bool isDark) => isDark ? accentColor : primaryColor;
  static Color getBackground(bool isDark) =>
      isDark ? backgroundDark : backgroundLight;
  static Color getCard(bool isDark) => isDark ? cardDark : cardLight;
  static Color getText(bool isDark) => isDark ? textDark : textLight;
}
