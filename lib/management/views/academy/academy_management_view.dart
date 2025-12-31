import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/management_provider.dart';
import 'package:sanaa_artl/management/themes/management_colors.dart';

class AcademyManagementView extends StatelessWidget {
  final bool isDark;
  const AcademyManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ManagementProvider>(context);
    final items = provider.academyItems;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: provider.isLoading
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
                    child: Card(
                      color: ManagementColors.getCard(isDark),
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
                                color: ManagementColors.getText(isDark),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ),
                          Expanded(
                            child: items.isEmpty
                                ? const Center(
                                    child: Text(
                                      'لا توجد ورش حالياً',
                                      style: TextStyle(fontFamily: 'Tajawal'),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final item = items[index];
                                      return ListTile(
                                        leading: const CircleAvatar(
                                          child: Icon(Icons.school),
                                        ),
                                        title: Text(
                                          item.title,
                                          style: TextStyle(
                                            color: ManagementColors.getText(
                                              isDark,
                                            ),
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        subtitle: Text(
                                          'المدرب: ${item.instructor}',
                                          style: const TextStyle(
                                            fontFamily: 'Tajawal',
                                          ),
                                        ),
                                        trailing: Text(
                                          item.status,
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Tajawal',
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
    return Card(
      color: ManagementColors.getCard(isDark),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Text(desc, style: const TextStyle(fontFamily: 'Tajawal')),
        trailing: const Icon(Icons.add_circle_outline),
        onTap: () {
          // Simple dialog to add
          _showAddDialog(context);
        },
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
              Provider.of<ManagementProvider>(
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



