import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: Text(
          'من نحن',
          style: TextStyle(
            color: themeProvider.isDarkMode
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
          ),
        ),
        backgroundColor: themeProvider.isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        foregroundColor: themeProvider.isDarkMode
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFB8860B),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.palette,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'منصة فنون صنعاء التشكيلية',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkMode
                    ? Colors.white
                    : const Color(0xFF2C1810),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'من صنعاء إلى كل أركان اليمن... ومن اليمن إلى العالم',
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkMode
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildSection(
              'رؤيتنا',
              'أن نكون المنصة الرائدة في دعم وتطوير الفنون التشكيلية اليمنية، ونشرها محلياً وعالمياً.',
              Icons.visibility,
              themeProvider.isDarkMode,
            ),
            _buildSection(
              'رسالتنا',
              'تمكين الفنانين اليمنيين من عرض إبداعاتهم، وتوفير بيئة حاضنة للإبداع الفني، وربط الفنانين بالجمهور والمهتمين بالفنون.',
              Icons.message,
              themeProvider.isDarkMode,
            ),
            _buildSection(
              'أهدافنا',
              '• دعم الفنانين اليمنيين وتطوير مهاراتهم\n• نشر الفن اليمني عالمياً\n• حفظ التراث الفني اليمني\n• بناء مجتمع فني متكامل',
              Icons.flag,
              themeProvider.isDarkMode,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF8B4513),
                    Color(0xFFB8860B),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('150+', 'فنان'),
                  _buildStatItem('500+', 'عمل فني'),
                  _buildStatItem('50+', 'معرض'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                  icon,
                  color: isDarkMode ? const Color(0xFFD4AF37) : const Color(0xFFB8860B)
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : const Color(0xFF2C1810),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}