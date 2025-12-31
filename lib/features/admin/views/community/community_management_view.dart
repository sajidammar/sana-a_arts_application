import 'package:flutter/material.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:provider/provider.dart';

class CommunityManagementView extends StatefulWidget {
  final bool isDark;
  const CommunityManagementView({super.key, required this.isDark});

  @override
  State<CommunityManagementView> createState() =>
      _CommunityManagementViewState();
}

class _CommunityManagementViewState extends State<CommunityManagementView> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final posts = adminProvider.posts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: adminProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.getPrimaryColor(isDark),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرقابة على المجتمع',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'تعديل أو حذف المنشورات التي تخالف معايير المجتمع',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getSubtextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: posts.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد منشورات حالياً',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: AppColors.getSubtextColor(isDark),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: posts.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final post = posts[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.getCardColor(isDark),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: AppColors.getPrimaryColor(
                                      isDark,
                                    ).withValues(alpha: 0.05),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey.withValues(
                                      alpha: 0.1,
                                    ),
                                    child: Icon(
                                      Icons.forum_outlined,
                                      color: AppColors.getPrimaryColor(isDark),
                                    ),
                                  ),
                                  title: Text(
                                    post['content'] ?? 'محتوى فارغ',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.getTextColor(isDark),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'نُشر في: ${post['timestamp'] ?? ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Tajawal',
                                      color: AppColors.getSubtextColor(isDark),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_sweep_outlined,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _showDeleteConfirmation(
                                      context,
                                      adminProvider,
                                      post['id'],
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
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AdminProvider adminProvider,
    String? id,
  ) {
    if (id == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف المنشور',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف هذا المنشور؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              adminProvider.deletePost(id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
