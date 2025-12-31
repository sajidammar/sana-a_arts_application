import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class CertificatesStatsGrid extends StatelessWidget {
  const CertificatesStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive Grid count
        int crossAxisCount = constraints.maxWidth > 700 ? 4 : 2;
        double width =
            (constraints.maxWidth - ((crossAxisCount - 1) * 20)) /
            crossAxisCount;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            SizedBox(
              width: width,
              child: _buildStatCard(
                'إجمالي الشهادات',
                '8',
                Icons.card_membership,
                isDark,
              ),
            ),
            SizedBox(
              width: width,
              child: _buildStatCard(
                'شهادات مكتملة',
                '5',
                Icons.verified,
                isDark,
              ),
            ),
            SizedBox(
              width: width,
              child: _buildStatCard(
                'قيد التقدم',
                '2',
                Icons.hourglass_top,
                isDark,
              ),
            ),
            SizedBox(
              width: width,
              child: _buildStatCard('متوسط الدرجات', '92%', Icons.star, isDark),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.learningGradient,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w800,
              color: AppColors.getPrimaryColor(isDark),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}




