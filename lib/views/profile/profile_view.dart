import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFB8860B),
                  ],
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
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
                  _buildStatItem('24', 'عمل فني', themeProvider.isDarkMode),
                  _buildStatItem('5', 'معارض', themeProvider.isDarkMode),
                  _buildStatItem('156', 'متابع', themeProvider.isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(themeProvider.isDarkMode),
            const SizedBox(height: 16),
            _buildSettingsCard(themeProvider.isDarkMode),
          ],
        ),
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
            color: isDarkMode ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
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

  Widget _buildSettingsCard(bool isDarkMode) {
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
            _buildSettingItem('تعديل الملف الشخصي', Icons.edit, isDarkMode),
            _buildSettingItem('تغيير كلمة المرور', Icons.lock, isDarkMode),
            _buildSettingItem('الإشعارات', Icons.notifications, isDarkMode),
            _buildSettingItem('الخصوصية', Icons.security, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, bool isDarkMode) {
    return ListTile(
      leading: Icon(
          icon,
          color: isDarkMode ? const Color(0xFFD4AF37) : const Color(0xFFB8860B)
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
      onTap: () {},
    );
  }
}