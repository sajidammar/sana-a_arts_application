import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;
  bool _exhibitionUpdates = true;
  bool _orderUpdates = true;
  bool _promotions = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              'الإشعارات',
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
                _buildSection(
                  isDark: isDark,
                  title: 'طرق الإشعارات',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  children: [
                    _buildSwitchTile(
                      isDark,
                      'البريد الإلكتروني',
                      Icons.email_outlined,
                      _emailNotifications,
                      primaryColor,
                      textColor,
                      (value) {
                        setState(() => _emailNotifications = value);
                      },
                    ),
                    _buildSwitchTile(
                      isDark,
                      'إشعارات الدفع',
                      Icons.notifications_active_outlined,
                      _pushNotifications,
                      primaryColor,
                      textColor,
                      (value) {
                        setState(() => _pushNotifications = value);
                      },
                    ),
                    _buildSwitchTile(
                      isDark,
                      'الرسائل النصية',
                      Icons.sms_outlined,
                      _smsNotifications,
                      primaryColor,
                      textColor,
                      (value) {
                        setState(() => _smsNotifications = value);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  isDark: isDark,
                  title: 'أنواع الإشعارات',
                  primaryColor: primaryColor,
                  cardColor: cardColor,
                  textColor: textColor,
                  children: [
                    _buildSwitchTile(
                      isDark,
                      'تحديثات المعارض',
                      Icons.museum_outlined,
                      _exhibitionUpdates,
                      primaryColor,
                      textColor,
                      (value) {
                        setState(() => _exhibitionUpdates = value);
                      },
                    ),
                    _buildSwitchTile(
                      isDark,
                      'تحديثات الطلبات',
                      Icons.shopping_bag_outlined,
                      _orderUpdates,
                      primaryColor,
                      textColor,
                      (value) {
                        setState(() => _orderUpdates = value);
                      },
                    ),
                    _buildSwitchTile(
                      isDark,
                      'العروض الترويجية',
                      Icons.local_offer_outlined,
                      _promotions,
                      primaryColor,
                      textColor,
                      (value) {
                        setState(() => _promotions = value);
                      },
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required bool isDark,
    required String title,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    required List<Widget> children,
  }) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: primaryColor,
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    bool isDark,
    String title,
    IconData icon,
    bool value,
    Color primaryColor,
    Color textColor,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: primaryColor,
        activeTrackColor: primaryColor.withValues(alpha: 0.2),
      ),
    );
  }
}




