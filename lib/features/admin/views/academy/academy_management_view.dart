import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class AcademyManagementView extends StatelessWidget {
  final bool isDark;
  const AcademyManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final items = adminProvider.academyItems;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildActionCard(
                    context,
                    'إضافة ورشة عمل جديدة',
                    'قم بإنشاء ورشة عمل فنية جديدة للمستخدمين',
                    Icons.add_task,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.getCardColor(isDark),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.getPrimaryColor(
                            isDark,
                          ).withValues(alpha: 0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'قائمة الورش الحالية',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.getTextColor(isDark),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                          Expanded(
                            child: items.isEmpty
                                ? Center(
                                    child: Text(
                                      'لا توجد ورش حالياً',
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        color: AppColors.getSubtextColor(
                                          isDark,
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    itemCount: items.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          color: AppColors.getPrimaryColor(
                                            isDark,
                                          ).withValues(alpha: 0.1),
                                        ),
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor:
                                              AppColors.getPrimaryColor(
                                                isDark,
                                              ).withValues(alpha: 0.1),
                                          child: Icon(
                                            Icons.school,
                                            color: AppColors.getPrimaryColor(
                                              isDark,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          item.title,
                                          style: TextStyle(
                                            color: AppColors.getTextColor(
                                              isDark,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        subtitle: Text(
                                          'المدرب: ${item.instructor}',
                                          style: TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: AppColors.getSubtextColor(
                                              isDark,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            item.status,
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Tajawal',
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    Color color,
  ) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            color: AppColors.getTextColor(isDark),
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(
            fontFamily: 'Tajawal',
            color: AppColors.getSubtextColor(isDark),
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.add_circle,
          color: AppColors.getPrimaryColor(isDark),
        ),
        onTap: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final instructorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'إضافة ورشة جديدة',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'اسم الورشة'),
            ),
            TextField(
              controller: instructorController,
              decoration: const InputDecoration(labelText: 'اسم المدرب'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AdminProvider>(
                context,
                listen: false,
              ).addAcademyItem(titleController.text, instructorController.text);
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
