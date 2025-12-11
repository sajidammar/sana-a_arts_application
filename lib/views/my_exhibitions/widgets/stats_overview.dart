import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'نظرة عامة على معارضي',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              // Adaptive Grid
              // Since we have fixed 6 items, we can try to fit them.

              return Wrap(
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  _buildStatItem('إجمالي المعارض', '12', isDark),
                  _buildStatItem('معارض نشطة', '3', isDark),
                  _buildStatItem('الأعمال المعروضة', '45', isDark),
                  _buildStatItem('إجمالي الزوار', '1,234', isDark),
                  _buildStatItem('أعمال مباعة', '8', isDark),
                  _buildStatItem('متوسط التقييم', '4.8', isDark),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    final containerColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF5E6D3);
    final primaryColor = const Color(0xFFB8860B);
    final labelColor = isDark ? Colors.grey[400] : const Color(0xFF5D4E37);

    return Container(
      constraints: const BoxConstraints(minWidth: 120),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
