import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/profile/views/profile_header.dart';

import 'package:sanaa_artl/features/auth/controllers/user_controller.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'edit_profile_page.dart';
// import 'change_password_page.dart';
import 'package:sanaa_artl/features/community/controllers/reel_provider.dart';
import 'package:sanaa_artl/features/chat/controllers/chat_provider.dart';
import 'package:sanaa_artl/features/chat/models/chat_model.dart';
import 'package:sanaa_artl/features/chat/views/chat_page.dart';
// import '../settings/notifications_page.dart';
// import '../settings/privacy_page.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  final String? username;
  final String? avatarUrl;

  const ProfilePage({super.key, this.userId, this.username, this.avatarUrl});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameController = TextEditingController();
  File? selectedImage;

  String get firstLetter {
    final text = nameController.text.trim();
    if (text.isEmpty) return '?';
    return text.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final primaryColor = AppColors.getPrimaryColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    // final subtextColor = AppColors.getSubtextColor(isDark);
    // final cardColor = AppColors.getCardColor(isDark);

    final user = context.watch<UserProvider>().user;

    // إذا تم تمرير بيانات مؤلف، نستخدمها، وإلا نستخدم بيانات المستخدم الحالي
    final displayName = widget.username ?? user.name;
    final displayImage = widget.avatarUrl ?? user.profileImage;
    final isOwnProfile =
        widget.userId == null ||
        widget.userId == user.id ||
        widget.userId == '';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 0,
                floating: true,
                pinned: true,
                backgroundColor: backgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: textColor, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.share, color: textColor),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم نسخ رابط الملف الشخصي')),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: textColor),
                    onPressed: () {},
                  ),
                ],
                title: Text(
                  displayName,
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: false,
              ),
              SliverToBoxAdapter(
                child: ProfileHeader(
                  name: displayName,
                  imageUrl: displayImage,
                  bio: isOwnProfile
                      ? user.bio
                      : 'فنان يمني مبدع يشارك أعماله على منصة صنعاء للفنون.',
                  followers: isOwnProfile ? 256 : 120,
                  following: isOwnProfile ? 124 : 45,
                  posts: isOwnProfile ? 102 : 12,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  textColor: textColor,
                ),
              ),

              // Action Buttons (Instagram Style)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      if (isOwnProfile)
                        Expanded(
                          child: _buildActionButton(
                            'تعديل الملف الشخصي',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ),
                              );
                            },
                            isDark: isDark,
                            textColor: textColor,
                          ),
                        )
                      else ...[
                        Consumer<ReelProvider>(
                          builder: (context, reelProvider, child) {
                            final isFollowing = widget.userId != null
                                ? reelProvider.isFollowing(widget.userId!)
                                : false;

                            return Expanded(
                              child: _buildActionButton(
                                isFollowing ? 'متابَع' : 'متابعة',
                                onPressed: () async {
                                  if (widget.userId != null) {
                                    await reelProvider.toggleFollow(
                                      widget.userId!,
                                    );
                                  }
                                },
                                isDark: isDark,
                                textColor: isFollowing
                                    ? textColor
                                    : Colors.white,
                                backgroundColor: isFollowing
                                    ? null
                                    : primaryColor,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildActionButton(
                            'رسالة',
                            onPressed: () async {
                              if (widget.userId == null) return;

                              final chatProvider = context.read<ChatProvider>();
                              // Try to find existing conversation
                              Conversation? conversation;
                              try {
                                conversation = chatProvider.conversations
                                    .firstWhere(
                                      (c) => c.receiverId == widget.userId,
                                    );
                              } catch (_) {
                                // If not found, create a temporary one
                                conversation = Conversation(
                                  id: null, // New conversation
                                  receiverId: widget.userId!,
                                  receiverName: widget.username ?? 'فنان مجهول',
                                  receiverImage: widget.avatarUrl,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now(),
                                );
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChatPage(conversation: conversation!),
                                ),
                              );
                            },
                            isDark: isDark,
                            textColor: textColor,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      _buildIconActionButton(
                        Icons.person_add_outlined,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Tabs (Instagram Style Sticky)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: textColor,
                    indicatorWeight: 1,
                    tabs: [
                      Tab(icon: Icon(Icons.grid_on_outlined, color: textColor)),
                      Tab(icon: Icon(Icons.movie_outlined, color: textColor)),
                    ],
                  ),
                  backgroundColor: backgroundColor,
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _buildPostsGrid(isDark, primaryColor, context),
              _buildReelsGrid(isDark, primaryColor, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label, {
    required VoidCallback onPressed,
    required bool isDark,
    required Color textColor,
    Color? backgroundColor,
  }) {
    return SizedBox(
      height: 35,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor:
              backgroundColor ?? (isDark ? Colors.grey[900] : Colors.grey[200]),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontFamily: 'Tajawal',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIconActionButton(IconData icon, {required bool isDark}) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 20),
    );
  }

  Widget _buildPostsGrid(
    bool isDark,
    Color primaryColor,
    BuildContext context,
  ) {
    return CustomScrollView(
      key: PageStorageKey<String>('profile_posts'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 2),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                color: primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.image_outlined,
                  color: primaryColor.withValues(alpha: 0.3),
                ),
              );
            }, childCount: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildReelsGrid(
    bool isDark,
    Color primaryColor,
    BuildContext context,
  ) {
    return CustomScrollView(
      key: PageStorageKey<String>('profile_reels'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 2),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: 0.6,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                color: primaryColor.withValues(alpha: 0.1),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.play_arrow_outlined,
                        color: primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_arrow_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            '1.2K',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: 8),
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, {required this.backgroundColor});

  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
