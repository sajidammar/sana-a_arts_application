import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/community/models/reel.dart';
import 'package:sanaa_artl/core/utils/database/dao/reel_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/reel_comment_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/follow_dao.dart';

/// ReelProvider - مزود بيانات الريلز (Reels)
/// يدير مقاطع الفيديو القصيرة وحالة التفاعل معها
class ReelProvider with ChangeNotifier {
  final ReelDao _reelDao = ReelDao();
  final ReelCommentDao _commentDao = ReelCommentDao();
  final FollowDao _followDao = FollowDao();

  List<Reel> _reels = [];
  bool _isLoading = false;
  final Set<String> _followedAuthorIds = {};

  List<Reel> get reels => _reels;
  bool get isLoading => _isLoading;
  Set<String> get followedAuthorIds => _followedAuthorIds;

  /// تهيئة البيانات
  Future<void> initialize() async {
    debugPrint('🎬 Initializing ReelProvider...');
    _isLoading = true;
    notifyListeners();

    try {
      await loadReels();
      debugPrint('🎬 Reels loaded: ${_reels.length}');
      if (_reels.isEmpty) {
        debugPrint('🎬 No reels found, generating demo reels...');
        await _generateDemoReels();
        debugPrint('🎬 Reels after demo generation: ${_reels.length}');
      }
    } catch (e) {
      debugPrint('❌ Error initializing ReelProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تحميل الريلز من قاعدة البيانات
  Future<void> loadReels() async {
    try {
      final reelMaps = await _reelDao.getAllReels();
      _reels = reelMaps.map((map) => Reel.fromJson(map)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reels: $e');
    }
  }

  /// تبديل الإعجاب
  Future<void> toggleLike(String reelId) async {
    final index = _reels.indexWhere((r) => r.id == reelId);
    if (index == -1) return;

    final reel = _reels[index];
    final newIsLiked = !reel.isLiked;

    try {
      await _reelDao.toggleLike(reelId, newIsLiked);
      _reels[index] = reel.copyWith(
        isLiked: newIsLiked,
        likes: newIsLiked ? reel.likes + 1 : reel.likes - 1,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling like on reel: $e');
    }
  }

  /// زيادة عدد المشاهدات
  Future<void> incrementViews(String reelId) async {
    try {
      await _reelDao.incrementViews(reelId);
      final index = _reels.indexWhere((r) => r.id == reelId);
      if (index != -1) {
        _reels[index] = _reels[index].copyWith(views: _reels[index].views + 1);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error incrementing views on reel: $e');
    }
  }

  /// متابعة/إلغاء متابعة مؤلف
  Future<void> toggleFollow(String authorId) async {
    final currentUserId = 'current_user'; // مؤقت
    final isFollowing = _followedAuthorIds.contains(authorId);

    try {
      if (isFollowing) {
        await _followDao.unfollowUser(currentUserId, authorId);
        _followedAuthorIds.remove(authorId);
      } else {
        await _followDao.followUser(currentUserId, authorId);
        _followedAuthorIds.add(authorId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling follow: $e');
    }
  }

  /// هل يتابع المستخدم هذا المؤلف؟
  bool isFollowing(String authorId) {
    return _followedAuthorIds.contains(authorId);
  }

  /// جلب تعليقات ريلز
  Future<List<Map<String, dynamic>>> getComments(String reelId) async {
    return await _commentDao.getCommentsByReelId(reelId);
  }

  /// إضافة تعليق
  Future<void> addComment(String reelId, String content) async {
    try {
      await _commentDao.insertComment({
        'reel_id': reelId,
        'author_id': 'current_user', // مؤقت
        'content': content,
      });

      await _reelDao.incrementCommentsCount(reelId);

      // تحديث العدد في القائمة المحلية
      final index = _reels.indexWhere((r) => r.id == reelId);
      if (index != -1) {
        _reels[index] = _reels[index].copyWith(
          commentsCount: _reels[index].commentsCount + 1,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  /// إضافة Reel جديد
  Future<void> addReel(Reel reel) async {
    try {
      await _reelDao.insertReel(reel.toJson());
      _reels.insert(0, reel);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding reel: $e');
    }
  }

  /// توليد بيانات تجريبية (للتطوير)
  Future<void> _generateDemoReels() async {
    final demoReels = [
      Reel(
        id: 'reel_1',
        authorId: 'artist_1',
        authorName: 'أحمد المقطري',
        authorAvatar: 'assets/images/image1.jpg',
        videoUrl:
            'https://assets.mixkit.co/videos/preview/mixkit-girl-in-a-field-of-yellow-flowers-157-large.mp4',
        description: 'رسم بورتريه لصنعاء القديمة 🎨 #فن #يمن',
        likes: 120,
        commentsCount: 15,
        views: 1200,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: ['فن', 'يمن', 'صنعاء'],
      ),
      Reel(
        id: 'reel_2',
        authorId: 'artist_2',
        authorName: 'فاطمة الحمادي',
        authorAvatar: 'assets/images/image2.jpg',
        videoUrl:
            'https://assets.mixkit.co/videos/preview/mixkit-tree-with-yellow-flowers-1173-large.mp4',
        description: 'جمال العمارة اليمنية في تفاصيل صغيرة 🏠 #عمارة #تراث',
        likes: 85,
        commentsCount: 8,
        views: 850,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['عمارة', 'تراث', 'جمال'],
      ),
      Reel(
        id: 'reel_3',
        authorId: 'artist_3',
        authorName: 'محمد الشامي',
        authorAvatar: 'assets/images/image3.jpg',
        videoUrl:
            'https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-a-painting-brush-4309-large.mp4',
        description: 'تجربة فن الشارع في صنعاء ✨ #شوارع_صنعاء #إبداع',
        likes: 200,
        commentsCount: 25,
        views: 3500,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['إبداع', 'صنعاء'],
      ),
    ];

    for (var reel in demoReels) {
      await addReel(reel);
    }
  }

  /// تنشيط البيانات
  Future<void> refresh() async {
    await loadReels();
  }
}
