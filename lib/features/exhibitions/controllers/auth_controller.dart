import 'package:sanaa_artl/features/auth/controllers/user_controller.dart';

/// AuthController - وحدة تحكم المصادقة (Controller في MVC)
/// تعمل كواجهة للـ UserProvider
class AuthController {
  final UserProvider _authProvider;

  AuthController(this._authProvider);

  /// تسجيل الدخول
  Future<bool> login(String email, String password) async {
    return await _authProvider.login(email, password);
  }

  /// التسجيل
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await _authProvider.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    await _authProvider.logout();
  }

  /// تحديث الملف الشخصي
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    return await _authProvider.updateCurrentUser(userData);
  }

  /// مسح الخطأ
  void clearError() {
    _authProvider.clearError();
  }

  /// تحميل الجلسة المحفوظة
  Future<void> loadSavedSession() async {
    await _authProvider.initialize();
  }

  // Getters
  bool get isAuthenticated => _authProvider.isAuthenticated;
  bool get isLoading => _authProvider.isLoading;
  String get error => _authProvider.error ?? '';
  String get currentUserId => _authProvider.currentUserId;
}
