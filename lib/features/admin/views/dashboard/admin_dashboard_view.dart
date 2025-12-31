import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import '../shared/admin_side_drawer.dart';
import '../academy/academy_management_view.dart';
import '../store/store_management_view.dart';
import '../exhibition/exhibition_management_view.dart';
import '../users/users_management_view.dart';
import '../shared/notifications_management_view.dart';
import '../community/community_management_view.dart';
import '../reports/reports_management_view.dart';
import '../requests/requests_management_view.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: AppBar(
        title: Text(
          _getTitle(adminProvider.currentDashboardIndex),
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.getPrimaryColor(isDark),
        foregroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      drawer: const AdminSideDrawer(),
      body: _buildBody(
        adminProvider,
        adminProvider.currentDashboardIndex,
        isDark,
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'لوحة التحكم';
      case 1:
        return 'إدارة الأكاديمية';
      case 2:
        return 'إدارة المعارض';
      case 3:
        return 'إدارة المتجر';
      case 4:
        return 'إدارة المستخدمين';
      case 5:
        return 'إدارة الإشعارات';
      case 6:
        return 'إدارة المجتمع';
      case 7:
        return 'إدارة البلاغات والرقابة';
      case 8:
        return 'إدارة الطلبات';
      default:
        return 'الإدارة';
    }
  }

  Widget _buildBody(AdminProvider adminProvider, int index, bool isDark) {
    switch (index) {
      case 0:
        return _DashboardOverview(isDark: isDark, adminProvider: adminProvider);
      case 1:
        return AcademyManagementView(isDark: isDark);
      case 2:
        return ExhibitionManagementView(isDark: isDark);
      case 3:
        return StoreManagementView(isDark: isDark);
      case 4:
        return UsersManagementView(isDark: isDark);
      case 5:
        return NotificationsManagementView(isDark: isDark);
      case 6:
        return CommunityManagementView(isDark: isDark);
      case 7:
        return ReportsManagementView(isDark: isDark);
      case 8:
        return RequestsManagementView(isDark: isDark);
      default:
        return const Center(child: Text('قريباً'));
    }
  }
}

class _DashboardOverview extends StatelessWidget {
  final bool isDark;
  final AdminProvider adminProvider;
  const _DashboardOverview({required this.isDark, required this.adminProvider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(context),
          const SizedBox(height: 30),
          _buildStatsGrid(context),
          const SizedBox(height: 35),
          _buildSectionHeader(context, 'النشاطات الأخيرة', Icons.history),
          const SizedBox(height: 15),
          _buildRecentActivityList(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.virtualGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 35,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرحباً بك، المسؤول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  'لديك نظرة كاملة على أداء المنصة اليوم',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
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

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          context,
          'البلاغات',
          adminProvider.adminReports.length.toString(),
          Icons.report,
          Colors.red,
        ),
        _buildStatCard(
          context,
          'الطلبات المتبقية',
          adminProvider.adminRequests.length.toString(),
          Icons.assignment,
          Colors.indigo,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Row(
      children: [
        Icon(icon, color: AppColors.getPrimaryColor(isDark), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(isDark),
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.getSubtextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.getCardColor(isDark),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.05),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getActivityIcon(index),
                color: AppColors.getPrimaryColor(isDark),
                size: 20,
              ),
            ),
            title: Text(
              _getActivityTitle(index),
              style: TextStyle(
                color: AppColors.getTextColor(isDark),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
            ),
            subtitle: Text(
              'منذ ${index * 15 + 10} دقيقة',
              style: TextStyle(
                color: AppColors.getSubtextColor(isDark),
                fontSize: 12,
                fontFamily: 'Tajawal',
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  IconData _getActivityIcon(int index) {
    final icons = [
      Icons.person_add,
      Icons.shopping_cart,
      Icons.palette,
      Icons.school,
      Icons.comment,
      Icons.report,
    ];
    return icons[index % icons.length];
  }

  String _getActivityTitle(int index) {
    final titles = [
      'انضمام مستخدم جديد',
      'طلب شراء جديد في المتجر',
      'طلب اعتماد معرض فني',
      'تسجيل في ورشة "فن الرسم"',
      'تعليق جديد على عمل فني',
      'تقرير بلاغ جديد',
    ];
    return titles[index % titles.length];
  }
}
