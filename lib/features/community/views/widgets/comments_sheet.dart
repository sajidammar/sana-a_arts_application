import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/community/controllers/community_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class CommentsSheet extends StatefulWidget {
  final String postId;

  const CommentsSheet({super.key, required this.postId});

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.isEmpty) return;

    context.read<CommunityProvider>().addComment(
      widget.postId,
      _commentController.text,
    );
    _commentController.clear();
    FocusScope.of(context).unfocus(); // Close keyboard after submitting
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'التعليقات',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.getTextColor(isDark),
            ),
          ),
          const Divider(),

          // Comments List
          Expanded(
            child: Consumer<CommunityProvider>(
              builder: (context, provider, child) {
                // Determine the correct post
                final postIndex = provider.posts.indexWhere(
                  (p) => p.id == widget.postId,
                );
                if (postIndex == -1) return const SizedBox();
                final post = provider.posts[postIndex];

                if (post.comments.isEmpty) {
                  return Center(
                    child: Text(
                      'كن أول من يعلق!',
                      style: TextStyle(
                        color: AppColors.getSubtextColor(isDark),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = post.comments[index];
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
                            backgroundImage:
                                comment.author.profileImage.isNotEmpty
                                ? AssetImage(comment.author.profileImage)
                                : null,
                            child: comment.author.profileImage.isEmpty
                                ? Icon(
                                    Icons.person,
                                    size: 18,
                                    color: Theme.of(context).primaryColor,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.author.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.getTextColor(isDark),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      provider.getTimeAgo(comment.timestamp),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.content,
                                  style: TextStyle(
                                    color: AppColors.getSubtextColor(isDark),
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
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: BoxDecoration(
              color: AppColors.getCardColor(isDark),
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.getBackgroundColor(isDark),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'أكتب تعليقاً...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _submitComment,
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



