import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

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

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: const Text('الإشعارات', style: TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            isDark: isDark,
            title: 'طرق الإشعارات',
            children: [
              _buildSwitchTile(
                isDark,
                'البريد الإلكتروني',
                Icons.email,
                _emailNotifications,
                (value) {
                  setState(() => _emailNotifications = value);
                },
              ),
              _buildSwitchTile(
                isDark,
                'إشعارات الدفع',
                Icons.notifications_active,
                _pushNotifications,
                (value) {
                  setState(() => _pushNotifications = value);
                },
              ),
              _buildSwitchTile(
                isDark,
                'الرسائل النصية',
                Icons.sms,
                _smsNotifications,
                (value) {
                  setState(() => _smsNotifications = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            isDark: isDark,
            title: 'أنواع الإشعارات',
            children: [
              _buildSwitchTile(
                isDark,
                'تحديثات المعارض',
                Icons.museum,
                _exhibitionUpdates,
                (value) {
                  setState(() => _exhibitionUpdates = value);
                },
              ),
              _buildSwitchTile(
                isDark,
                'تحديثات الطلبات',
                Icons.shopping_bag,
                _orderUpdates,
                (value) {
                  setState(() => _orderUpdates = value);
                },
              ),
              _buildSwitchTile(
                isDark,
                'العروض الترويجية',
                Icons.local_offer,
                _promotions,
                (value) {
                  setState(() => _promotions = value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required bool isDark,
    required String title,
    required List<Widget> children,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: isDark
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFFB8860B),
              ),
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    bool isDark,
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
      ),
    );
  }
}
