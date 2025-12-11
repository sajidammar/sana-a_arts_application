import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme_provider.dart';

class SideDrawer extends StatelessWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onAboutPressed;
  final VoidCallback onContactPressed;
  final VoidCallback onLanguageChanged;
  final VoidCallback onThemeChanged;
  final VoidCallback onShareApp;
  final VoidCallback onSettingsPressed;
  final VoidCallback onHelpPressed;
  final VoidCallback onLogoutPressed;
  final VoidCallback onOrdersPressed;

  final VoidCallback onWishlistPressed;
  final VoidCallback onArtworksManagementPressed;

  const SideDrawer({
    super.key,
    required this.onProfilePressed,
    required this.onAboutPressed,
    required this.onContactPressed,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.onShareApp,
    required this.onSettingsPressed,
    required this.onHelpPressed,
    required this.onLogoutPressed,
    required this.onOrdersPressed,

    required this.onWishlistPressed,
    required this.onArtworksManagementPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      width: 280,
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildSectionHeader('الحساب'),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'الملف الشخصي',
            onTap: onProfilePressed,
          ),
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            title: 'طلباتي',
            onTap: onOrdersPressed,
          ),
          _buildDrawerItem(
            icon: Icons.palette,
            title: 'إدارة الأعمال الفنية',
            onTap: onArtworksManagementPressed,
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: 'المفضلة',
            onTap: onWishlistPressed,
          ),
          _buildSectionHeader('الإعدادات'),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildDrawerItemWithSwitch(
                icon: Icons.dark_mode,
                title: 'الوضع الليلي',
                value: themeProvider.isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(),
              );
            },
          ),
          _buildDrawerItemWithTrailing(
            icon: Icons.language,
            title: 'اللغة',
            trailing: 'العربية',
            onTap: onLanguageChanged,
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'الإشعارات',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.security,
            title: 'الخصوصية',
            onTap: onSettingsPressed,
          ),
          _buildSectionHeader('التطبيق'),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'من نحن',
            onTap: onAboutPressed,
          ),
          _buildDrawerItem(
            icon: Icons.contact_mail,
            title: 'اتصل بنا',
            onTap: onContactPressed,
          ),
          _buildDrawerItem(
            icon: Icons.share,
            title: 'مشاركة التطبيق',
            onTap: onShareApp,
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'المساعدة والدعم',
            onTap: onHelpPressed,
          ),
          _buildDrawerItem(
            icon: Icons.star,
            title: 'تقييم التطبيق',
            onTap: () {},
          ),
          const Spacer(),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: 'تسجيل الخروج',
            color: Colors.red,
            onTap: onLogoutPressed,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF8B4513), Color(0xFFB8860B)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Icon(
              Icons.palette,
              size: 40,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/image1.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'أحمد محمد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'فنان تشكيلي',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        'الحساب',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFB8860B),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFFB8860B), size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      trailing: color == null
          ? const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDrawerItemWithTrailing({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB8860B), size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildDrawerItemWithSwitch({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFB8860B), size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFB8860B),
      ),
    );
  }
}
