import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: const Text(
          'المساعدة والدعم',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHelpCard(
            isDark: isDark,
            icon: Icons.question_answer,
            title: 'الأسئلة الشائعة',
            description: 'ابحث عن إجابات للأسئلة الأكثر شيوعاً',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            isDark: isDark,
            icon: Icons.chat,
            title: 'الدردشة المباشرة',
            description: 'تحدث مع فريق الدعم مباشرة',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('سيتم فتح الدردشة قريباً')),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            isDark: isDark,
            icon: Icons.email,
            title: 'إرسال رسالة',
            description: 'أرسل استفسارك عبر البريد الإلكتروني',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            isDark: isDark,
            icon: Icons.phone,
            title: 'الاتصال بنا',
            description: 'تواصل معنا عبر الهاتف',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildHelpCard(
            isDark: isDark,
            icon: Icons.bug_report,
            title: 'الإبلاغ عن مشكلة',
            description: 'أخبرنا عن أي مشاكل تواجهها',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildContactInfo(isDark),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B))
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Tajawal',
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.grey[600] : Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildContactInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B4513), Color(0xFFB8860B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الاتصال',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email, 'support@sanaaarts.com'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.phone, '+967 777 123 456'),
          const SizedBox(height: 8),
          _buildContactItem(Icons.location_on, 'صنعاء، اليمن'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Tajawal',
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
