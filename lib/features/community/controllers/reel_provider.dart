import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/community/models/reel.dart';
import 'package:sanaa_artl/core/utils/database/dao/reel_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/reel_comment_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/follow_dao.dart';
import 'package:sanaa_artl/core/services/connectivity_service.dart';
import 'package:sanaa_artl/core/services/notification_service.dart';

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
    _isLoading = true;
    notifyListeners();

    try {
      await loadReels();
      if (_reels.isEmpty) {
        await _generateDemoReels();
      }

      // إضافة الفيديو الجديد يدوياً إذا لم يكن موجوداً
      await _ensureUserVideoExists();

      // إعداد مستمع الاتصال
      _setupConnectivityListener();

      // مزامنة العناصر العالقة إذا كنا متصلين
      if (ConnectivityService().isConnected.value) {
        syncPendingReels();
      }
    } catch (e) {
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
      // Error loading reels
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
      // Error toggling like
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
      // Error incrementing views
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
      // Error toggling follow
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
      // Error adding comment
    }
  }

  /// إضافة Reel جديد
  Future<void> addReel(Reel reel) async {
    try {
      await _reelDao.insertReel(reel.toJson());
      _reels.insert(0, reel);
      notifyListeners();

      // إذا كان العنصر تمت إضافته وأنت أونلاين، نقوم "بمحاكاة" المزامنة فوراً
      if (reel.syncStatus == 'pending' &&
          ConnectivityService().isConnected.value) {
        syncPendingReels();
      }
    } catch (e) {
      // Error adding reel
    }
  }

  /// إعداد مستمع حالة الاتصال
  void _setupConnectivityListener() {
    ConnectivityService().isConnected.addListener(() {
      if (ConnectivityService().isConnected.value) {
        syncPendingReels();
      }
    });
  }

  /// مزامنة الريلز المعلقة (pending)
  Future<void> syncPendingReels() async {
    final pendingReels = _reels
        .where((r) => r.syncStatus == 'pending')
        .toList();
    if (pendingReels.isEmpty) return;

    for (var reel in pendingReels) {
      try {
        // Syncing pending reel: ${reel.id}

        // محاكاة تأخير الشبكة
        await Future.delayed(const Duration(seconds: 3));

        final updatedReel = reel.copyWith(syncStatus: 'synced');
        await _reelDao.insertReel(
          updatedReel.toJson(),
        ); // تحديث في قاعدة البيانات

        final index = _reels.indexWhere((r) => r.id == reel.id);
        if (index != -1) {
          _reels[index] = updatedReel;
          notifyListeners();
        }

        // إشعار بالنجاح بنمط الانستجرام والواتساب
        await NotificationService().showNotification(
          id: reel.id.hashCode,
          title: 'تم النشر بنجاح ✨',
          body: 'تم مزامنة الريلز الخاص بك: "${reel.description}"',
        );

        // إخفاء إشعار الانتظار
        await NotificationService().cancelNotification(1);
      } catch (e) {
        // Error syncing reel
        // إشعار بالفشل
        await NotificationService().showNotification(
          id: reel.id.hashCode,
          title: 'فشل النشر ⚠️',
          body: 'حدث خطأ أثناء محاولة نشر الريلز. سيتم المحاولة لاحقاً.',
        );
      }
    }
  }

  /// توليد بيانات تجريبية (للتطوير)
  Future<void> _generateDemoReels() async {
    final demoReels = [
      Reel(
        id: 'reel_1',
        authorId: 'artist_1',
        authorName: 'أحمد المقطري',
        authorAvatar: 'assets/images/sanaa_img_01.jpg',
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
        authorAvatar: 'assets/images/sanaa_img_02.jpg',
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
        authorAvatar: 'assets/images/sanaa_img_03.jpg',
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

  /// التأكد من وجود فيديو المستخدم في قاعدة البيانات
  Future<void> _ensureUserVideoExists() async {
    const userVideoId = 'user_custom_video';

    final userReel = Reel(
      id: userVideoId,
      authorId: 'current_user',
      authorName: 'أحمد محمد',
      authorAvatar: 'assets/images/sanaa_img_01.jpg',
      videoUrl: 'assets/vedioes/VID_20260105_043950_729.mp4',
      thumbnailUrl: 'assets/images/sanaa_img_05.jpg',
      description: 'تجربة عرض الفيديو الجديد في الريلز ✨ #إبداع #يمن',
      likes: 1500,
      commentsCount: 45,
      views: 12500,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: ['تجربة', 'فيديو_جديد', 'فن'],
    );

    try {
      // تحديث أو إدراج في قاعدة البيانات
      await _reelDao.insertReel(userReel.toJson());

      // تحديث القائمة المحلية
      _reels.removeWhere((r) => r.id == userVideoId);
      _reels.insert(0, userReel);

      notifyListeners();
    } catch (e) {
      // Error ensuring user video
    }
  }

  /// تنشيط البيانات
  Future<void> refresh() async {
    await loadReels();
    await _ensureUserVideoExists();
  }
}
