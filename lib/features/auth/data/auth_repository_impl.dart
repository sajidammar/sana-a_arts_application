import 'package:shared_preferences/shared_preferences.dart';
import 'package:sanaa_artl/core/errors/failures.dart';
import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/exhibitions/models/user.dart';
import 'package:sanaa_artl/core/utils/database/dao/user_dao.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final UserDao _userDao = UserDao();

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final userMap = await _userDao.getUserWithPreferences('current_user');
      if (userMap != null) {
        final user = User.fromMap(userMap);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('user_id', user.id);
        return Result.success(user);
      }
      return const Result.failure(DatabaseFailure('المستخدم غير موجود'));
    } catch (e) {
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<User>> register(Map<String, dynamic> userData) async {
    try {
      await _userDao.insertUser(userData);
      final user = User.fromMap(userData);
      return Result.success(user);
    } catch (e) {
      return Result.failure(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<User>> getCurrentSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      if (isLoggedIn) {
        final userId = prefs.getString('user_id');
        if (userId != null) {
          final userMap = await _userDao.getUserWithPreferences(userId);
          if (userMap != null) {
            return Result.success(User.fromMap(userMap));
          }
        }
      }
      return const Result.failure(CacheFailure('لا توجد جلسة نشطة'));
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }
}
