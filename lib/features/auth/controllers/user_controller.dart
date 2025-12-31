import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/exhibitions/models/user.dart';
import 'package:sanaa_artl/core/utils/database/dao/user_dao.dart';
import 'package:sanaa_artl/core/utils/database/database_helper.dart';
import 'package:sanaa_artl/core/utils/database/dao/seed_data.dart';

/// UserProvider - مزود بيانات المستخدم (Controller في MVC)
/// يدير المستخدم الحالي والعمليات المتعلقة بالمستخدمين
class UserProvider with ChangeNotifier {
  final UserDao _userDao = UserDao();
  User? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

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

      // تحميل المستخدم الحالي (محلياً)
      await _loadCurrentUser();

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
  Future<void> _loadCurrentUser() async {
    try {
      final userMap = await _userDao.getUserWithPreferences('current_user');
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
      }
    } catch (e) {
      debugPrint('خطأ في تحميل المستخدم: $e');
    }
  }

  /// الحصول على مستخدم بالمعرف
  Future<User?> getUserById(String id) async {
    try {
      final userMap = await _userDao.getUserWithPreferences(id);
      if (userMap != null) {
        return User.fromMap(userMap);
      }
    } catch (e) {
      debugPrint('خطأ في جلب المستخدم: $e');
    }
    return null;
  }

  /// الحصول على جميع الفنانين
  Future<List<User>> getArtists() async {
    try {
      final artistMaps = await _userDao.getUsersByRole('artist');
      return artistMaps.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      debugPrint('خطأ في جلب الفنانين: $e');
      return [];
    }
  }

  /// تحديث بيانات المستخدم الحالي
  Future<bool> updateCurrentUser(Map<String, dynamic> updates) async {
    if (_currentUser == null) return false;

    try {
      await _userDao.updateUser(_currentUser!.id, updates);
      await _loadCurrentUser();
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
      await _loadCurrentUser();
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
      debugPrint('خطأ في البحث: $e');
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
}


