import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// PostDao - Data Access Object للمنشورات
/// يوفر عمليات CRUD آمنة للمنشورات مع دعم الترقيم الصفحي
class PostDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج منشور جديد
  Future<int> insertPost(Map<String, dynamic> post) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    post[DatabaseConstants.colCreatedAt] = now;
    post[DatabaseConstants.colUpdatedAt] = now;
    if (post[DatabaseConstants.colTimestamp] == null) {
      post[DatabaseConstants.colTimestamp] = now;
    }

    return await db.insert(
      DatabaseConstants.tablePosts,
      post,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// تحديث منشور
  Future<int> updatePost(String id, Map<String, dynamic> post) async {
    final db = await _dbHelper.database;
    post[DatabaseConstants.colUpdatedAt] = DateTime.now().toIso8601String();

    return await db.update(
      DatabaseConstants.tablePosts,
      post,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// حذف منشور
  Future<int> deletePost(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tablePosts,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// الحصول على منشور بالمعرف مع بيانات المؤلف
  Future<Map<String, dynamic>?> getPostById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT p.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image,
             u.${DatabaseConstants.colRole} as author_role,
             u.${DatabaseConstants.colMembershipLevel} as author_membership,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableLikes} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as likes_count,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableComments} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as comments_count
      FROM ${DatabaseConstants.tablePosts} p
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON p.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      WHERE p.${DatabaseConstants.colId} = ?
    ''',
      [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// الحصول على جميع المنشورات مع ترقيم صفحي
  Future<List<Map<String, dynamic>>> getAllPosts({
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT p.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image,
             u.${DatabaseConstants.colRole} as author_role,
             u.${DatabaseConstants.colMembershipLevel} as author_membership,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableLikes} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as likes_count,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableComments} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as comments_count
      FROM ${DatabaseConstants.tablePosts} p
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON p.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      ORDER BY p.${DatabaseConstants.colTimestamp} DESC
      LIMIT ? OFFSET ?
    ''',
      [limit, offset],
    );
  }

  /// الحصول على منشورات مستخدم معين
  Future<List<Map<String, dynamic>>> getPostsByUserId(
    String userId, {
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT p.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image,
             u.${DatabaseConstants.colRole} as author_role,
             u.${DatabaseConstants.colMembershipLevel} as author_membership,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableLikes} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as likes_count,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableComments} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as comments_count
      FROM ${DatabaseConstants.tablePosts} p
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON p.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      WHERE p.${DatabaseConstants.colAuthorId} = ?
      ORDER BY p.${DatabaseConstants.colTimestamp} DESC
      LIMIT ? OFFSET ?
    ''',
      [userId, limit, offset],
    );
  }

  /// البحث في المنشورات
  Future<List<Map<String, dynamic>>> searchPosts(
    String query, {
    int limit = 20,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT p.*, u.${DatabaseConstants.colName} as author_name, 
             u.${DatabaseConstants.colProfileImage} as author_image,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableLikes} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as likes_count,
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableComments} WHERE ${DatabaseConstants.colPostId} = p.${DatabaseConstants.colId}) as comments_count
      FROM ${DatabaseConstants.tablePosts} p
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON p.${DatabaseConstants.colAuthorId} = u.${DatabaseConstants.colId}
      WHERE p.${DatabaseConstants.colContent} LIKE ? OR u.${DatabaseConstants.colName} LIKE ?
      ORDER BY p.${DatabaseConstants.colTimestamp} DESC
      LIMIT ? OFFSET ?
    ''',
      ['%$query%', '%$query%', limit, offset],
    );
  }

  /// عدد المنشورات
  Future<int> getPostsCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tablePosts}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// عدد منشورات مستخدم معين
  Future<int> getUserPostsCount(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tablePosts} WHERE ${DatabaseConstants.colAuthorId} = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// التحقق من وجود إعجاب لمستخدم على منشور
  Future<bool> isPostLikedByUser(String postId, String userId) async {
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
}
