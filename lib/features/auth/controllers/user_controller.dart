import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/exhibitions/models/user.dart';
import 'package:sanaa_artl/core/utils/database/dao/user_dao.dart';
import 'package:sanaa_artl/core/utils/database/database_helper.dart';
import 'package:sanaa_artl/core/utils/database/dao/seed_data.dart';
import 'package:sanaa_artl/features/auth/data/auth_repository.dart';
import 'package:sanaa_artl/features/auth/data/auth_repository_impl.dart';

/// UserProvider - مزود بيانات المستخدم (Controller في MVC)
/// يدير المستخدم الحالي والعمليات المتعلقة بالمستخدمين
class UserProvider with ChangeNotifier {
  final UserDao _userDao = UserDao();
  final AuthRepository _authRepository = AuthRepositoryImpl();
  User? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;
  bool get isAuthenticated => _currentUser != null;
  String get currentUserId => _currentUser?.id ?? 'guest';

  /// تهيئة قاعدة البيانات والمستخدم
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    try {
      // تهيئة قاعدة البيانات
      await DatabaseHelper().database;

      // إدراج البيانات الأولية إذا لزم الأمر
      final seedData = SeedData();
      await seedData.seedAll();

      _currentUser = await _loadCurrentUser();

      _isInitialized = true;
      _error = null;
    } catch (e) {
      _error = 'فشل في تهيئة قاعدة البيانات: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تحميل المستخدم الحالي
  Future<User?> _loadCurrentUser() async {
    try {
      final userMap = await _userDao.getUserWithPreferences('current_user');
      if (userMap != null) {
        return User.fromMap(userMap);
      }
    } catch (e) {
      debugPrint('خطأ في تحميل المستخدم: $e');
    }
    return null;
  }

  /// الحصول على مستخدم بالمعرف
  Future<User?> getUserById(String id) async {
    try {
      final userMap = await _userDao.getUserWithPreferences(id);
      if (userMap != null) {
        return User.fromMap(userMap);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// الحصول على جميع الفنانين
  Future<List<User>> getArtists() async {
    try {
      final artistMaps = await _userDao.getUsersByRole('artist');
      return artistMaps.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// تحديث بيانات المستخدم الحالي
  Future<bool> updateCurrentUser(Map<String, dynamic> updates) async {
    if (_currentUser == null) return false;

    try {
      await _userDao.updateUser(_currentUser!.id, updates);
      _currentUser = await _loadCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل في تحديث البيانات: $e';
      notifyListeners();
      return false;
    }
  }

  /// تحديث تفضيلات المستخدم
  Future<bool> updatePreferences(Map<String, dynamic> preferences) async {
    if (_currentUser == null) return false;

    try {
      await _userDao.upsertUserPreferences(_currentUser!.id, preferences);
      _currentUser = await _loadCurrentUser();
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'فشل في تحديث التفضيلات: $e';
      notifyListeners();
      return false;
    }
  }

  /// البحث عن مستخدمين
  Future<List<User>> searchUsers(String query) async {
    try {
      final userMaps = await _userDao.searchUsers(query);
      return userMaps.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  /// تسجيل آخر دخول
  Future<void> recordLogin() async {
    if (_currentUser == null) return;
    await _userDao.updateLastLogin(_currentUser!.id);
  }

  /// مسح الخطأ
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      // مسح البيانات المحلية أيضاً
      await _userDao.deleteUser('current_user');
      _currentUser = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// تسجيل الدخول (يدعم الربط مع المستودع)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authRepository.login(email, password);

    return result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) async {
        _currentUser = user;
        // حفظ في قاعدة البيانات المحلية بتنسيق الجدول
        final dbMap = {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'profile_image': user.profileImage,
          'role': user.role.index == 3
              ? 'admin'
              : user.role.index == 1
              ? 'artist'
              : 'user',
          'bio': user.bio,
          'cv_url': user.cvUrl,
        };
        await _userDao.insertUser(dbMap);
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // إضافة حقل مستعار للتوافق مع بعض الأكواد القديمة
  User get user =>
      _currentUser ??
      User(
        id: 'guest',
        name: 'زائر',
        email: '',
        phone: '',
        profileImage: 'assets/images/sanaa_img_01.jpg',
        role: UserRole.user,
        joinDate: DateTime.now(),
        preferences: UserPreferences(),
        bio: 'فنان يمني مبدع يشارك أعماله على منصة صنعاء للفنون.',
      );

  /// تسجيل مستخدم جديد
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _authRepository.register({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    });

    return result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) async {
        _currentUser = user;
        // حفظ في قاعدة البيانات المحلية بتنسيق الجدول
        final dbMap = {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'profile_image': user.profileImage,
          'role': user.role.index == 3
              ? 'admin'
              : user.role.index == 1
              ? 'artist'
              : 'user',
          'bio': user.bio,
          'cv_url': user.cvUrl,
        };
        await _userDao.insertUser(dbMap);
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  /// التحقق من تسجيل الدخول (للعمليات التي تتطلب مصادقة)
  bool requireAuth(Function onNotAuthenticated) {
    if (!isAuthenticated) {
      onNotAuthenticated();
      return false;
    }
    return true;
  }
}
