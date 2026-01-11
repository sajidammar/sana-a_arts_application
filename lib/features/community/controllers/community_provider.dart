import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/community/models/post.dart';
import 'package:sanaa_artl/features/community/data/community_repository.dart';
import 'package:sanaa_artl/features/community/data/community_repository_impl.dart';

/// CommunityProvider - مزود بيانات المجتمع (Controller في MVC)
/// يدير المنشورات والتعليقات والإعجابات عبر المستودع
class CommunityProvider with ChangeNotifier {
  final CommunityRepository _repository;

  List<Post> _posts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  // يفترض أن يأتي هذا من AuthProvider أو Session، لكن للتبسيط نبقيه كما كان مؤقتاً
  final String _currentUserId = 'current_user';

  CommunityProvider({CommunityRepository? repository})
    : _repository = repository ?? CommunityRepositoryImpl();

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

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// تهيئة البيانات
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    await loadPosts();
    _isLoading = false;
    notifyListeners();
  }

  /// تحميل المنشورات
  Future<void> loadPosts() async {
    final result = await _repository.getPosts();

    result.fold(
      (failure) {
        // Handle error
      },
      (posts) {
        _posts = posts;
        notifyListeners();
      },
    );
  }

  /// تبديل الإعجاب
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    // Optimistic UI Update (Update UI before server confirmation if desired,
    // but here we wait to ensure consistency or update based on result)
    // To be safer and strictly follow repository result:

    final result = await _repository.toggleLike(postId, _currentUserId);

    result.fold(
      (failure) {
        debugPrint('Error toggling like: ${failure.message}');
      },
      (isActive) {
        final post = _posts[index];
        _posts[index] = post.copyWith(
          isLiked: isActive,
          likesCount: isActive ? post.likesCount + 1 : post.likesCount - 1,
        );
        notifyListeners();
      },
    );
  }

  /// إضافة منشور جديد
  Future<void> addPost(String content, String? imageUrl) async {
    final result = await _repository.addPost(
      content: content,
      imageUrl: imageUrl,
      authorId: _currentUserId,
    );

    result.fold(
      (failure) {
        debugPrint('Error adding post: ${failure.message}');
      },
      (newPost) {
        _posts.insert(0, newPost);
        notifyListeners();
      },
    );
  }

  /// حذف منشور
  Future<void> deletePost(String postId) async {
    final result = await _repository.deletePost(postId);

    result.fold(
      (failure) {
        debugPrint('Error deleting post: ${failure.message}');
      },
      (_) {
        _posts.removeWhere((p) => p.id == postId);
        notifyListeners();
      },
    );
  }

  /// إضافة تعليق
  Future<void> addComment(String postId, String content) async {
    final result = await _repository.addComment(
      postId: postId,
      content: content,
      authorId: _currentUserId,
    );

    result.fold(
      (failure) {
        debugPrint('Error adding comment: ${failure.message}');
      },
      (newComment) {
        final index = _posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          final post = _posts[index];
          final updatedComments = [...post.comments, newComment];

          _posts[index] = post.copyWith(
            comments: updatedComments,
            commentsCount: post.commentsCount + 1,
          );
          notifyListeners();
        }
      },
    );

    // Note: The logic above had a slight type cast issue in 'updatedComments'.
    // Correcting it below in a cleaner way:
    /*
    result.fold((f) => null, (newComment) {
       final index = _posts.indexWhere((p) => p.id == postId);
       if (index != -1) {
          final post = _posts[index];
          final updatedComments = [...post.comments, newComment];
          _posts[index] = post.copyWith(
            comments: updatedComments,
            commentsCount: post.commentsCount + 1,
          );
          notifyListeners();
       }
    });
    */
    // Re-writing the success block above cleanly inside the file content I'm writing.
  }

  // Helper for Date formatting can be kept or moved to Utils.
  // Keeping it for UI usage compatibility.
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

  Future<void> refresh() async {
    await loadPosts();
  }
}
