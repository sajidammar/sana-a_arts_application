import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// LikeDao - Data Access Object للإعجابات
class LikeDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// تبديل الإعجاب (إضافة/إزالة)
  Future<bool> toggleLike(String postId, String userId) async {
    final db = await _dbHelper.database;

    // التحقق من وجود إعجاب سابق
    final existing = await db.query(
      DatabaseConstants.tableLikes,
      where:
          '${DatabaseConstants.colPostId} = ? AND ${DatabaseConstants.colUserId} = ?',
      whereArgs: [postId, userId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      // إزالة الإعجاب
      await db.delete(
        DatabaseConstants.tableLikes,
        where:
            '${DatabaseConstants.colPostId} = ? AND ${DatabaseConstants.colUserId} = ?',
        whereArgs: [postId, userId],
      );
      return false; // لم يعد معجباً
    } else {
      // إضافة إعجاب
      await db.insert(DatabaseConstants.tableLikes, {
        DatabaseConstants.colId: 'like_${userId}_$postId',
        DatabaseConstants.colPostId: postId,
        DatabaseConstants.colUserId: userId,
        DatabaseConstants.colCreatedAt: DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.ignore);
      return true; // أصبح معجباً
    }
  }

  /// التحقق من وجود إعجاب
  Future<bool> isLikedByUser(String postId, String userId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.tableLikes,
      where:
          '${DatabaseConstants.colPostId} = ? AND ${DatabaseConstants.colUserId} = ?',
      whereArgs: [postId, userId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// عدد الإعجابات لمنشور معين
  Future<int> getLikesCount(String postId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableLikes} WHERE ${DatabaseConstants.colPostId} = ?',
      [postId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// الحصول على قائمة المعجبين بمنشور
  Future<List<Map<String, dynamic>>> getLikersByPostId(String postId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT u.${DatabaseConstants.colId}, u.${DatabaseConstants.colName}, u.${DatabaseConstants.colProfileImage}
      FROM ${DatabaseConstants.tableLikes} l
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON l.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE l.${DatabaseConstants.colPostId} = ?
      ORDER BY l.${DatabaseConstants.colCreatedAt} DESC
    ''',
      [postId],
    );
  }

  /// الحصول على المنشورات التي أعجب بها مستخدم معين
  Future<List<String>> getLikedPostIds(String userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableLikes,
      columns: [DatabaseConstants.colPostId],
      where: '${DatabaseConstants.colUserId} = ?',
      whereArgs: [userId],
    );
    return results
        .map((r) => r[DatabaseConstants.colPostId] as String)
        .toList();
  }

  /// إزالة جميع إعجابات منشور (يتم تلقائياً بسبب CASCADE)
  Future<int> removeLikesByPostId(String postId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableLikes,
      where: '${DatabaseConstants.colPostId} = ?',
      whereArgs: [postId],
    );
  }
}
