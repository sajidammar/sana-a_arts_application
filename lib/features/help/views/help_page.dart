import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'المساعدة والدعم',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            backgroundColor: AppColors.getCardColor(isDark),
            foregroundColor: AppColors.getPrimaryColor(isDark),
            elevation: 2,
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                      const SnackBar(
                        content: Text(
                          'سيتم فتح الدردشة قريباً',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      ),
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
              ]),
            ),
          ),
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
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withValues(alpha: 0.1),
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
            color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.getPrimaryColor(isDark), size: 24),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: AppColors.getTextColor(isDark),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.5),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildContactInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.virtualGradient,
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




