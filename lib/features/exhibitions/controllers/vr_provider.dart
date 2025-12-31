import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/exhibitions/models/artwork.dart';

class VRProvider with ChangeNotifier {
  int _currentArtworkIndex = 0;
  bool _isVRMode = false;
  bool _is360Mode = false;
  bool _is3DMode = false;
  bool _isAudioGuideOn = false;
  bool _isAutoTourOn = false;
  bool _isFullscreenMode = false;
  int _userRating = 0;
  double _zoomLevel = 1.0;
  List<Artwork> _artworks = [];
  bool _isLoading = false;
  String _error = '';
  double _rotationX = 0.0;
  double _rotationY = 0.0;
  List<ArtworkComment> _comments = [];
  String _newComment = '';
  final List<Map<String, dynamic>> _cartItems = [];
  final Map<String, dynamic> _currentArtist = {
    'name': 'أحمد الصنعاني',
    'specialty': 'فنان تشكيلي معاصر',
    'bio':
        'فنان تشكيلي يمني، متخصص في الفنون التشكيلية المعاصرة. يتميز بأسلوبه الفريد في دمج التراث اليمني مع الفن الحديث، وقد شارك في العديد من المعارض المحلية والدولية.',
    'artworksCount': 45,
    'exhibitionsCount': 12,
    'awardsCount': 8,
    'email': 'artist@sanaaarts.com',
    'phone': '+967 777 777 777',
    'location': 'صنعاء، اليمن',
    'artworks': [
      {'title': 'تراث صنعاء', 'year': '2024'},
      {'title': 'ألوان اليمن', 'year': '2023'},
      {'title': 'روح المدينة', 'year': '2023'},
      {'title': 'جمال الطبيعة', 'year': '2022'},
    ],
    'exhibitions': [
      {'name': 'معرض صنعاء الدولي', 'year': '2024'},
      {'name': 'معرض الفن المعاصر', 'year': '2023'},
      {'name': 'معرض الفن اليمني', 'year': '2022'},
    ],
  };

  int get currentArtworkIndex => _currentArtworkIndex;
  bool get isVRMode => _isVRMode;
  bool get is360Mode => _is360Mode;
  bool get is3DMode => _is3DMode;
  bool get isAudioGuideOn => _isAudioGuideOn;
  bool get isAutoTourOn => _isAutoTourOn;
  bool get isFullscreenMode => _isFullscreenMode;
  int get userRating => _userRating;
  double get zoomLevel => _zoomLevel;
  List<Artwork> get artworks => _artworks;
  bool get isLoading => _isLoading;
  String get error => _error;
  double get rotationX => _rotationX;
  double get rotationY => _rotationY;
  List<ArtworkComment> get comments => _comments;
  String get newComment => _newComment;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  Map<String, dynamic> get currentArtist => _currentArtist;

  Artwork get currentArtwork {
    if (_artworks.isEmpty) {
      return Artwork(
        id: '0',
        title: 'لا توجد أعمال',
        artist: '',
        artistId: '',
        year: 2024,
        technique: '',
        dimensions: '',
        description: '',
        rating: 0,
        ratingCount: 0,
        price: 0,
        currency: '\$',
        category: '',
        tags: [],
        imageUrl: '',
        createdAt: DateTime.now(),
      );
    }
    return _artworks[_currentArtworkIndex];
  }

  void setCurrentArtworkIndex(int index) {
    if (index >= 0 && index < _artworks.length) {
      _currentArtworkIndex = index;
      _userRating = 0; // Reset rating when changing artwork
      _loadCommentsForCurrentArtwork();
      notifyListeners();
    }
  }

  void toggleVRMode() {
    _isVRMode = !_isVRMode;
    notifyListeners();
  }

  void toggle360Mode() {
    _is360Mode = !_is360Mode;
    notifyListeners();
  }

  void toggle3DMode() {
    _is3DMode = !_is3DMode;
    notifyListeners();
  }

