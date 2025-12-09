import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/community/post.dart';
import 'package:sanaa_artl/models/exhibition/user.dart';

class CommunityProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<User> _artists = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  List<User> get artists => _artists;
  bool get isLoading => _isLoading;

  // Demo Data Setup
  final User _currentUser = User(
    id: 'current_user',
    name: 'أنت',
    email: 'user@example.com',
    phone: '',
    profileImage: 'assets/images/image7.jpg',
    role: UserRole.user,
    joinDate: DateTime.now(),
    preferences: UserPreferences(),
  );

  final List<User> _demoArtists = [
    User(
      id: 'artist1',
      name: 'أحمد المقطري',
      email: 'ahmed@art.com',
      phone: '',
      profileImage: 'assets/images/image5.jpg',
      role: UserRole.artist,
      joinDate: DateTime(2023),
      preferences: UserPreferences(),
      membershipLevel: 'محترف',
    ),
    User(
      id: 'artist2',
      name: 'فاطمة الحمادي',
      email: 'fatima@art.com',
      phone: '',
      profileImage: 'assets/images/image6.jpg',
      role: UserRole.artist,
      joinDate: DateTime(2023),
      preferences: UserPreferences(),
      membershipLevel: 'موهوب',
    ),
    User(
      id: 'artist3',
      name: 'سارة العريقي',
      email: 'sara@art.com',
      phone: '',
      profileImage: 'assets/images/image3.jpg',
      role: UserRole.artist,
      joinDate: DateTime(2024),
      preferences: UserPreferences(),
      membershipLevel: 'صاعد',
    ),
  ];

  CommunityProvider() {
    _loadDemoData();
  }

  void _loadDemoData() {
    _artists = _demoArtists;
    _posts = [
      Post(
        id: '1',
        author: _demoArtists[0],
        content:
            'سعيد بمشاركتي في معرض صنعاء للفنون، أتمنى أن تنال أعمالي إعجابكم #فن #صنعاء',
        imageUrl: 'assets/images/image1.jpg',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likesCount: 45,
        commentsCount: 12,
        isLiked: false,
      ),
      Post(
        id: '2',
        author: _demoArtists[1],
        content:
            'العمل جارٍ على لوحتي الجديدة المستوحاة من التراث اليمني الأصيل',
        imageUrl: 'assets/images/image2.jpg',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likesCount: 89,
        commentsCount: 23,
        isLiked: true,
      ),
      Post(
        id: '3',
        author: _demoArtists[2],
        content: 'صباح الفن والجمال 🎨',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likesCount: 156,
        commentsCount: 8,
        isLiked: false,
      ),
      Post(
        id: '4',
        author: _demoArtists[0],
        content: 'مشاركة من ورشتي الأخيرة لتعليم أساسيات الرسم الزيتي',
        imageUrl: 'assets/images/image4.jpg',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        likesCount: 210,
        commentsCount: 45,
        isLiked: true,
      ),
    ];
    notifyListeners();
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
      notifyListeners();
    }
  }

  void addPost(String content, String? imageUrl) {
    final newPost = Post(
      id: DateTime.now().toString(),
      author: _currentUser,
      content: content,
      imageUrl: imageUrl,
      timestamp: DateTime.now(),
    );
    _posts.insert(0, newPost);
    notifyListeners();
  }

  void deletePost(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  void addComment(String postId, String content) {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      final newComment = Comment(
        id: DateTime.now().toString(),
        author: _currentUser,
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

  // Helper method for formatting date
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
}
