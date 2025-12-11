import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import '../settings/notifications_page.dart';
import '../settings/privacy_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'الملف الشخصي',
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
            pinned: true,
            floating: true,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: themeProvider.isDarkMode
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFFB8860B),
                        width: 3,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/image1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أحمد محمد',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.isDarkMode
                          ? Colors.white
                          : const Color(0xFF2C1810),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'فنان تشكيلي',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeProvider.isDarkMode
                          ? Colors.grey[400]
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? const Color(0xFF1E1E1E)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          '24',
                          'عمل فني',
                          themeProvider.isDarkMode,
                        ),
                        _buildStatItem('5', 'معارض', themeProvider.isDarkMode),
                        _buildStatItem(
                          '156',
                          'متابع',
                          themeProvider.isDarkMode,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(themeProvider.isDarkMode),
                  const SizedBox(height: 16),
                  _buildSettingsCard(themeProvider.isDarkMode, context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, bool isDarkMode) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Card(
      elevation: 2,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'معلومات الحساب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF2C1810),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('البريد الإلكتروني', 'ahmed@example.com', isDarkMode),
            _buildInfoRow('رقم الهاتف', '+967 123 456 789', isDarkMode),
            _buildInfoRow('المدينة', 'صنعاء', isDarkMode),
            _buildInfoRow('تاريخ الانضمام', 'يناير 2024', isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF2C1810),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(bool isDarkMode, BuildContext context) {
    return Card(
      elevation: 2,
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعدادات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF2C1810),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              'تعديل الملف الشخصي',
              Icons.edit,
              isDarkMode,
              context,
            ),
            _buildSettingItem(
              'تغيير كلمة المرور',
              Icons.lock,
              isDarkMode,
              context,
            ),
            _buildSettingItem(
              'الإشعارات',
              Icons.notifications,
              isDarkMode,
              context,
            ),
            _buildSettingItem('الخصوصية', Icons.security, isDarkMode, context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    bool isDarkMode,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : const Color(0xFF2C1810),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isDarkMode ? const Color(0xFFD4AF37) : Colors.grey,
        size: 16,
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
