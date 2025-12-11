import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class CertificatesStatsGrid extends StatelessWidget {
  const CertificatesStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

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
    // Gradient mock for icon bg
    const gradient = LinearGradient(
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

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
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w800,
              color: Color(0xFFB8860B),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Tajawal',
              color: isDark ? Colors.grey[400] : const Color(0xFF5D4E37),
            ),
          ),
        ],
      ),
    );
  }
}
