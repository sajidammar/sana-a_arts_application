import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/academy/colors.dart';

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
  final VoidCallback onMyExhibitionsPressed;
  final VoidCallback onMyCertificatesPressed;

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
    required this.onMyExhibitionsPressed,
    required this.onMyCertificatesPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Drawer(
      width: 280,
      backgroundColor: AppColors.getBackgroundColor(isDark),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(isDark),
          _buildSectionHeader('الحساب', isDark),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'الملف الشخصي',
            onTap: onProfilePressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            title: 'طلباتي',
            onTap: onOrdersPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.palette,
            title: 'إدارة الأعمال الفنية',
            onTap: onArtworksManagementPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.filter_frames,
            title: 'معارضي',
            onTap: onMyExhibitionsPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.workspace_premium,
            title: 'الشهادات والإنجازات',
            onTap: onMyCertificatesPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: 'المفضلة',
            onTap: onWishlistPressed,
            isDark: isDark,
          ),
          _buildSectionHeader('الإعدادات', isDark),
          _buildDrawerItemWithSwitch(
            icon: Icons.dark_mode,
            title: 'الوضع الليلي',
            value: isDark,
            onChanged: (value) => onThemeChanged(),
            isDark: isDark,
          ),
          _buildDrawerItemWithTrailing(
            icon: Icons.language,
            title: 'اللغة',
            trailing: 'العربية',
            onTap: onLanguageChanged,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: 'الإشعارات',
            onTap: () {},
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.security,
            title: 'الخصوصية',
            onTap: onSettingsPressed,
            isDark: isDark,
          ),
          _buildSectionHeader('التطبيق', isDark),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'من نحن',
            onTap: onAboutPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.contact_mail,
            title: 'اتصل بنا',
            onTap: onContactPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.share,
            title: 'مشاركة التطبيق',
            onTap: onShareApp,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: 'المساعدة والدعم',
            onTap: onHelpPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.star,
            title: 'تقييم التطبيق',
            onTap: () {},
            isDark: isDark,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: 'تسجيل الخروج',
            color: Colors.red,
            onTap: onLogoutPressed,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(bool isDark) {
    return Container(
      height: 180,
      decoration: BoxDecoration(gradient: AppColors.virtualGradient),
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: 20,
            child: Icon(
              Icons.palette,
              size: 40,
              color: Colors.white.withValues(alpha: 0.3),
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
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
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
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'فنان تشكيلي',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
          color: AppColors.getPrimaryColor(isDark),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? AppColors.getPrimaryColor(isDark),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
          color: color ?? AppColors.getTextColor(isDark),
        ),
      ),
      trailing: color == null
          ? Icon(
              Icons.arrow_forward_ios,
              color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.5),
              size: 14,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDrawerItemWithTrailing({
    required IconData icon,
    required String title,
    required String trailing,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.getPrimaryColor(isDark), size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
          color: AppColors.getTextColor(isDark),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailing,
            style: TextStyle(
              color: AppColors.getSubtextColor(isDark),
              fontSize: 13,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.5),
            size: 14,
          ),
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
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.getPrimaryColor(isDark), size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
          color: AppColors.getTextColor(isDark),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.getPrimaryColor(isDark),
      ),
    );
  }
}
