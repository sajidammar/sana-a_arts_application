import 'package:sanaa_artl/core/errors/failures.dart';
import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/core/utils/database/dao/post_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/comment_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/like_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/user_dao.dart';
import 'package:sanaa_artl/core/utils/database/database_constants.dart';
import 'package:sanaa_artl/features/community/data/community_repository.dart';
import 'package:sanaa_artl/features/community/models/post.dart';
import 'package:sanaa_artl/features/exhibitions/models/user.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final PostDao _postDao;
  final CommentDao _commentDao;
  final LikeDao _likeDao;
  final UserDao _userDao;

  CommunityRepositoryImpl({
    PostDao? postDao,
    CommentDao? commentDao,
    LikeDao? likeDao,
    UserDao? userDao,
  }) : _postDao = postDao ?? PostDao(),
       _commentDao = commentDao ?? CommentDao(),
       _likeDao = likeDao ?? LikeDao(),
       _userDao = userDao ?? UserDao();

  /// تحميل جميع المنشورات
  @override
  Future<Result<List<Post>>> getPosts() async {
    try {
      final postMaps = await _postDao.getAllPosts();

      // Since we need to look up likes for the *current* user,
      // but Repository shouldn't really know about "current user" session directly
      // typically, pass userId as arg. But for this refactor, I'll pass 'current_user'
      // or assume we handle it. The original code used a hardcoded '_currentUserId' or
      // passed it.
      // For now, I will use a placeholder or better, let the Provider pass it?
      // Actually, getAllPosts in original didn't take an ID, but used local _currentUserId.
      // I'll fetch 'current_user' from session or pass it.
      // Let's assume we pass the userId to checks.
      // Wait, checking original code: `_currentUserId = 'current_user';` hardcoded.
      const currentUserId = 'current_user';

      final posts = await Future.wait(
        postMaps.map((map) async {
          final comments = await _commentDao.getCommentsByPostId(map['id']);
          final isLiked = await _likeDao.isLikedByUser(
            map['id'],
            currentUserId,
          );
          return _mapToPost(map, comments, isLiked);
        }),
      );

      return Result.success(posts);
    } catch (e) {
      return Result.failure(DatabaseFailure('فشل تحميل المنشورات: $e'));
    }
  }

  /// إضافة منشور
  @override
  Future<Result<Post>> addPost({
    required String content,
    String? imageUrl,
    required String authorId,
  }) async {
    try {
      final postId = 'post_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      final postMap = {
        DatabaseConstants.colId: postId,
        DatabaseConstants.colAuthorId: authorId,
        DatabaseConstants.colContent: content,
        DatabaseConstants.colImageUrl: imageUrl,
        DatabaseConstants.colTimestamp: now.toIso8601String(),
      };

      await _postDao.insertPost(postMap);

      // We need to return the created Post object.
      // We need the Author details.
      final authorMap = await _userDao.getUserById(authorId);
      final author = authorMap != null
          ? User.fromMap(authorMap)
          : _createUnknownUser(authorId);

      final newPost = Post(
        id: postId,
        author: author,
        content: content,
        imageUrl: imageUrl,
        timestamp: now,
      );

      return Result.success(newPost);
    } catch (e) {
      return Result.failure(DatabaseFailure('فشل إضافة المنشور: $e'));
    }
  }

  /// حذف منشور
  @override
  Future<Result<void>> deletePost(String postId) async {
    try {
      await _postDao.deletePost(postId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('فشل حذف المنشور: $e'));
    }
  }

  /// تبديل الإعجاب
  @override
  Future<Result<bool>> toggleLike(String postId, String userId) async {
    try {
      final isLiked = await _likeDao.toggleLike(postId, userId);
      return Result.success(isLiked);
    } catch (e) {
      return Result.failure(DatabaseFailure('فشل تحديث الإعجاب: $e'));
    }
  }

  /// إضافة تعليق
  @override
  Future<Result<Comment>> addComment({
    required String postId,
    required String content,
    required String authorId,
  }) async {
    try {
      final commentId = 'comment_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();

      await _commentDao.insertComment({
        DatabaseConstants.colId: commentId,
        DatabaseConstants.colPostId: postId,
        DatabaseConstants.colAuthorId: authorId,
        DatabaseConstants.colContent: content,
        DatabaseConstants.colTimestamp: now.toIso8601String(),
      });

      final authorMap = await _userDao.getUserById(authorId);
      final author = authorMap != null
          ? User.fromMap(authorMap)
          : _createUnknownUser(authorId);

      final newComment = Comment(
        id: commentId,
        author: author,
        content: content,
        timestamp: now,
      );

      return Result.success(newComment);
    } catch (e) {
      return Result.failure(DatabaseFailure('فشل إضافة التعليق: $e'));
    }
  }

  // --- Helpers ---

  Post _mapToPost(
    Map<String, dynamic> map,
    List<Map<String, dynamic>> commentMaps,
    bool isLiked,
  ) {
    final author = User(
      id: map['author_id'] ?? '',
      name: map['author_name'] ?? 'مستخدم غير معروف',
      email: '',
      phone: '',
      profileImage: map['author_image'] ?? '',
      role: _parseUserRole(map['author_role'] ?? 'user'),
      joinDate: DateTime.now(),
      preferences: UserPreferences(),
      membershipLevel: map['author_membership'] ?? 'عادي',
    );

    final comments = commentMaps.map((c) => _mapToComment(c)).toList();

    return Post(
      id: map['id'] ?? '',
      author: author,
      content: map['content'] ?? '',
      imageUrl: map['image_url'],
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      isLiked: isLiked,
      comments: comments,
    );
  }

  Comment _mapToComment(Map<String, dynamic> c) {
    return Comment(
      id: c['id'] ?? '',
      author: User(
        id: c['author_id'] ?? '',
        name: c['author_name'] ?? 'مستخدم',
        email: '',
        phone: '',
        profileImage: c['author_image'] ?? '',
        role: _parseUserRole(c['author_role'] ?? 'user'),
        joinDate: DateTime.now(),
        preferences: UserPreferences(),
      ),
      content: c['content'] ?? '',
      timestamp: DateTime.tryParse(c['timestamp'] ?? '') ?? DateTime.now(),
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

  User _createUnknownUser(String id) {
    return User(
      id: id,
      name: 'مستخدم',
      email: '',
      phone: '',
      profileImage: '',
      role: UserRole.user,
      joinDate: DateTime.now(),
      preferences: UserPreferences(),
    );
  }
}
