import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/community/post.dart';
import 'package:sanaa_artl/models/exhibition/user.dart';
import 'package:sanaa_artl/utils/database/dao/post_dao.dart';
import 'package:sanaa_artl/utils/database/dao/comment_dao.dart';
import 'package:sanaa_artl/utils/database/dao/like_dao.dart';
import 'package:sanaa_artl/utils/database/dao/user_dao.dart';
import 'package:sanaa_artl/utils/database/database_constants.dart';

/// CommunityProvider - مزود بيانات المجتمع (Controller في MVC)
/// يدير المنشورات والتعليقات والإعجابات من قاعدة البيانات
class CommunityProvider with ChangeNotifier {
  final PostDao _postDao = PostDao();
  final CommentDao _commentDao = CommentDao();
  final LikeDao _likeDao = LikeDao();
  final UserDao _userDao = UserDao();

  List<Post> _posts = [];
  List<User> _artists = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final String _currentUserId = 'current_user';
  Set<String> _likedPostIds = {};

  List<Post> get posts {
    if (_searchQuery.isEmpty) return _posts;
    return _posts
        .where(
          (p) =>
              p.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.author.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<User> get artists {
    if (_searchQuery.isEmpty) return _artists;
    return _artists
        .where((u) => u.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// تهيئة البيانات من قاعدة البيانات
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await loadPosts();
      await loadArtists();
      await _loadLikedPosts();
    } catch (e) {
      debugPrint('خطأ في تهيئة CommunityProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تحميل المنشورات من قاعدة البيانات
  Future<void> loadPosts() async {
    try {
      final postMaps = await _postDao.getAllPosts();
      _posts = await Future.wait(
        postMaps.map((map) async {
          final comments = await _commentDao.getCommentsByPostId(map['id']);
          final isLiked = await _likeDao.isLikedByUser(
            map['id'],
            _currentUserId,
          );

          return _mapToPost(map, comments, isLiked);
        }),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تحميل المنشورات: $e');
    }
  }

  /// تحميل الفنانين من قاعدة البيانات
  Future<void> loadArtists() async {
    try {
      final artistMaps = await _userDao.getUsersByRole('artist');
      _artists = artistMaps.map((map) => User.fromMap(map)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تحميل الفنانين: $e');
    }
  }

  /// تحميل قائمة المنشورات المعجب بها
  Future<void> _loadLikedPosts() async {
    try {
      final likedIds = await _likeDao.getLikedPostIds(_currentUserId);
      _likedPostIds = likedIds.toSet();
    } catch (e) {
      debugPrint('خطأ في تحميل الإعجابات: $e');
    }
  }

  /// تحويل Map إلى Post
  Post _mapToPost(
    Map<String, dynamic> map,
    List<Map<String, dynamic>> commentMaps,
    bool isLiked,
  ) {
    final author = User(
      id: map['author_id'] ?? '',
      name: map['author_name'] ?? '',
      email: '',
      phone: '',
      profileImage: map['author_image'] ?? '',
      role: _parseUserRole(map['author_role'] ?? 'user'),
      joinDate: DateTime.now(),
      preferences: UserPreferences(),
      membershipLevel: map['author_membership'] ?? 'عادي',
    );

    final comments = commentMaps
        .map(
          (c) => Comment(
            id: c['id'] ?? '',
            author: User(
              id: c['author_id'] ?? '',
              name: c['author_name'] ?? '',
              email: '',
              phone: '',
              profileImage: c['author_image'] ?? '',
              role: _parseUserRole(c['author_role'] ?? 'user'),
              joinDate: DateTime.now(),
              preferences: UserPreferences(),
            ),
            content: c['content'] ?? '',
            timestamp: DateTime.parse(
              c['timestamp'] ?? DateTime.now().toIso8601String(),
            ),
          ),
        )
        .toList();

    return Post(
      id: map['id'] ?? '',
      author: author,
      content: map['content'] ?? '',
      imageUrl: map['image_url'],
      timestamp: DateTime.parse(
        map['timestamp'] ?? DateTime.now().toIso8601String(),
      ),
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      isLiked: isLiked,
      comments: comments,
    );
  }

  UserRole _parseUserRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'artist':
        return UserRole.artist;
      case 'moderator':
        return UserRole.moderator;
      default:
        return UserRole.user;
    }
  }

  /// تبديل الإعجاب
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    try {
      final nowLiked = await _likeDao.toggleLike(postId, _currentUserId);
      final post = _posts[index];

      _posts[index] = post.copyWith(
        isLiked: nowLiked,
        likesCount: nowLiked ? post.likesCount + 1 : post.likesCount - 1,
      );

      if (nowLiked) {
        _likedPostIds.add(postId);
      } else {
        _likedPostIds.remove(postId);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في تحديث الإعجاب: $e');
    }
  }

  /// إضافة منشور جديد
  Future<void> addPost(String content, String? imageUrl) async {
    try {
      final postId = 'post_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      await _postDao.insertPost({
        DatabaseConstants.colId: postId,
        DatabaseConstants.colAuthorId: _currentUserId,
        DatabaseConstants.colContent: content,
        DatabaseConstants.colImageUrl: imageUrl,
        DatabaseConstants.colTimestamp: now.toIso8601String(),
      });

      // إعادة تحميل المنشورات
      await loadPosts();
    } catch (e) {
      debugPrint('خطأ في إضافة المنشور: $e');
    }
  }

  /// حذف منشور
  Future<void> deletePost(String postId) async {
    try {
      await _postDao.deletePost(postId);
      _posts.removeWhere((p) => p.id == postId);
      notifyListeners();
    } catch (e) {
      debugPrint('خطأ في حذف المنشور: $e');
    }
  }

  /// إضافة تعليق
  Future<void> addComment(String postId, String content) async {
    try {
      final commentId = 'comment_${DateTime.now().millisecondsSinceEpoch}';

      await _commentDao.insertComment({
        DatabaseConstants.colId: commentId,
        DatabaseConstants.colPostId: postId,
        DatabaseConstants.colAuthorId: _currentUserId,
        DatabaseConstants.colContent: content,
        DatabaseConstants.colTimestamp: DateTime.now().toIso8601String(),
      });

      // تحديث المنشور محلياً
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final currentUserMap = await _userDao.getUserById(_currentUserId);

        if (currentUserMap != null) {
          final newComment = Comment(
            id: commentId,
            author: User.fromMap(currentUserMap),
            content: content,
            timestamp: DateTime.now(),
          );

          final updatedComments = List<Comment>.from(post.comments)
            ..add(newComment);

          _posts[index] = post.copyWith(
            comments: updatedComments,
            commentsCount: post.commentsCount + 1,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('خطأ في إضافة التعليق: $e');
    }
  }

  /// Helper method for formatting date
  String getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  /// تحديث بيانات المنشورات
  Future<void> refresh() async {
    await loadPosts();
    await loadArtists();
    await _loadLikedPosts();
  }
}
