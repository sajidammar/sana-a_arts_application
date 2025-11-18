import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../themes/store/theme_provider.dart';
import '../../../utils/store/app_constants.dart';


class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AnimatedContainer(
      duration: AppConstants.animationDuration,
      curve: AppConstants.animationCurve,
      width: 70,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isDark
            ? LinearGradient(
          colors: [Color(0xFF2D2D2D), Color(0xFF404040)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.orange.withValues(alpha:0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: AppConstants.animationDuration,
            curve: AppConstants.animationCurve,
            left: isDark ? 38 : 4,
            top: 2,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: AppConstants.animationDuration,
                child: isDark
                    ? Icon(
                  Icons.nightlight_round,
                  color: Color(0xFFD4AF37),
                  size: 18,
                  key: ValueKey('moon'),
                )
                    : Icon(
                  Icons.wb_sunny_rounded,
                  color: Color(0xFFFFA000),
                  size: 18,
                  key: ValueKey('sun'),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  themeProvider.toggleTheme(!isDark);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}