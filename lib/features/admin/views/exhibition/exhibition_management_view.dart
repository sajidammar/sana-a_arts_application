import 'package:flutter/material.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';

class ExhibitionManagementView extends StatelessWidget {
  final bool isDark;
  const ExhibitionManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final exhibitions = adminProvider.exhibitions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إدارة المعارض الفنية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 20),
            _buildStatBanner(context),
            const SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: AppColors.getCardColor(isDark),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.1),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exhibitions.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.05),
                ),
                itemBuilder: (context, index) {
                  final exhibition = exhibitions[index];
                  final isActive = (exhibition['is_active'] ?? 0) == 1;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.palette_outlined,
                        color: Colors.amber,
                      ),
                    ),
                    title: Text(
                      exhibition['title'] ?? 'معرض فني',
                      style: TextStyle(
                        color: AppColors.getTextColor(isDark),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'الحالة: ${isActive ? 'نشط' : 'متوقف'} • الموقع: ${exhibition['location'] ?? 'غير محدد'}',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                        color: AppColors.getSubtextColor(isDark),
                      ),
                    ),
                    trailing: Switch(
                      value: isActive,
                      activeColor: AppColors.getPrimaryColor(isDark),
                      onChanged: (val) {
                        adminProvider.toggleExhibitionStatus(
                          exhibition['id'].toString(),
                          val,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text(
          'إنشاء معرض جديد',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add_photo_alternate),
        backgroundColor: AppColors.getPrimaryColor(isDark),
        foregroundColor: isDark ? Colors.black : Colors.white,
      ),
    );
  }

  Widget _buildStatBanner(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.2),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(label: 'معارض نشطة', value: '12'),
          _StatItem(label: 'إجمالي الزوار', value: '1.2k'),
          _StatItem(label: 'طلبات الانضمام', value: '3'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.getTextColor(isDark),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Tajawal',
            color: AppColors.getSubtextColor(isDark),
          ),
        ),
      ],
    );
  }
}
