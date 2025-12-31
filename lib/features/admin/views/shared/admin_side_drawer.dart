import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class AdminSideDrawer extends StatelessWidget {
  const AdminSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Drawer(
      backgroundColor: AppColors.getBackgroundColor(isDark),
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
                _buildMenuItem(
                  context,
                  icon: Icons.assignment_turned_in,
                  title: 'إدارة الطلبات',
                  index: 8,
                  isDark: isDark,
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
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: AppColors.virtualGradient,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              size: 45,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'نظام الإدارة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
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
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final isSelected = adminProvider.currentDashboardIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.getPrimaryColor(isDark) : Colors.grey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppColors.getPrimaryColor(isDark)
                : AppColors.getTextColor(isDark),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Tajawal',
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppColors.getPrimaryColor(
          isDark,
        ).withValues(alpha: 0.1),
        onTap: () {
          adminProvider.setDashboardIndex(index);
          Navigator.pop(context);
        },
      ),
    );
  }
}
