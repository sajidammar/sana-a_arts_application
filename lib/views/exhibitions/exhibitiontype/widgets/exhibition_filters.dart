import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';

class ExhibitionFilters extends StatelessWidget {
  final AnimationController animationController;

  const ExhibitionFilters({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Consumer<ExhibitionProvider>(
      builder: (context, provider, child) {
        return SlideInAnimation(
          delay: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getCardColor(isDark),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColors.getTextColor(isDark).withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تصفية المعارض',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextColor(isDark),
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildFilterChip(
                      'جميع المعارض',
                      ExhibitionType.virtual,
                      provider,
                      context,
                    ),
                    _buildFilterChip(
                      'افتراضي',
                      ExhibitionType.virtual,
                      provider,
                      context,
                    ),
                    _buildFilterChip(
                      'مفتوح',
                      ExhibitionType.open,
                      provider,
                      context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    ExhibitionType type,
    ExhibitionProvider provider,
    BuildContext context,
  ) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final isSelected =
        provider.currentFilter == type ||
        (label == 'جميع المعارض' &&
            provider.currentFilter == ExhibitionType.virtual);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected
              ? AppColors.getCardColor(isDark)
              : AppColors.getTextColor(isDark),
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (label == 'جميع المعارض') {
          provider.setFilter(ExhibitionType.virtual);
        } else {
          provider.setFilter(type);
        }
      },
      backgroundColor: AppColors.getCardColor(isDark).withValues(alpha: 0.1),
      selectedColor: AppColors.getPrimaryColor(isDark),
      checkmarkColor: AppColors.getCardColor(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AppColors.getPrimaryColor(isDark)
              : AppColors.getPrimaryColor(isDark).withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
