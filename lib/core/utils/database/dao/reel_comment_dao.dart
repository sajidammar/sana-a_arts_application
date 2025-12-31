import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

class ReelCommentDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إضافة تعليق لريلز
  Future<int> insertComment(Map<String, dynamic> comment) async {
    final db = await _dbHelper.database;
    if (comment[DatabaseConstants.colTimestamp] == null) {
      comment[DatabaseConstants.colTimestamp] = DateTime.now()
          .toIso8601String();
    }

    // تأكد من أن المعرف فريد
    comment[DatabaseConstants.colId] =
        'rc_${DateTime.now().millisecondsSinceEpoch}';

    return await db.insert(
      DatabaseConstants.tableComments,
      comment,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// الحصول على تعليقات ريلز معين
  Future<List<Map<String, dynamic>>> getCommentsByReelId(String reelId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT c.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image
      FROM ${DatabaseConstants.tableComments} c
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON c.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      WHERE c.reel_id = ?
      ORDER BY c.${DatabaseConstants.colTimestamp} DESC
    ''',
      [reelId],
    );
  }

  /// حذف تعليق
  Future<int> deleteComment(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableComments,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }
}
