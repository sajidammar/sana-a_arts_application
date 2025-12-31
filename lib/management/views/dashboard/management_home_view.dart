import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/management_provider.dart';
import 'package:sanaa_artl/management/themes/management_colors.dart';
import '../shared/management_side_drawer.dart';
import '../academy/academy_management_view.dart';
import '../store/store_management_view.dart';
import '../exhibition/exhibition_management_view.dart';
import '../users/users_management_view.dart';
import '../shared/notifications_management_view.dart';
import '../community/community_management_view.dart';
import '../reports/reports_management_view.dart';

class ManagementHomeView extends StatelessWidget {
  const ManagementHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ManagementProvider>(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      backgroundColor: ManagementColors.getBackground(isDark),
      appBar: AppBar(
        title: Text(
          _getTitle(provider.currentDashboardIndex),
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: ManagementColors.getPrimary(isDark),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const ManagementSideDrawer(),
      body: _buildBody(provider.currentDashboardIndex, isDark),
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
      default:
        return 'الإدارة';
    }
  }

  Widget _buildBody(int index, bool isDark) {
    switch (index) {
      case 0:
        return _DashboardOverview(isDark: isDark);
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
      default:
        return const Center(child: Text('قريباً'));
    }
  }
}

class _DashboardOverview extends StatelessWidget {
  final bool isDark;
  const _DashboardOverview({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظرة عامة على المنصة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ManagementColors.getText(isDark),
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('المستخدمين', '1,250', Icons.people, Colors.blue),
              _buildStatCard(
                'المبيعات',
                '45,000 \$',
                Icons.shopping_bag,
                Colors.green,
              ),
              _buildStatCard('المعارض', '24', Icons.palette, Colors.orange),
              _buildStatCard('الورش', '15', Icons.school, Colors.purple),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'آخر النشاطات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ManagementColors.getText(isDark),
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 15),
          _buildRecentActivityList(),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      color: ManagementColors.getCard(isDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ManagementColors.getText(isDark),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: ManagementColors.getText(isDark).withValues(alpha: 0.7),
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          color: ManagementColors.getCard(isDark),
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: ManagementColors.getPrimary(
                isDark,
              ).withValues(alpha: 0.1),
              child: Icon(
                Icons.notifications,
                color: ManagementColors.getPrimary(isDark),
              ),
            ),
            title: Text(
              'نشاط جديد في المنصة #$index',
              style: TextStyle(
                color: ManagementColors.getText(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
            subtitle: Text(
              'منذ ${index + 1} دقائق',
              style: TextStyle(
                color: ManagementColors.getText(isDark).withValues(alpha: 0.6),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        );
      },
    );
  }
}



