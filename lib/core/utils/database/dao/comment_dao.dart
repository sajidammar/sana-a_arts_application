import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// CommentDao - Data Access Object للتعليقات
class CommentDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج تعليق جديد
  Future<int> insertComment(Map<String, dynamic> comment) async {
    final db = await _dbHelper.database;
    if (comment[DatabaseConstants.colTimestamp] == null) {
      comment[DatabaseConstants.colTimestamp] = DateTime.now()
          .toIso8601String();
    }

    return await db.insert(
      DatabaseConstants.tableComments,
      comment,
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  /// الحصول على تعليقات منشور معين
  Future<List<Map<String, dynamic>>> getCommentsByPostId(String postId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT c.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image,
             u.${DatabaseConstants.colRole} as author_role
      FROM ${DatabaseConstants.tableComments} c
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON c.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      WHERE c.${DatabaseConstants.colPostId} = ?
      ORDER BY c.${DatabaseConstants.colTimestamp} ASC
    ''',
      [postId],
    );
  }

  /// الحصول على تعليق بالمعرف
  Future<Map<String, dynamic>?> getCommentById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT c.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image
      FROM ${DatabaseConstants.tableComments} c
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON c.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      WHERE c.${DatabaseConstants.colId} = ?
    ''',
      [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// عدد تعليقات منشور معين
  Future<int> getCommentsCount(String postId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableComments} WHERE ${DatabaseConstants.colPostId} = ?',
      [postId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// حذف جميع تعليقات منشور (يتم تلقائياً بسبب CASCADE)
  Future<int> deleteCommentsByPostId(String postId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableComments,
      where: '${DatabaseConstants.colPostId} = ?',
      whereArgs: [postId],
    );
  }
}

