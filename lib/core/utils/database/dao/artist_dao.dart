import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// ArtistDao - Data Access Object للفنانين
class ArtistDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج فنان جديد
  Future<int> insertArtist(Map<String, dynamic> artist) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    artist[DatabaseConstants.colCreatedAt] = now;
    artist[DatabaseConstants.colUpdatedAt] = now;

    return await db.insert(
      DatabaseConstants.tableArtists,
      artist,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// تحديث بيانات فنان
  Future<int> updateArtist(String id, Map<String, dynamic> artist) async {
    final db = await _dbHelper.database;
    artist[DatabaseConstants.colUpdatedAt] = DateTime.now().toIso8601String();

    return await db.update(
      DatabaseConstants.tableArtists,
      artist,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// حذف فنان
  Future<int> deleteArtist(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableArtists,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// الحصول على فنان بالمعرف مع بيانات المستخدم
  Future<Map<String, dynamic>?> getArtistById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT a.*, u.${DatabaseConstants.colName}, u.${DatabaseConstants.colEmail}, 
             u.${DatabaseConstants.colPhone}, u.${DatabaseConstants.colProfileImage},
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableArtworks} WHERE ${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}) as artworks_count
      FROM ${DatabaseConstants.tableArtists} a
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE a.${DatabaseConstants.colId} = ?
    ''',
      [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// الحصول على فنان بمعرف المستخدم
  Future<Map<String, dynamic>?> getArtistByUserId(String userId) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT a.*, u.${DatabaseConstants.colName}, u.${DatabaseConstants.colEmail}, 
             u.${DatabaseConstants.colPhone}, u.${DatabaseConstants.colProfileImage}
      FROM ${DatabaseConstants.tableArtists} a
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE a.${DatabaseConstants.colUserId} = ?
    ''',
      [userId],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// الحصول على جميع الفنانين
  Future<List<Map<String, dynamic>>> getAllArtists({
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT a.*, u.${DatabaseConstants.colName}, u.${DatabaseConstants.colProfileImage},
             (SELECT COUNT(*) FROM ${DatabaseConstants.tableArtworks} WHERE ${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}) as artworks_count
      FROM ${DatabaseConstants.tableArtists} a
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      ORDER BY a.${DatabaseConstants.colRating} DESC, u.${DatabaseConstants.colName} ASC
      LIMIT ? OFFSET ?
    ''',
      [limit, offset],
    );
  }

  /// الحصول على الفنانين الموثقين
  Future<List<Map<String, dynamic>>> getVerifiedArtists({
    int limit = 20,
  }) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT a.*, u.${DatabaseConstants.colName}, u.${DatabaseConstants.colProfileImage}
      FROM ${DatabaseConstants.tableArtists} a
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE a.${DatabaseConstants.colIsVerified} = 1
      ORDER BY a.${DatabaseConstants.colRating} DESC
      LIMIT ?
    ''',
      [limit],
    );
  }

  /// البحث في الفنانين
  Future<List<Map<String, dynamic>>> searchArtists(String query) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT a.*, u.${DatabaseConstants.colName}, u.${DatabaseConstants.colProfileImage}
      FROM ${DatabaseConstants.tableArtists} a
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE u.${DatabaseConstants.colName} LIKE ? OR a.${DatabaseConstants.colSpecialization} LIKE ?
      ORDER BY u.${DatabaseConstants.colName} ASC
    ''',
      ['%$query%', '%$query%'],
    );
  }

  /// تحديث عدد المتابعين
  Future<int> updateFollowersCount(String id, int count) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConstants.tableArtists,
      {DatabaseConstants.colFollowers: count},
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// عدد الفنانين
  Future<int> getArtistsCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableArtists}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}

