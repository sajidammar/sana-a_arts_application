// theme/text_styles.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // الخط الأساسي - Tajawal فقط
  static const TextStyle tajawal = TextStyle(
    fontFamily: 'Tajawal',
    height: 1.5,
  );

  // أنماط النص الرئيسية
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
      color: Colors.white.withOpacity(0.9),
      height: 1.4,
    );
  }

  static TextStyle sectionTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 32, 28, 24),
      fontWeight: FontWeight.w800,
      color: AppColors.primaryColor,
      height: 1.3,
    );
  }

  static TextStyle sectionDescription(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 14),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.6,
    );
  }

  static TextStyle cardTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 20, 18, 16),
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.4,
    );
  }

  static TextStyle cardSubtitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor,
      height: 1.4,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 14),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.6,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle buttonLarge(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 14),
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }

  static TextStyle buttonMedium(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.3,
    );
  }

  static TextStyle buttonSmall(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.2,
    );
  }

  static TextStyle priceLarge(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 24, 20, 18),
      fontWeight: FontWeight.w800,
      color: AppColors.primaryColor,
    );
  }

  static TextStyle priceMedium(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 20, 18, 16),
      fontWeight: FontWeight.w700,
      color: AppColors.primaryColor,
    );
  }

  static TextStyle discountText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle badgeText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 12, 11, 10),
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.5,
    );
  }

  static TextStyle inputLabel(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle inputText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
    );
  }

  static TextStyle errorText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w500,
      color: Colors.red,
      height: 1.3,
    );
  }

  static TextStyle successText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w500,
      color: Colors.green,
      height: 1.3,
    );
  }

  static TextStyle linkText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor,
      decoration: TextDecoration.underline,
      height: 1.4,
    );
  }

  // دالة مساعدة للخطوط المتجاوبة
  static double _getResponsiveFontSize(BuildContext context, double desktop, double tablet, double mobile) {
    final width = MediaQuery.of(context).size.width;
    
    if (width > 1200) {
      return desktop;
    } else if (width > 768) {
      return tablet;
    } else {
      return mobile;
    }
  }

  // أنماط خاصة بالمكونات
  static TextStyle navItem(BuildContext context, {bool isActive = false}) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
      color: isActive ? Colors.white : AppColors.textPrimary,
      letterSpacing: 0.3,
    );
  }

  static TextStyle quickNavTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w700,
      color: AppColors.primaryColor,
      height: 1.3,
    );
  }

  static TextStyle quickNavDescription(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 12, 11, 10),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.4,
    );
  }

  static TextStyle categoryTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 20, 18, 16),
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle categoryDescription(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  static TextStyle workshopTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 15),
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle workshopInstructor(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor,
      height: 1.3,
    );
  }

  static TextStyle workshopDescription(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.5,
    );
  }

  static TextStyle instructorName(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 18, 16, 15),
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
      height: 1.3,
    );
  }

  static TextStyle instructorSpecialty(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: AppColors.primaryColor,
      height: 1.3,
    );
  }

  static TextStyle modalTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 24, 20, 18),
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.3,
    );
  }

  static TextStyle modalSubtitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w400,
      color: Colors.white.withOpacity(0.9),
      height: 1.4,
    );
  }

  // أنماط للتأثيرات الخاصة
  static TextStyle gradientText(BuildContext context, {required TextStyle baseStyle}) {
    return baseStyle.copyWith(
      foreground: Paint()
        ..shader = AppColors.goldGradient.createShader(
          const Rect.fromLTWH(0, 0, 200, 50),
        ),
    );
  }

  static TextStyle shadowText(BuildContext context, {required TextStyle baseStyle}) {
    return baseStyle.copyWith(
      shadows: [
        Shadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(2, 2),
        ),
      ],
    );
  }

  // أنماط للحالات المختلفة
  static TextStyle loadingText(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor,
    );
  }

  static TextStyle emptyStateTitle(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 24, 20, 18),
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary.withOpacity(0.7),
      height: 1.3,
    );
  }

  static TextStyle emptyStateDescription(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 16, 14, 13),
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary.withOpacity(0.6),
      height: 1.5,
    );
  }

  // أنماط للإشعارات
  static TextStyle notificationSuccess(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle notificationError(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle notificationWarning(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }

  static TextStyle notificationInfo(BuildContext context) {
    return tajawal.copyWith(
      fontSize: _getResponsiveFontSize(context, 14, 13, 12),
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
  }
}