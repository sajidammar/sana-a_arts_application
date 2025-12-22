import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../themes/academy/colors.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import '../settings/notifications_page.dart';
import '../settings/privacy_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final primaryColor = AppColors.getPrimaryColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subtextColor = AppColors.getSubtextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'الملف الشخصي',
              style: TextStyle(
                color: textColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDark ? AppColors.darkCard : Colors.white,
            foregroundColor: primaryColor,
            elevation: 0,
            pinned: true,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(color: primaryColor, width: 3),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'أحمد محمد',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'فنان تشكيلي',
                    style: TextStyle(
                      fontSize: 16,
                      color: subtextColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          '24',
                          'عمل فني',
                          primaryColor,
                          subtextColor,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: subtextColor.withValues(alpha: 0.2),
                        ),
                        _buildStatItem(
                          '5',
                          'معارض',
                          primaryColor,
                          subtextColor,
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: subtextColor.withValues(alpha: 0.2),
                        ),
                        _buildStatItem(
                          '156',
                          'متابع',
                          primaryColor,
                          subtextColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('معلومات الحساب', textColor),
                  _buildInfoCard(isDark, cardColor, textColor, subtextColor),
                  const SizedBox(height: 24),
                  _buildSectionTitle('الإعدادات', textColor),
                  _buildSettingsCard(
                    isDark,
                    cardColor,
                    textColor,
                    primaryColor,
                    context,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String number,
    String label,
    Color primaryColor,
    Color subtextColor,
  ) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: subtextColor,
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtextColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          _buildInfoRow(
            'البريد الإلكتروني',
            'ahmed@example.com',
            textColor,
            subtextColor,
            Icons.email_outlined,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'رقم الهاتف',
            '+967 123 456 789',
            textColor,
            subtextColor,
            Icons.phone_android_outlined,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'المدينة',
            'صنعاء',
            textColor,
            subtextColor,
            Icons.location_on_outlined,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'تاريخ الانضمام',
            'يناير 2024',
            textColor,
            subtextColor,
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String title,
    String value,
    Color textColor,
    Color subtextColor,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: subtextColor.withValues(alpha: 0.7)),
        const SizedBox(width: 12),
        Text(
          '$title: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: 'Tajawal',
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: subtextColor,
            fontFamily: 'Tajawal',
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color primaryColor,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
      child: Column(
        children: [
          _buildSettingItem(
            'تعديل الملف الشخصي',
            Icons.edit_outlined,
            isDark,
            primaryColor,
            textColor,
            context,
          ),
          _buildSettingItem(
            'تغيير كلمة المرور',
            Icons.lock_outline,
            isDark,
            primaryColor,
            textColor,
            context,
          ),
          _buildSettingItem(
            'الإشعارات',
            Icons.notifications_none_outlined,
            isDark,
            primaryColor,
            textColor,
            context,
          ),
          _buildSettingItem(
            'الخصوصية',
            Icons.security_outlined,
            isDark,
            primaryColor,
            textColor,
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    bool isDark,
    Color primaryColor,
    Color textColor,
    BuildContext context,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.3),
        size: 14,
      ),
      onTap: () {
        if (title == 'تعديل الملف الشخصي') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfilePage()),
          );
        } else if (title == 'تغيير كلمة المرور') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
          );
        } else if (title == 'الإشعارات') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
        } else if (title == 'الخصوصية') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyPage()),
          );
        }
      },
    );
  }
}
