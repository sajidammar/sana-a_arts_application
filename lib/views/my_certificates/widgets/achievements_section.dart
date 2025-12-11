import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);
    final bgSecondary = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF5E6D3);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Color(0xFFB8860B)),
              const SizedBox(width: 10),
              Text(
                'أحدث الإنجازات',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (context, constraints) {
              // Adaptive Grid
              int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
              double width =
                  (constraints.maxWidth - ((crossAxisCount - 1) * 10)) /
                  crossAxisCount;

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: width,
                    child: _buildAchievementItem(
                      'الفنان المتميز',
                      'ديسمبر 2024',
                      Icons.pages,
                      bgSecondary,
                      textColor,
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
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFF7931E),
                  Color(0xFFFFD700),
                ], // Sunset gradient
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
