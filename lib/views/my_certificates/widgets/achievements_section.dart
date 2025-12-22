import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/app_colors.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = AppColors.getTextColor(isDark);
    final surfaceColor = AppColors.getCardColor(isDark);
    final bgSecondary = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : AppColors.backgroundSecondary.withValues(alpha: 0.5);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.emoji_events,
                  color: AppColors.getPrimaryColor(isDark),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'أحدث الإنجازات',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              // Adaptive Grid
              int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              double width =
                  (constraints.maxWidth - ((crossAxisCount - 1) * 12)) /
                  crossAxisCount;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: width,
                    child: _buildAchievementItem(
                      'الفنان المتميز',
                      'ديسمبر 2024',
                      Icons.star,
                      bgSecondary,
                      textColor,
                      isDark,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _buildAchievementItem(
                      'خبير الرسم الزيتي',
                      'نوفمبر 2024',
                      Icons.brush,
                      bgSecondary,
                      textColor,
                      isDark,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _buildAchievementItem(
                      'مدرب معتمد',
                      'أكتوبر 2024',
                      Icons.school,
                      bgSecondary,
                      textColor,
                      isDark,
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _buildAchievementItem(
                      'متخصص التراث',
                      'سبتمبر 2024',
                      Icons.palette,
                      bgSecondary,
                      textColor,
                      isDark,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    String name,
    String date,
    IconData icon,
    Color bg,
    Color textColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.sunsetGradient,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B35).withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: AppColors.getSubtextColor(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
