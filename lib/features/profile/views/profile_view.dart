import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/profile/views/profile_header.dart';

import 'package:sanaa_artl/features/profile/views/user_editing.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'edit_profile_page.dart';
// import 'change_password_page.dart';
// import '../settings/notifications_page.dart';
// import '../settings/privacy_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  File? selectedImage;

  String get firstLetter {
    final text = nameController.text.trim();
    if (text.isEmpty) return '?';
    return text.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final primaryColor = AppColors.getPrimaryColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    // final subtextColor = AppColors.getSubtextColor(isDark);
    // final cardColor = AppColors.getCardColor(isDark);

    final user = context.watch<UserProvider1>().user;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(
              name: user.name,
              imageUrl: user.imageUrl,
              bio: user.bio,
              followers: 256,
              following: 124,
              posts: 102,
              isDark: isDark,
              primaryColor: primaryColor,
              textColor: textColor,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.getCardColor(isDark) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Text(
                      'تعديل الملف الشخصي',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.edit, color: primaryColor, size: 24),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
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
*/

  /*
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
*/

  /*
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
*/

  /*
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
*/

  /*
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
*/
}
