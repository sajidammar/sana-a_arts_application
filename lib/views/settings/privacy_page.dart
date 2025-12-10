import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
          'الخصوصية والأمان',
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
          _buildPrivacyCard(
            isDark: isDark,
            icon: Icons.lock,
            title: 'سياسة الخصوصية',
            description: 'اطلع على كيفية جمع واستخدام بياناتك الشخصية',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildPrivacyCard(
            isDark: isDark,
            icon: Icons.security,
            title: 'الأمان',
            description: 'إدارة إعدادات الأمان وكلمة المرور',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildPrivacyCard(
            isDark: isDark,
            icon: Icons.visibility,
            title: 'من يمكنه رؤية ملفي الشخصي',
            description: 'تحكم في خصوصية ملفك الشخصي',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildPrivacyCard(
            isDark: isDark,
            icon: Icons.block,
            title: 'المستخدمون المحظورون',
            description: 'إدارة قائمة المستخدمين المحظورين',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildPrivacyCard(
            isDark: isDark,
            icon: Icons.delete_forever,
            title: 'حذف الحساب',
            description: 'حذف حسابك وجميع بياناتك بشكل دائم',
            onTap: () {
              _showDeleteAccountDialog(context, isDark);
            },
            color: Colors.red,
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
    required VoidCallback onTap,
    Color? color,
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
            color:
                (color ??
                        (isDark
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFFB8860B)))
                    .withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color:
                color ??
                (isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B)),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: color ?? (isDark ? Colors.white : Colors.black87),
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

  void _showDeleteAccountDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text(
          'تحذير',
          style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف حسابك؟\n\nسيؤدي ذلك إلى حذف جميع بياناتك بشكل دائم ولا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إلغاء حذف الحساب')),
              );
            },
            child: const Text(
              'حذف الحساب',
              style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
