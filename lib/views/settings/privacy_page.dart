import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../themes/app_colors.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);
    final subtextColor = AppColors.getSubtextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'الخصوصية والأمان',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            foregroundColor: primaryColor,
            elevation: 0,
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPrivacyCard(
                  isDark: isDark,
                  icon: Icons.lock_outline,
                  title: 'سياسة الخصوصية',
                  description: 'اطلع على كيفية جمع واستخدام بياناتك الشخصية',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildPrivacyCard(
                  isDark: isDark,
                  icon: Icons.security_outlined,
                  title: 'الأمان',
                  description: 'إدارة إعدادات الأمان وكلمة المرور',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildPrivacyCard(
                  isDark: isDark,
                  icon: Icons.visibility_outlined,
                  title: 'من يمكنه رؤية ملفي الشخصي',
                  description: 'تحكم في خصوصية ملفك الشخصي',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildPrivacyCard(
                  isDark: isDark,
                  icon: Icons.block_outlined,
                  title: 'المستخدمون المحظورون',
                  description: 'إدارة قائمة المستخدمين المحظورين',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildPrivacyCard(
                  isDark: isDark,
                  icon: Icons.delete_forever_outlined,
                  title: 'حذف الحساب',
                  description: 'حذف حسابك وجميع بياناتك بشكل دائم',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () {
                    _showDeleteAccountDialog(
                      context,
                      isDark,
                      primaryColor,
                      cardColor,
                      textColor,
                    );
                  },
                  color: Colors.red,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String description,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    required Color subtextColor,
    required VoidCallback onTap,
    Color? color,
  }) {
    final iconColor = color ?? primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
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
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: color ?? textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Tajawal',
              color: subtextColor.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: subtextColor.withValues(alpha: 0.3),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color cardColor,
    Color textColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text(
              'تحذير',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف حسابك؟\n\nسيؤدي ذلك إلى حذف جميع بياناتك بشكل دائم ولا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: textColor,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.getSubtextColor(isDark),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم إلغاء حذف الحساب',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text(
              'حذف الحساب',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
