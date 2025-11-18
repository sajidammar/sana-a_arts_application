import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../themes/store/theme_provider.dart';
import '../../../utils/store/app_constants.dart';


class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 12),
              Text(
                'المظهر',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildThemeOption(
                context,
                theme: 'فاتح',
                isSelected: !isDark,
                icon: Icons.light_mode,
                onTap: () => themeProvider.toggleTheme(false),
              ),
              _buildThemeOption(
                context,
                theme: 'غامق',
                isSelected: isDark,
                icon: Icons.dark_mode,
                onTap: () => themeProvider.toggleTheme(true),
              ),
              _buildThemeOption(
                context,
                theme: 'تلقائي',
                isSelected: themeProvider.themeMode == ThemeMode.system,
                icon: Icons.auto_mode,
                onTap: () => themeProvider.setTheme(ThemeMode.system),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
      BuildContext context, {
        required String theme,
        required bool isSelected,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animationDuration,
        curve: AppConstants.animationCurve,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha:0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
              size: 24,
            ),
            SizedBox(height: 8),
            Text(
              theme,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}