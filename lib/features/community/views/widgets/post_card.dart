import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/community/models/post.dart';
import 'package:sanaa_artl/features/community/controllers/community_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/community/views/widgets/comments_sheet.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: post.author.profileImage.isNotEmpty
                      ? _getImageProvider(post.author.profileImage)
                      : null,
                  child: post.author.profileImage.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(isDark),
                      ),
                    ),
                    Text(
                      _formatDate(post.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.getSubtextColor(isDark),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  color: AppColors.getSubtextColor(isDark),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: AppColors.getCardColor(isDark),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (post.author.id == 'current_user')
                              ListTile(
                                leading: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                title: const Text(
                                  'حذف المنشور',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () {
                                  context.read<CommunityProvider>().deletePost(
                                    post.id,
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ListTile(
                              leading: const Icon(
                                Icons.flag,
                                color: Colors.orange,
                              ),
                              title: const Text('إبلاغ عن محتوى'),
                              onTap: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم إرسال البلاغ للمراجعة'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Content
          if (post.content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                post.content,
                style: TextStyle(
                  color: AppColors.getTextColor(isDark),
                  height: 1.5,
                ),
              ),
            ),

          // Image
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _getImageProvider(post.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildActionButton(
                  context,
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '${post.likesCount}',
                  color: post.isLiked ? Colors.red : null,
                  onTap: () {
                    context.read<CommunityProvider>().toggleLike(post.id);
                  },
                ),
                const SizedBox(width: 20),
                _buildActionButton(
                  context,
                  icon: Icons.comment_outlined,
                  label: '${post.commentsCount}',
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CommentsSheet(postId: post.id),
                    );
                  },
                ),
                const Spacer(),
                _buildActionButton(
                  context,
                  icon: Icons.share_outlined,
                  label: 'مشاركة',
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم نسخ رابط المنشور'),
                        backgroundColor: Theme.of(context).primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final contentColor = color ?? AppColors.getSubtextColor(isDark);

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: contentColor, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: contentColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple helper if provider's one is not accessible directly or to avoid context lookup
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return 'منذ ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'منذ ${diff.inHours} ساعة';
    return 'الآن';
  }

  ImageProvider _getImageProvider(String imageUrl) {
    // Local assets
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    // Network image
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return NetworkImage(imageUrl);
    }
    // Local file path (from gallery or camera)
    if (imageUrl.startsWith('/') ||
        imageUrl.startsWith('C:') ||
        imageUrl.startsWith('file://')) {
      final cleanPath = imageUrl.replaceFirst('file://', '');
      final file = File(cleanPath);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    // Fallback
    return AssetImage(imageUrl);
  }
}
