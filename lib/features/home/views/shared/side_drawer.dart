import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/localization/app_localizations.dart';
import 'package:sanaa_artl/core/localization/language_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

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
  final VoidCallback onAdminPressed;

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
    required this.onAdminPressed,
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
          _buildSectionHeader(context.tr('account'), isDark),
          _buildDrawerItem(
            icon: Icons.person,
            title: context.tr('profile'),
            onTap: onProfilePressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.shopping_bag,
            title: context.tr('order_history'),
            onTap: onOrdersPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.palette,
            title: context.tr('artworks_management'),
            onTap: onArtworksManagementPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.filter_frames,
            title: context.tr('my_exhibitions'),
            onTap: onMyExhibitionsPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.workspace_premium,
            title: context.tr('certificates'),
            onTap: onMyCertificatesPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.favorite,
            title: context.tr('favorites'),
            onTap: onWishlistPressed,
            isDark: isDark,
          ),
          _buildSectionHeader(context.tr('settings'), isDark),
          _buildDrawerItemWithTrailing(
            icon: Icons.brightness_6_outlined,
            title: context.tr('theme'),
            trailing: _getThemeModeName(
              context.watch<ThemeProvider>().themeMode,
            ),
            onTap: () => _showThemeDialog(context),
            isDark: isDark,
          ),
          _buildDrawerItemWithTrailing(
            icon: Icons.language,
            title: context.tr('language'),
            trailing: context.watch<LanguageProvider>().languageName,
            onTap: () => _showLanguageDialog(context),
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.notifications,
            title: context.tr('notifications'),
            onTap: () {},
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.security,
            title: context.tr('privacy'),
            onTap: onSettingsPressed,
            isDark: isDark,
          ),
          _buildSectionHeader(context.tr('app'), isDark),
          _buildDrawerItem(
            icon: Icons.info,
            title: context.tr('about_us'),
            onTap: onAboutPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.contact_mail,
            title: context.tr('contact_us'),
            onTap: onContactPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.share,
            title: context.tr('share_app'),
            onTap: onShareApp,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.help,
            title: context.tr('help_support'),
            onTap: onHelpPressed,
            isDark: isDark,
          ),
          _buildDrawerItem(
            icon: Icons.star,
            title: context.tr('rate_app'),
            onTap: () {},
            isDark: isDark,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.admin_panel_settings,
            title: context.tr('admin_panel'),
            onTap: onAdminPressed,
            isDark: isDark,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            title: context.tr('logout'),
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

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'تلقائي (النظام)';
      case ThemeMode.light:
        return 'نهاري';
      case ThemeMode.dark:
        return 'ليلي';
    }
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardColor(isDark),
        title: Text(
          'اختر مظهر التطبيق',
          style: TextStyle(
            color: AppColors.getTextColor(isDark),
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              'تلقائي (حسب النظام)',
              ThemeMode.system,
              themeProvider.themeMode == ThemeMode.system,
              isDark,
            ),
            _buildThemeOption(
              context,
              'الوضع النهاري',
              ThemeMode.light,
              themeProvider.themeMode == ThemeMode.light,
              isDark,
            ),
            _buildThemeOption(
              context,
              'الوضع الليلي',
              ThemeMode.dark,
              themeProvider.themeMode == ThemeMode.dark,
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    ThemeMode mode,
    bool isSelected,
    bool isDark,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.getTextColor(isDark),
          fontFamily: 'Tajawal',
        ),
        textAlign: TextAlign.right,
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.getPrimaryColor(isDark))
          : null,
      onTap: () {
        Provider.of<ThemeProvider>(context, listen: false).setThemeMode(mode);
        Navigator.pop(context);
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final isDark = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardColor(isDark),
        title: Text(
          context.tr('language'),
          style: TextStyle(
            color: AppColors.getTextColor(isDark),
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              'تلقائي (حسب النظام)',
              'system',
              languageProvider.locale == null,
              isDark,
            ),
            _buildLanguageOption(
              context,
              'العربية',
              'ar',
              languageProvider.locale?.languageCode == 'ar',
              isDark,
            ),
            _buildLanguageOption(
              context,
              'English',
              'en',
              languageProvider.locale?.languageCode == 'en',
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String title,
    String langCode,
    bool isSelected,
    bool isDark,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.getTextColor(isDark),
          fontFamily: 'Tajawal',
        ),
        textAlign: langCode == 'en' ? TextAlign.left : TextAlign.right,
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: AppColors.getPrimaryColor(isDark))
          : null,
      onTap: () {
        if (langCode == 'system') {
          Provider.of<LanguageProvider>(
            context,
            listen: false,
          ).useSystemLanguage();
        } else {
          Provider.of<LanguageProvider>(
            context,
            listen: false,
          ).setLanguage(langCode);
        }
        Navigator.pop(context);
      },
    );
  }
}
