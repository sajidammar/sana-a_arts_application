import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/exhibition/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _error = '';

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // محاكاة عملية تسجيل الدخول
      await Future.delayed(const Duration(seconds: 2));

      if (email == 'demo@example.com' && password == 'password') {
        _currentUser = User(
          id: '1',
          name: 'مستخدم تجريبي',
          email: email,
          phone: '+967123456789',
          profileImage: '',
          role: UserRole.user,
          joinDate: DateTime.now(),
          lastLogin: DateTime.now(),
          preferences: UserPreferences(),
        );
        _isAuthenticated = true;
        _error = '';
      } else {
        _error = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      }
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(String name, String email, String password, String phone) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // محاكاة عملية التسجيل
      await Future.delayed(const Duration(seconds: 2));

      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
        profileImage: '',
        role: UserRole.user,
        joinDate: DateTime.now(),
        preferences: UserPreferences(),
      );
      _isAuthenticated = true;
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء التسجيل: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // محاكاة عملية تسجيل الخروج
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = null;
      _isAuthenticated = false;
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      // محاكاة عملية تحديث الملف الشخصي
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = updatedUser;
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء تحديث الملف الشخصي: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void addToFavorites(String itemId, FavoriteType type) {
    if (_currentUser != null) {
      final user = _currentUser!;
      List<String> favorites = [];

      switch (type) {
        case FavoriteType.artwork:
          favorites = List.from(user.favoriteArtworks);
          if (!favorites.contains(itemId)) {
            favorites.add(itemId);
          }
          break;
        case FavoriteType.artist:
          favorites = List.from(user.favoriteArtists);
          if (!favorites.contains(itemId)) {
            favorites.add(itemId);
          }
          break;
        case FavoriteType.exhibition:
          favorites = List.from(user.favoriteExhibitions);
          if (!favorites.contains(itemId)) {
            favorites.add(itemId);
          }
          break;
      }

      _currentUser = user.copyWith(
        favoriteArtworks: type == FavoriteType.artwork ? favorites : user.favoriteArtworks,
        favoriteArtists: type == FavoriteType.artist ? favorites : user.favoriteArtists,
        favoriteExhibitions: type == FavoriteType.exhibition ? favorites : user.favoriteExhibitions,
      );
      notifyListeners();
    }
  }

  void removeFromFavorites(String itemId, FavoriteType type) {
    if (_currentUser != null) {
      final user = _currentUser!;
      List<String> favorites = [];

      switch (type) {
        case FavoriteType.artwork:
          favorites = List.from(user.favoriteArtworks);
          favorites.remove(itemId);
          break;
        case FavoriteType.artist:
          favorites = List.from(user.favoriteArtists);
          favorites.remove(itemId);
          break;
        case FavoriteType.exhibition:
          favorites = List.from(user.favoriteExhibitions);
          favorites.remove(itemId);
          break;
      }

      _currentUser = user.copyWith(
        favoriteArtworks: type == FavoriteType.artwork ? favorites : user.favoriteArtworks,
        favoriteArtists: type == FavoriteType.artist ? favorites : user.favoriteArtists,
        favoriteExhibitions: type == FavoriteType.exhibition ? favorites : user.favoriteExhibitions,
      );
      notifyListeners();
    }
  }

  bool isFavorite(String itemId, FavoriteType type) {
    if (_currentUser == null) return false;

    switch (type) {
      case FavoriteType.artwork:
        return _currentUser!.favoriteArtworks.contains(itemId);
      case FavoriteType.artist:
        return _currentUser!.favoriteArtists.contains(itemId);
      case FavoriteType.exhibition:
        return _currentUser!.favoriteExhibitions.contains(itemId);
    }
  }
}

enum FavoriteType {
  artwork,
  artist,
  exhibition,
}

extension UserCopyWith on User {
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    UserRole? role,
    DateTime? joinDate,
    DateTime? lastLogin,
    List<String>? favoriteArtworks,
    List<String>? favoriteArtists,
    List<String>? favoriteExhibitions,
    List<PurchaseHistory>? purchaseHistory,
    UserPreferences? preferences,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    int? points,
    String? membershipLevel,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      joinDate: joinDate ?? this.joinDate,
      lastLogin: lastLogin ?? this.lastLogin,
      favoriteArtworks: favoriteArtworks ?? this.favoriteArtworks,
      favoriteArtists: favoriteArtists ?? this.favoriteArtists,
      favoriteExhibitions: favoriteExhibitions ?? this.favoriteExhibitions,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
      preferences: preferences ?? this.preferences,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      points: points ?? this.points,
      membershipLevel: membershipLevel ?? this.membershipLevel,
    );
  }
}