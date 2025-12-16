import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sanaa_artl/models/exhibition/user.dart';
import 'package:sanaa_artl/utils/database/dao/user_dao.dart';
import 'package:sanaa_artl/utils/database/database_constants.dart';

/// أنواع المفضلات
enum FavoriteType { artwork, artist, exhibition }

/// AuthProvider - مزود المصادقة (Controller في MVC)
/// يدير تسجيل الدخول والخروج والتسجيل مع قاعدة البيانات
class AuthProvider with ChangeNotifier {
  final UserDao _userDao = UserDao();

  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String _error = '';
  static const String _userIdKey = 'logged_in_user_id';

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String get error => _error;
  String get currentUserId => _currentUser?.id ?? 'guest';

  /// تحميل جلسة المستخدم المحفوظة
  Future<void> loadSavedSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString(_userIdKey);

      if (savedUserId != null) {
        final userMap = await _userDao.getUserWithPreferences(savedUserId);
        if (userMap != null) {
          _currentUser = User.fromMap(userMap);
          _isAuthenticated = true;
          await _userDao.updateLastLogin(savedUserId);
        }
      }
    } catch (e) {
      debugPrint('خطأ في تحميل الجلسة: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تسجيل الدخول
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // البحث عن المستخدم بالبريد الإلكتروني
      final userMap = await _userDao.getUserByEmail(email);

      if (userMap != null) {
        // في التطبيق الحقيقي، يجب التحقق من كلمة المرور المشفرة
        // هنا نقبل أي كلمة مرور للتجربة
        _currentUser = User.fromMap(userMap);
        _isAuthenticated = true;

        // حفظ الجلسة
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, _currentUser!.id);

        // تحديث آخر تسجيل دخول
        await _userDao.updateLastLogin(_currentUser!.id);

        _error = '';
        notifyListeners();
        return true;
      } else {
        _error = 'البريد الإلكتروني غير مسجل';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'حدث خطأ أثناء تسجيل الدخول: ${e.toString()}';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تسجيل مستخدم جديد
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // التحقق من عدم وجود مستخدم بنفس البريد
      final existingUser = await _userDao.getUserByEmail(email);
      if (existingUser != null) {
        _error = 'البريد الإلكتروني مسجل مسبقاً';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // إنشاء معرف جديد
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      // إدراج المستخدم الجديد
      await _userDao.insertUser({
        DatabaseConstants.colId: userId,
        DatabaseConstants.colName: name,
        DatabaseConstants.colEmail: email,
        DatabaseConstants.colPhone: phone,
        DatabaseConstants.colProfileImage: '',
        DatabaseConstants.colRole: 'user',
        DatabaseConstants.colJoinDate: DateTime.now().toIso8601String(),
        DatabaseConstants.colIsEmailVerified: 0,
        DatabaseConstants.colPoints: 0,
        DatabaseConstants.colMembershipLevel: 'عادي',
      });

      // تسجيل الدخول تلقائياً
      final userMap = await _userDao.getUserWithPreferences(userId);
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
        _isAuthenticated = true;

        // حفظ الجلسة
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userIdKey, userId);
      }

      _error = '';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء التسجيل: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // مسح الجلسة المحفوظة
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);

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

  /// تحديث الملف الشخصي
  Future<bool> updateProfile(Map<String, dynamic> updates) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _userDao.updateUser(_currentUser!.id, updates);

      // إعادة تحميل بيانات المستخدم
      final userMap = await _userDao.getUserWithPreferences(_currentUser!.id);
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
      }

      _error = '';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'حدث خطأ أثناء التحديث: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// مسح الخطأ
  void clearError() {
    _error = '';
    notifyListeners();
  }

  /// التحقق من تسجيل الدخول (للعمليات التي تتطلب مصادقة)
  bool requireAuth(Function onNotAuthenticated) {
    if (!_isAuthenticated) {
      onNotAuthenticated();
      return false;
    }
    return true;
  }
}

/// امتداد User لإضافة copyWith
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
