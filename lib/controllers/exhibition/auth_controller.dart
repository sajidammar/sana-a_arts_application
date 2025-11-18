import 'package:sanaa_artl/providers/exhibition/auth_provider.dart';


class AuthController {
  final AuthProvider _authProvider;

  AuthController(this._authProvider);

  Future<void> login(String email, String password) async {
    await _authProvider.login(email, password);
  }

  Future<void> register(String name, String email, String password, String phone) async {
    await _authProvider.register(name, email, password, phone);
  }

  Future<void> logout() async {
    await _authProvider.logout();
  }

  Future<void> updateProfile(Map<String, dynamic> userData) async {
    // This would be implemented to update the user profile
    // For now, we'll just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }

  void clearError() {
    _authProvider.clearError();
  }

  void addToFavorites(String itemId, FavoriteType type) {
    _authProvider.addToFavorites(itemId, type);
  }

  void removeFromFavorites(String itemId, FavoriteType type) {
    _authProvider.removeFromFavorites(itemId, type);
  }

  bool isFavorite(String itemId, FavoriteType type) {
    return _authProvider.isFavorite(itemId, type);
  }

  // Getters
  bool get isAuthenticated => _authProvider.isAuthenticated;
  bool get isLoading => _authProvider.isLoading;
  String get error => _authProvider.error;
}