  void toggleAudioGuide() {
    _isAudioGuideOn = !_isAudioGuideOn;
    notifyListeners();
  }

  void toggleAutoTour() {
    _isAutoTourOn = !_isAutoTourOn;
    if (_isAutoTourOn) {
      _startAutoTour();
    } else {
      _stopAutoTour();
    }
    notifyListeners();
  }

  void toggleFullscreenMode() {
    _isFullscreenMode = !_isFullscreenMode;
    notifyListeners();
  }

  void setUserRating(int rating) {
    _userRating = rating;
    notifyListeners();
  }

  void setZoomLevel(double level) {
    if (level >= 0.5 && level <= 5.0) {
      _zoomLevel = level;
      notifyListeners();
    }
  }

  void setRotation(double x, double y) {
    _rotationX = x;
    _rotationY = y;
    notifyListeners();
  }

  void setNewComment(String comment) {
    _newComment = comment;
    notifyListeners();
  }

  void zoomIn() {
    if (_zoomLevel < 5.0) {
      _zoomLevel += 0.25;
      notifyListeners();
    }
  }

  void zoomOut() {
    if (_zoomLevel > 0.5) {
      _zoomLevel -= 0.25;
      notifyListeners();
    }
  }

  void resetView() {
    _zoomLevel = 1.0;
    _rotationX = 0.0;
    _rotationY = 0.0;
    _userRating = 0;
    notifyListeners();
  }

  void navigateToNextArtwork() {
    if (_artworks.isNotEmpty) {
      _currentArtworkIndex = (_currentArtworkIndex + 1) % _artworks.length;
      _userRating = 0;
      _loadCommentsForCurrentArtwork();
      notifyListeners();
    }
  }

  void navigateToPreviousArtwork() {
    if (_artworks.isNotEmpty) {
      _currentArtworkIndex = _currentArtworkIndex == 0
          ? _artworks.length - 1
          : _currentArtworkIndex - 1;
      _userRating = 0;
      _loadCommentsForCurrentArtwork();
      notifyListeners();
    }
  }

