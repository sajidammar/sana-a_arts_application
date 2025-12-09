import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/app_colos.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: _getGradientColors(themeProvider.isDarkMode, useCardGradient),
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

  List<Color> _getGradientColors(bool isDarkMode, bool useCardGradient) {
    if (useCardGradient) {
      return isDarkMode
          ? [const Color(0xFF1E1E1E), const Color(0xFF2D2D2D)]
          : [const Color(0xFFFFFFFF), const Color(0xFFF5E6D3)];
    } else {
      return isDarkMode
          ? [const Color(0xFF8B4513), const Color(0xFFD4AF37)]
          : [const Color(0xFF8B4513), const Color(0xFFB8860B)];
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    Color textColor;
    if (useGoldColor) {
      textColor = const Color(0xFFD4AF37); // ذهبي ثابت
    } else if (isTitle) {
      textColor = AppColors.getPrimaryColor(themeProvider.isDarkMode);
    } else {
      textColor = AppColors.getTextPrimaryColor(themeProvider.isDarkMode);
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: textColor,
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppColors.getPrimaryColor(themeProvider.isDarkMode)
            : Colors.transparent,
        foregroundColor: isPrimary
            ? (themeProvider.isDarkMode ? Colors.black : Colors.white)
            : AppColors.getPrimaryColor(themeProvider.isDarkMode),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary
              ? BorderSide.none
              : BorderSide(color: AppColors.getPrimaryColor(themeProvider.isDarkMode), width: 2),
        ),
        elevation: 4,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isPrimary
              ? (themeProvider.isDarkMode ? Colors.black : Colors.white)
              : AppColors.getPrimaryColor(themeProvider.isDarkMode),
        ),
      ),
    );
  }
}