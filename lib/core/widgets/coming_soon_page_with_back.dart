import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class ComingSoonPageWithBack extends StatelessWidget {
  final String featureName;
  final String? description;
  final IconData? icon;

  const ComingSoonPageWithBack({
    super.key,
    required this.featureName,
    this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.getPrimaryColor(isDark).withValues(alpha: 0.05),
              AppColors.getBackgroundColor(isDark),
              AppColors.getPrimaryColor(isDark).withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.getTextColor(isDark),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.getCardColor(isDark),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated icon
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 1000),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: 0.5 + (value * 0.5),
                              child: Opacity(
                                opacity: value,
                                child: Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.goldGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.getPrimaryColor(
                                          isDark,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    icon ?? Icons.construction_rounded,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 48),

                        // "Coming Soon" title
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: Text(
                                  'قريباً',
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tajawal',
                                    color: AppColors.getTextColor(isDark),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        // Feature name badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.getPrimaryColor(
                                  isDark,
                                ).withValues(alpha: 0.2),
                                AppColors.getPrimaryColor(
                                  isDark,
                                ).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColors.getPrimaryColor(
                                isDark,
                              ).withValues(alpha: 0.4),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            featureName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                              color: AppColors.getPrimaryColor(isDark),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Description
                        Container(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Text(
                            description ??
                                'هذه الميزة قيد التطوير والتحسين حالياً\nسيتم إطلاقها قريباً بإذن الله',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Tajawal',
                              color: AppColors.getSubtextColor(isDark),
                              height: 1.8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Decorative elements
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return TweenAnimationBuilder(
                              duration: Duration(
                                milliseconds: 1000 + (index * 200),
                              ),
                              tween: Tween<double>(begin: 0, end: 1),
                              builder: (context, double value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.getPrimaryColor(
                                        isDark,
                                      ).withValues(alpha: 0.3 + (value * 0.4)),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
