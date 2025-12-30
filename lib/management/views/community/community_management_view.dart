import 'package:flutter/material.dart';
import '../../controllers/global_management_controller.dart';
import '../../themes/management_colors.dart';

class CommunityManagementView extends StatefulWidget {
  final bool isDark;
  const CommunityManagementView({super.key, required this.isDark});

  @override
  State<CommunityManagementView> createState() =>
      _CommunityManagementViewState();
}

class _CommunityManagementViewState extends State<CommunityManagementView> {
  final GlobalManagementController _controller = GlobalManagementController();
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    final data = await _controller.getAllPosts();
    setState(() {
      _posts = data;
      _isLoading = false;
    });
  }

  Future<void> _deletePost(String id) async {
    await _controller.deletePost(id);
    _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إدارة منشورات المجتمع',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ManagementColors.getText(widget.isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _posts.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد منشورات حالياً',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _posts.length,
                            itemBuilder: (context, index) {
                              final post = _posts[index];
                              return Card(
                                color: ManagementColors.getCard(widget.isDark),
                                child: ListTile(
                                  title: Text(
                                    post['content'] ?? 'محتوى فارغ',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: ManagementColors.getText(
                                        widget.isDark,
                                      ),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  subtitle: Text(
                                    'التوقيت: ${post['timestamp'] ?? ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _showDeleteConfirmation(post['id']);
                                    },
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

  void _showDeleteConfirmation(String? id) {
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
              _deletePost(id);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
