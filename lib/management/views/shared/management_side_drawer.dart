import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/management_provider.dart';
import '../../themes/management_colors.dart';

class ManagementSideDrawer extends StatelessWidget {
  const ManagementSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ManagementProvider>(context);
    final isDark = provider.isDarkMode;

    return Drawer(
      backgroundColor: ManagementColors.getBackground(isDark),
      child: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'لوحة التحكم',
                  index: 0,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.school,
                  title: 'إدارة الأكاديمية',
                  index: 1,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.photo_library,
                  title: 'إدارة المعارض',
                  index: 2,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.shopping_bag,
                  title: 'إدارة المتجر',
                  index: 3,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.people,
                  title: 'إدارة المستخدمين',
                  index: 4,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.notifications_active,
                  title: 'إدارة الإشعارات',
                  index: 5,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.forum,
                  title: 'إدارة المجتمع',
                  index: 6,
                  isDark: isDark,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.report_gmailerrorred,
                  title: 'إدارة البلاغات',
                  index: 7,
                  isDark: isDark,
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: ManagementColors.getPrimary(isDark),
                  ),
                  title: Text(
                    isDark ? 'الوضع النهاري' : 'الوضع الليلي',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: ManagementColors.getText(isDark),
                    ),
                  ),
                  onTap: () => provider.toggleTheme(),
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.red),
                  title: const Text(
                    'العودة للتطبيق الرئيسي',
                    style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
                  ),
                  onTap: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(gradient: ManagementColors.adminGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.admin_panel_settings,
              size: 40,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'نظام الإدارة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            'مدير المنصة',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required bool isDark,
  }) {
    final provider = Provider.of<ManagementProvider>(context, listen: false);
    final isSelected = provider.currentDashboardIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? ManagementColors.getPrimary(isDark) : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? ManagementColors.getPrimary(isDark)
              : ManagementColors.getText(isDark),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Tajawal',
        ),
      ),
      selected: isSelected,
      selectedTileColor: ManagementColors.getPrimary(
        isDark,
      ).withValues(alpha: 0.1),
      onTap: () {
        provider.setDashboardIndex(index);
        Navigator.pop(context);
      },
    );
  }
}
