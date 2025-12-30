import 'package:flutter/material.dart';
import '../../themes/management_colors.dart';

class NotificationsManagementView extends StatelessWidget {
  final bool isDark;
  const NotificationsManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إرسال إشعار عام',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ManagementColors.getText(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: ManagementColors.getCard(isDark),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'عنوان الإشعار',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: messageController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'نص الإشعار',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'تم إرسال الإشعار لكافة المستخدمين',
                              ),
                            ),
                          );
                          titleController.clear();
                          messageController.clear();
                        },
                        icon: const Icon(Icons.send),
                        label: const Text(
                          'إرسال الآن',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ManagementColors.getPrimary(isDark),
                        ),
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
}
