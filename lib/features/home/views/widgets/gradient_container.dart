import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

/// حاوية بتدرج لوني تراثي
class HeritageGradientContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final bool useCardGradient;

  const HeritageGradientContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.useCardGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: _getGradientColors(isDark, useCardGradient),
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  List<Color> _getGradientColors(bool isDark, bool useCardGradient) {
    if (useCardGradient) {
      return isDark
          ? [AppColors.darkBackground, AppColors.darkCard]
          : [AppColors.white, AppColors.backgroundSecondary];
    } else {
      return isDark
          ? [AppColors.secondaryColor, AppColors.darkPrimary]
          : [AppColors.secondaryColor, AppColors.primaryColor];
    }
  }
}

/// نص تراثي يتكيف مع الوضع
class HeritageText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool isTitle;
  final bool useGoldColor;

  const HeritageText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.isTitle = false,
    this.useGoldColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    Color textColor;
    if (useGoldColor) {
      textColor = AppColors.starGold;
    } else if (isTitle) {
      textColor = AppColors.getPrimaryColor(isDark);
    } else {
      textColor = AppColors.getTextColor(isDark);
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: textColor,
        fontFamily: 'Tajawal',
      ),
      textAlign: textAlign,
    );
  }
}

/// زر تراثي بأناقة يمنية
class HeritageButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final EdgeInsetsGeometry? padding;

  const HeritageButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppColors.getPrimaryColor(isDark)
            : Colors.transparent,
        foregroundColor: isPrimary
            ? (isDark ? Colors.black : Colors.white)
            : AppColors.getPrimaryColor(isDark),
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: AppColors.getPrimaryColor(isDark), width: 2),
        ),
        elevation: isPrimary ? 4 : 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }
}




