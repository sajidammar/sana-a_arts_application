import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle tajawal = TextStyle(
    fontFamily: 'Tajawal',
    height: 1.5,
  );

  static TextStyle heroTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 42, 32, 28),
      fontWeight: FontWeight.w900,
      color: Colors.white,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  static TextStyle heroSubtitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 20, 18, 16),
      fontWeight: FontWeight.w400,
      color: Colors.white.withValues(alpha: 0.9),
      height: 1.4,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 32, 28, 24),
      fontWeight: FontWeight.w800,
      color: AppColors.getPrimaryColor(isDark),
      height: 1.3,
    );
  }

  static TextStyle sectionDescription(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 14),
      fontWeight: FontWeight.w400,
      color: AppColors.getSubtextColor(isDark),
      height: 1.6,
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 20, 18, 16),
      fontWeight: FontWeight.w700,
      color: AppColors.getTextColor(isDark),
      height: 1.4,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 14),
      fontWeight: FontWeight.w400,
      color: AppColors.getSubtextColor(isDark),
      height: 1.6,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w400,
      color: AppColors.getSubtextColor(isDark),
      height: 1.5,
    );
  }

  static double _getResponsiveFontSize(
    BuildContext context,
    double desktop,
    double tablet,
    double mobile,
  ) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return desktop;
    if (width > 768) return tablet;
    return mobile;
  }

  // Compatibility with exhibition legacy styles
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: 'Tajawal',
  );
}
