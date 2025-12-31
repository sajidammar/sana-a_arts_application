import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/core/localization/app_localizations.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/home/views/widgets/ads_banner.dart';
import '../controllers/chat_provider.dart';
import '../models/chat_model.dart';
import 'chat_page.dart';
import 'dart:io';

class ChatHubView extends StatefulWidget {
  const ChatHubView({super.key});

  @override
  State<ChatHubView> createState() => _ChatHubViewState();
}

class _ChatHubViewState extends State<ChatHubView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryColor = AppColors.getPrimaryColor(isDark);
    final textColor = AppColors.getTextColor(isDark);

    return CustomScrollView(
      slivers: [
        // Ad Section at the Top
        const SliverToBoxAdapter(child: AdsBanner()),

        // Section Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  context.tr('direct_chats'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    context.tr('filter'),
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Conversations List
        Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            if (chatProvider.isLoading && chatProvider.conversations.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (chatProvider.conversations.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: textColor.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr('no_conversations'),
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.5),
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr('start_messaging'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.3),
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final conversation = chatProvider.conversations[index];
                return _buildConversationItem(
                  context,
                  conversation,
                  isDark,
                  primaryColor,
                  textColor,
                );
              }, childCount: chatProvider.conversations.length),
            );
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }

  Widget _buildConversationItem(
    BuildContext context,
    Conversation conversation,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    return Dismissible(
      key: Key(conversation.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        context.read<ChatProvider>().deleteConversation(conversation.id!);
      },
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: _getImageProvider(conversation.receiverImage),
              child: conversation.receiverImage == null
                  ? Text(
                      conversation.receiverName[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.getBackgroundColor(isDark),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conversation.receiverName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
            if (conversation.lastMessageTime != null)
              Text(
                _formatTime(conversation.lastMessageTime!),
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.getSubtextColor(isDark),
                  fontFamily: 'Tajawal',
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            conversation.lastMessage ?? context.tr('send_first_message'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.8),
              fontFamily: 'Tajawal',
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(conversation: conversation),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return '${diff.inDays}${context.tr('day_short')}';
    if (diff.inHours > 0) return '${diff.inHours}${context.tr('hour_short')}';
    if (diff.inMinutes > 0)
      return '${diff.inMinutes}${context.tr('minute_short')}';
    return context.tr('now');
  }

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    if (imagePath.startsWith('assets/')) return AssetImage(imagePath);
    if (imagePath.startsWith('/') ||
        imagePath.contains(':\\') ||
        imagePath.contains(':/')) {
      return FileImage(File(imagePath));
    }
    try {
      final uri = Uri.parse(imagePath);
      if (uri.hasScheme) return NetworkImage(imagePath);
    } catch (_) {}
    return null;
  }
}
