import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/community/community_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';

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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    if (_commentController.text.isEmpty) return;

    // In a real app, this would use artworkId to post a comment to the artwork specifically
    // behaving similar to the community provider but for exhibitions/artworks
    // For now, we simulate added comment locally or via a suitable provider method if available

    // context.read<CommunityProvider>().addComment(widget.artworkId, _commentController.text);

    // Simulating success for UI demo
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم إضافة تعليقك بنجاح!')));

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 320,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(
          alpha: 0.85,
        ), // Glassmorphism-ish background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
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
                Text(
                  'التعليقات',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
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

          // Comments List (Placeholder for now as we don't have artwork-specific comments in provider yet)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5, // Demo comments
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.2),
                        child: Icon(
                          Icons.person,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'مستخدم ${index + 1}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'منذ ${index + 2} دقائق',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'هذا عمل فني رائع جداً! يعجبني التفاصيل الدقيقة.',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(fontSize: 13),
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
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hoverColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: const InputDecoration(
                        hintText: 'أكتب تعليقاً...',
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
