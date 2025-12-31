import 'package:flutter/material.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:provider/provider.dart';

class NotificationsManagementView extends StatelessWidget {
  final bool isDark;
  const NotificationsManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'بث إشعار جديد',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'سيتم إرسال هذا الإشعار لكافة مستخدمي المنصة المفعّلين',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.getSubtextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: AppColors.getCardColor(isDark),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    style: TextStyle(
                      color: AppColors.getTextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                    decoration: InputDecoration(
                      labelText: 'عنوان الإشعار',
                      labelStyle: TextStyle(
                        color: AppColors.getSubtextColor(isDark),
                        fontFamily: 'Tajawal',
                      ),
                      filled: true,
                      fillColor: AppColors.getBackgroundColor(
                        isDark,
                      ).withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.title,
                        color: AppColors.getPrimaryColor(isDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: messageController,
                    maxLines: 5,
                    style: TextStyle(
                      color: AppColors.getTextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                    decoration: InputDecoration(
                      labelText: 'محتوى الرسالة',
                      labelStyle: TextStyle(
                        color: AppColors.getSubtextColor(isDark),
                        fontFamily: 'Tajawal',
                      ),
                      filled: true,
                      fillColor: AppColors.getBackgroundColor(
                        isDark,
                      ).withValues(alpha: 0.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            messageController.text.isNotEmpty) {
                          adminProvider.sendNotification(
                            titleController.text,
                            messageController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم إرسال الإشعار بنجاح 🚀',
                                style: TextStyle(fontFamily: 'Tajawal'),
                              ),
                            ),
                          );
                          titleController.clear();
                          messageController.clear();
                        }
                      },
                      icon: const Icon(Icons.flash_on, size: 20),
                      label: const Text(
                        'إرسال الإشعار الآن',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getPrimaryColor(isDark),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