  Future<void> loadArtworks(List<Artwork> artworks) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _artworks = artworks;
      _currentArtworkIndex = 0;
      _loadCommentsForCurrentArtwork();
      _error = '';
    } catch (e) {
      _error = 'فشل في تحميل الأعمال الفنية: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addComment(String comment) {
    if (comment.trim().isNotEmpty) {
      final newComment = ArtworkComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        userName: 'أنت',
        comment: comment.trim(),
        createdAt: DateTime.now(),
        likes: 0,
        replies: [],
      );

      _comments.insert(0, newComment);
      _newComment = '';
      notifyListeners();
    }
  }

  void rateArtwork(int rating) {
    _userRating = rating;
    // في التطبيق الحقيقي، سيتم إرسال التقييم إلى الخادم
    notifyListeners();
  }

  void likeComment(String commentId) {
    final commentIndex = _comments.indexWhere(
      (comment) => comment.id == commentId,
    );
    if (commentIndex != -1) {
      final updatedComment = ArtworkComment(
        id: _comments[commentIndex].id,
        userId: _comments[commentIndex].userId,
        userName: _comments[commentIndex].userName,
        comment: _comments[commentIndex].comment,
        createdAt: _comments[commentIndex].createdAt,
        likes: _comments[commentIndex].likes + 1,
        replies: _comments[commentIndex].replies,
      );

      _comments[commentIndex] = updatedComment;
      notifyListeners();
    }
  }

  void deleteComment(String commentId) {
    _comments.removeWhere((comment) => comment.id == commentId);
    notifyListeners();
  }

  void reportComment(String commentId, String reason) {
    // في التطبيق الحقيقي، سيتم إرسال التقرير إلى الخادم
    // يمكن أيضاً إخفاء التعليق من قائمة المستخدم
    notifyListeners();
  }

  void editComment(String commentId, String newText) {
    final commentIndex = _comments.indexWhere(
      (comment) => comment.id == commentId,
    );
    if (commentIndex != -1 && newText.trim().isNotEmpty) {
      final updatedComment = ArtworkComment(
        id: _comments[commentIndex].id,
        userId: _comments[commentIndex].userId,
        userName: _comments[commentIndex].userName,
        comment: newText.trim(),
        createdAt: _comments[commentIndex].createdAt,
        likes: _comments[commentIndex].likes,
        replies: _comments[commentIndex].replies,
      );

      _comments[commentIndex] = updatedComment;
      notifyListeners();
    }
  }

  void _loadCommentsForCurrentArtwork() {
    // محاكاة تحميل التعليقات للعمل الفني الحالي
    _comments = [
      ArtworkComment(
        id: '1',
        userId: 'user1',
        userName: 'سارة العريقي',
        comment: 'عمل رائع يجسد روح التراث اليمني',
        createdAt: DateTime(2024, 1, 15, 14, 30),
        likes: 5,
        replies: [],
      ),
      ArtworkComment(
        id: '2',
        userId: 'user2',
        userName: 'محمد الأهدل',
        comment: 'الألوان والتفاصيل مذهلة!',
        createdAt: DateTime(2024, 1, 14, 10, 15),
        likes: 3,
        replies: [],
      ),
    ];
  }

  // الجولة التلقائية
  Timer? _autoTourTimer;

  void _startAutoTour() {
    _autoTourTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_isAutoTourOn && _artworks.isNotEmpty) {
        navigateToNextArtwork();
      } else {
        timer.cancel();
      }
    });
  }

  void _stopAutoTour() {
    _autoTourTimer?.cancel();
    _autoTourTimer = null;
  }

  void addToFavorites() {
    // سيتم تمرير context من الخارج لاستخدام WishlistProvider
    // لذا سنحتفظ ببيانات المعرض كمتغير
    final currentExhibition = {
      'id': 'exhibition_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'معرض تراث صنعاء الخالد',
      'description': 'معرض افتراضي يعرض التراث اليمني الأصيل',
      'type': 'exhibition',
      'artworkCount': artworks.length,
      'addedAt': DateTime.now().toIso8601String(),
    };

    // سيتم استخدام هذا من الخارج
    _lastExhibitionToAdd = currentExhibition;
    notifyListeners();
  }

  Map<String, dynamic>? _lastExhibitionToAdd;
  Map<String, dynamic>? get lastExhibitionToAdd => _lastExhibitionToAdd;

  void clearLastExhibitionToAdd() {
    _lastExhibitionToAdd = null;
    notifyListeners();
  }

  void addToCart() {
    // إضافة العمل الفني الحالي إلى السلة
    final artwork = currentArtwork;
    final cartItem = {
      'id': int.parse(artwork.id),
      'title': artwork.title,
      'artist': artwork.artist,
      'price': artwork.price.toDouble(),
      'imageUrl': artwork.imageUrl,
    };

    // التحقق من عدم وجود العمل في السلة مسبقاً
    final exists = _cartItems.any((item) => item['id'] == cartItem['id']);
    if (!exists) {
      _cartItems.add(cartItem);
    }
    notifyListeners();
  }

  void removeFromCart(int itemId) {
    _cartItems.removeWhere((item) => item['id'] == itemId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void downloadHighRes() {
    // في التطبيق الحقيقي، سيتم بدء تحميل نسخة عالية الجودة
    notifyListeners();
  }

  void viewArtistProfile() {
    // في التطبيق الحقيقي، سيتم الانتقال إلى صفحة الفنان
    notifyListeners();
  }

  void shareArtwork() {
    // في التطبيق الحقيقي، سيتم مشاركة العمل
    notifyListeners();
  }

  @override
  void dispose() {
    _stopAutoTour();
    super.dispose();
  }
}


