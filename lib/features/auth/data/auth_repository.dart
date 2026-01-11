import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/exhibitions/models/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);
  Future<Result<User>> register(Map<String, dynamic> userData);
  Future<Result<void>> logout();
  Future<Result<User>> getCurrentSession();
}
