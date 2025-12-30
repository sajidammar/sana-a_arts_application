import 'package:flutter/material.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';

class VRCommentsSidebar extends StatefulWidget {
  final String artworkId;
  final VoidCallback onClose;

  const VRCommentsSidebar({
    super.key,
    required this.artworkId,
    required this.onClose,
  });

  @override
  State<VRCommentsSidebar> createState() => _VRCommentsSidebarState();
}

class _VRCommentsSidebarState extends State<VRCommentsSidebar> {
  final TextEditingController _commentController = TextEditingController();
  String? _editingCommentId;
  final TextEditingController _editController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    _editController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    final vrProvider = context.read<VRProvider>();
    vrProvider.addComment(_commentController.text.trim());

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  void _showCommentOptions(
    BuildContext context,
    String commentId,
    String userId,
    String commentText,
  ) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.getBackgroundColor(isDark),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // تعديل التعليق (فقط لتعليقات المستخدم الحالي)
              if (userId == 'current_user')
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text(
                    'تعديل التعليق',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _editingCommentId = commentId;
                      _editController.text = commentText;
                    });
                  },
                ),
              // حذف التعليق (فقط لتعليقات المستخدم الحالي)
              if (userId == 'current_user')
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'حذف التعليق',
                    style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, commentId);
                  },
                ),
              // الإبلاغ عن التعليق (لتعليقات المستخدمين الآخرين)
              if (userId != 'current_user')
                ListTile(
                  leading: const Icon(Icons.flag, color: Colors.orange),
                  title: const Text(
                    'الإبلاغ عن التعليق',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog(context, commentId);
                  },
                ),
              // نسخ التعليق
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text(
                  'نسخ التعليق',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Clipboard.setData(ClipboardData(text: commentText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ التعليق')),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'حذف التعليق',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذا التعليق؟',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          TextButton(
            onPressed: () {
              context.read<VRProvider>().deleteComment(commentId);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('تم حذف التعليق')));
            },
            child: const Text(
              'حذف',
              style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context, String commentId) {
    String? selectedReason;
    final reasons = [
      'محتوى غير لائق',
      'إساءة أو تنمر',
      'معلومات خاطئة',
      'رسائل مزعجة',
      'أخرى',
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'الإبلاغ عن التعليق',
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اختر سبب الإبلاغ:',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
              const SizedBox(height: 12),
              ...reasons.map(
                (reason) => RadioListTile<String>(
                  title: Text(
                    reason,
                    style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14),
                  ),
                  value: reason,
                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value;
                    });
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
            TextButton(
              onPressed: selectedReason == null
                  ? null
                  : () {
                      context.read<VRProvider>().reportComment(
                        commentId,
                        selectedReason!,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم إرسال التقرير. شكراً لك!'),
                        ),
                      );
                    },
              child: const Text(
                'إرسال',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEdit(String commentId) {
    if (_editController.text.trim().isEmpty) return;

    context.read<VRProvider>().editComment(
      commentId,
      _editController.text.trim(),
    );
    setState(() {
      _editingCommentId = null;
      _editController.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تعديل التعليق')));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Consumer<VRProvider>(
      builder: (context, vrProvider, child) {
        final comments = vrProvider.comments;

        return Container(
          width: 320,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.getBackgroundColor(isDark).withValues(alpha: 0.95),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(-2, 0),
              ),
            ],
            border: Border(
              right: BorderSide(
                color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'التعليقات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Tajawal',
                            color: AppColors.getTextColor(isDark),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${comments.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                              color: AppColors.getPrimaryColor(isDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Comments List
              Expanded(
                child: comments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 60,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'لا توجد تعليقات بعد',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Tajawal',
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'كن أول من يعلق!',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Tajawal',
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final isEditing = _editingCommentId == comment.id;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  comment.userName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    fontFamily: 'Tajawal',
                                                    color:
                                                        AppColors.getTextColor(
                                                          isDark,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _getTimeAgo(
                                                    comment.createdAt,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: 'Tajawal',
                                                    color:
                                                        AppColors.getSubtextColor(
                                                          isDark,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                _showCommentOptions(
                                                  context,
                                                  comment.id,
                                                  comment.userId,
                                                  comment.comment,
                                                ),
                                            icon: const Icon(
                                              Icons.more_vert,
                                              size: 18,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      if (isEditing)
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).hoverColor,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: _editController,
                                                maxLines: 3,
                                                style: const TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  fontSize: 13,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                      border: InputBorder.none,
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _editingCommentId =
                                                            null;
                                                        _editController.clear();
                                                      });
                                                    },
                                                    child: const Text(
                                                      'إلغاء',
                                                      style: TextStyle(
                                                        fontFamily: 'Tajawal',
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        _saveEdit(comment.id),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Theme.of(
                                                        context,
                                                      ).primaryColor,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'حفظ',
                                                      style: TextStyle(
                                                        fontFamily: 'Tajawal',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Text(
                                          comment.comment,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Tajawal',
                                            color: AppColors.getTextColor(
                                              isDark,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      // زر الإعجاب
                                      InkWell(
                                        onTap: () =>
                                            vrProvider.likeComment(comment.id),
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 16,
                                                color: comment.likes > 0
                                                    ? Colors.red[400]
                                                    : Colors.grey[400],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${comment.likes}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Tajawal',
                                                  color:
                                                      AppColors.getSubtextColor(
                                                        isDark,
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
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Input Area
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.getBackgroundColor(isDark),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.getPrimaryColor(
                        isDark,
                      ).withValues(alpha: 0.1),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.getCardColor(isDark),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _commentController,
                          style: const TextStyle(fontFamily: 'Tajawal'),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _submitComment(),
                          decoration: const InputDecoration(
                            hintText: 'أكتب تعليقاً...',
                            hintStyle: TextStyle(fontFamily: 'Tajawal'),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.getPrimaryColor(isDark),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _submitComment,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} ${difference.inMinutes == 1 ? 'دقيقة' : 'دقائق'}';
    } else {
      return 'الآن';
    }
  }
}
