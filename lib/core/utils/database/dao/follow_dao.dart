import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

class FollowDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// متابعة مستخدم
  Future<int> followUser(String followerId, String followedId) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    return await db.insert(
      DatabaseConstants.tableFollowers,
      {
        DatabaseConstants.colId: '${followerId}_$followedId',
        DatabaseConstants.colFollowerId: followerId,
        DatabaseConstants.colFollowingId: followedId,
        DatabaseConstants.colCreatedAt: now,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// إلغاء المتابعة
  Future<int> unfollowUser(String followerId, String followedId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableFollowers,
      where:
          '${DatabaseConstants.colFollowerId} = ? AND ${DatabaseConstants.colFollowingId} = ?',
      whereArgs: [followerId, followedId],
    );
  }

  /// هل يتابع المستخدم هذا الشخص؟
  Future<bool> isFollowing(String followerId, String followedId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.tableFollowers,
      where:
          '${DatabaseConstants.colFollowerId} = ? AND ${DatabaseConstants.colFollowingId} = ?',
      whereArgs: [followerId, followedId],
    );
    return result.isNotEmpty;
  }

  /// الحصول على قائمة المتابعين
  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT u.* 
      FROM ${DatabaseConstants.tableUsers} u
      JOIN ${DatabaseConstants.tableFollowers} f ON u.${DatabaseConstants.colId} = f.${DatabaseConstants.colFollowerId}
      WHERE f.${DatabaseConstants.colFollowingId} = ?
      ''',
      [userId],
    );
  }

  /// الحصول على قائمة من يتابعهم
  Future<List<Map<String, dynamic>>> getFollowing(String userId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT u.* 
      FROM ${DatabaseConstants.tableUsers} u
      JOIN ${DatabaseConstants.tableFollowers} f ON u.${DatabaseConstants.colId} = f.${DatabaseConstants.colFollowingId}
      WHERE f.${DatabaseConstants.colFollowerId} = ?
      ''',
      [userId],
    );
  }
}
