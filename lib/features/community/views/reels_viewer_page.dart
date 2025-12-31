import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/community/models/reel.dart';
import 'package:sanaa_artl/features/community/controllers/reel_provider.dart';
import 'package:sanaa_artl/features/profile/views/profile_view.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

/// ReelsViewerPage - صفحة عرض الريلز بملء الشاشة
class ReelsViewerPage extends StatefulWidget {
  final List<Reel> reels;
  final int initialIndex;

  const ReelsViewerPage({
    super.key,
    required this.reels,
    this.initialIndex = 0,
  });

  @override
  State<ReelsViewerPage> createState() => _ReelsViewerPageState();
}

class _ReelsViewerPageState extends State<ReelsViewerPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reels',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.reels.length,
        itemBuilder: (context, index) {
          return ReelPlayerItem(reel: widget.reels[index]);
        },
      ),
    );
  }
}

class ReelPlayerItem extends StatefulWidget {
  final Reel reel;

  const ReelPlayerItem({super.key, required this.reel});

  @override
  State<ReelPlayerItem> createState() => _ReelPlayerItemState();
}

class _ReelPlayerItemState extends State<ReelPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.reel.videoUrl != null && widget.reel.videoUrl!.isNotEmpty) {
      if (widget.reel.videoUrl!.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(
          Uri.parse(widget.reel.videoUrl!),
        );
      } else {
        _controller = VideoPlayerController.asset(widget.reel.videoUrl!);
      }
    } else {
      // Default fallback
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        ),
      );
    }

    try {
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.play();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
      // زيادة المشاهدات عند العرض
      Provider.of<ReelProvider>(
        context,
        listen: false,
      ).incrementViews(widget.reel.id);
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reelProvider = Provider.of<ReelProvider>(context);
    final currentReel = reelProvider.reels.firstWhere(
      (r) => r.id == widget.reel.id,
      orElse: () => widget.reel,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        // مشغل الفيديو
        GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
            setState(() {});
          },
          child: Container(
            color: Colors.black,
            child: _isInitialized
                ? Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
          ),
        ),

        // تدرج أسود بالأسفل لسهولة قراءة النصوص
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // الأزرار الجانبية (Like, Comment, Share)
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(
                icon: currentReel.isLiked
                    ? Icons.favorite
                    : Icons.favorite_border,
                label: '${currentReel.likes}',
                color: currentReel.isLiked ? Colors.red : Colors.white,
                onTap: () => reelProvider.toggleLike(currentReel.id),
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.chat_bubble_outline,
                label: '${currentReel.commentsCount}',
                onTap: () => _showCommentsBottomSheet(context, currentReel.id),
              ),
              const SizedBox(height: 20),
              _buildActionButton(
                icon: Icons.share_outlined,
                label: 'مشاركة',
                onTap: () => _shareReel(context, currentReel),
              ),
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () => _showMoreOptions(context, currentReel),
              ),
            ],
          ),
        ),

        // معلومات المستخدم والوصف
        Positioned(
          left: 16,
          right: 80,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _navigateToProfile(context, currentReel),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: _getImageProvider(
                        currentReel.authorAvatar,
                      ),
                      child:
                          currentReel.authorAvatar == null ||
                              currentReel.authorAvatar!.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _navigateToProfile(context, currentReel),
                    child: Text(
                      currentReel.authorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () =>
                        reelProvider.toggleFollow(currentReel.authorId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: reelProvider.isFollowing(currentReel.authorId)
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.transparent,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        reelProvider.isFollowing(currentReel.authorId)
                            ? 'متابع'
                            : 'متابعة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                currentReel.description ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              if (currentReel.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: currentReel.tags
                      .map(
                        (tag) => Text(
                          '#$tag',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),

        // شريط تقدم الفيديو
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 2,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.amber,
                bufferedColor: Colors.white24,
                backgroundColor: Colors.white12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }

    if (imagePath.startsWith('/') ||
        imagePath.contains(':\\') ||
        imagePath.contains(':/')) {
      // Local file path
      return FileImage(File(imagePath));
    }

    // Default to NetworkImage for URLs or other formats
    try {
      final uri = Uri.parse(imagePath);
      if (uri.hasScheme) {
        return NetworkImage(imagePath);
      }
    } catch (_) {}

    // Fallback if everything fails but we have a string
    return AssetImage('assets/images/placeholder_avatar.jpg');
  }

  void _navigateToProfile(BuildContext context, Reel reel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          userId: reel.authorId,
          username: reel.authorName,
          avatarUrl: reel.authorAvatar,
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, String reelId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _ReelCommentsWidget(reelId: reelId);
      },
    );
  }

  void _shareReel(BuildContext context, Reel reel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'مشاركة الريلز',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: const Text('هل تريد مشاركة هذا الريلز مع أصدقائك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ الرابط للمشاركة')),
              );
            },
            child: const Text('نسخ الرابط'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context, Reel reel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: const Text('إبلاغ'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.not_interested),
            title: const Text('غير مهتم'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('نسخ الرابط'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _ReelCommentsWidget extends StatefulWidget {
  final String reelId;
  const _ReelCommentsWidget({required this.reelId});

  @override
  State<_ReelCommentsWidget> createState() => _ReelCommentsWidgetState();
}

class _ReelCommentsWidgetState extends State<_ReelCommentsWidget> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final reelProvider = Provider.of<ReelProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'التعليقات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: reelProvider.getComments(widget.reelId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data ?? [];
                if (comments.isEmpty) {
                  return const Center(
                    child: Text('لا توجد تعليقات بعد. كن أول من يعلق!'),
                  );
                }
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment['author_image'] != null
                            ? AssetImage(comment['author_image'])
                                  as ImageProvider
                            : null,
                        child: comment['author_image'] == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(comment['author_name'] ?? 'مستخدم'),
                      subtitle: Text(comment['content'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'أضف تعليقاً...',
                      hintStyle: const TextStyle(fontFamily: 'Tajawal'),
                      filled: true,
                      fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      await reelProvider.addComment(
                        widget.reelId,
                        _commentController.text,
                      );
                      _commentController.clear();
                      setState(() {}); // لتحديث القائمة
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
