import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/localization/app_localizations.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.school,
                  label: context.tr('academy'),
                  index: 1,
                  isSelected: currentIndex == 1,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: Icons.photo_library,
                  label: context.tr('exhibitions'),
                  index: 2,
                  isSelected: currentIndex == 2,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              gradient: AppColors.virtualGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.people, size: 32, color: Colors.white),
              onPressed: () => onTabSelected(0),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.shopping_cart,
                  label: context.tr('store'),
                  index: 3,
                  isSelected: currentIndex == 3,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: Icons.message_outlined,
                  label: context.tr('messages'),
                  index: 4,
                  isSelected: currentIndex == 4,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected
                ? AppColors.getPrimaryColor(isDark)
                : AppColors.getSubtextColor(isDark),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Tajawal',
              color: isSelected
                  ? AppColors.getPrimaryColor(isDark)
                  : AppColors.getSubtextColor(isDark),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
