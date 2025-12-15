import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// ArtworkDao - Data Access Object للأعمال الفنية
class ArtworkDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج عمل فني جديد
  Future<int> insertArtwork(Map<String, dynamic> artwork) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    artwork[DatabaseConstants.colCreatedAt] = now;
    artwork[DatabaseConstants.colUpdatedAt] = now;

    // تحويل القائمة إلى JSON للتخزين
    if (artwork[DatabaseConstants.colTags] is List) {
      artwork[DatabaseConstants.colTags] = jsonEncode(
        artwork[DatabaseConstants.colTags],
      );
    }

    return await db.insert(
      DatabaseConstants.tableArtworks,
      artwork,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// تحديث عمل فني
  Future<int> updateArtwork(String id, Map<String, dynamic> artwork) async {
    final db = await _dbHelper.database;
    artwork[DatabaseConstants.colUpdatedAt] = DateTime.now().toIso8601String();

    if (artwork[DatabaseConstants.colTags] is List) {
      artwork[DatabaseConstants.colTags] = jsonEncode(
        artwork[DatabaseConstants.colTags],
      );
    }

    return await db.update(
      DatabaseConstants.tableArtworks,
      artwork,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// حذف عمل فني
  Future<int> deleteArtwork(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableArtworks,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// الحصول على عمل فني بالمعرف
  Future<Map<String, dynamic>?> getArtworkById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name, u.${DatabaseConstants.colProfileImage} as artist_image
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE aw.${DatabaseConstants.colId} = ?
    ''',
      [id],
    );

    if (results.isNotEmpty) {
      final artwork = Map<String, dynamic>.from(results.first);
      // تحويل JSON إلى قائمة
      if (artwork[DatabaseConstants.colTags] != null &&
          artwork[DatabaseConstants.colTags] is String) {
        artwork[DatabaseConstants.colTags] = jsonDecode(
          artwork[DatabaseConstants.colTags],
        );
      }
      return artwork;
    }
    return null;
  }

  /// الحصول على جميع الأعمال الفنية
  Future<List<Map<String, dynamic>>> getAllArtworks({
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name, u.${DatabaseConstants.colProfileImage} as artist_image
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      ORDER BY aw.${DatabaseConstants.colCreatedAt} DESC
      LIMIT ? OFFSET ?
    ''',
      [limit, offset],
    );

    return _parseArtworksList(results);
  }

  /// الحصول على أعمال فنان معين
  Future<List<Map<String, dynamic>>> getArtworksByArtistId(
    String artistId, {
    int limit = 50,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name, u.${DatabaseConstants.colProfileImage} as artist_image
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE aw.${DatabaseConstants.colArtistId} = ?
      ORDER BY aw.${DatabaseConstants.colCreatedAt} DESC
      LIMIT ?
    ''',
      [artistId, limit],
    );

    return _parseArtworksList(results);
  }

  /// الحصول على الأعمال المميزة
  Future<List<Map<String, dynamic>>> getFeaturedArtworks({
    int limit = 10,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name, u.${DatabaseConstants.colProfileImage} as artist_image
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE aw.${DatabaseConstants.colIsFeatured} = 1
      ORDER BY aw.${DatabaseConstants.colRating} DESC
      LIMIT ?
    ''',
      [limit],
    );

    return _parseArtworksList(results);
  }

  /// الحصول على الأعمال المعروضة للبيع
  Future<List<Map<String, dynamic>>> getArtworksForSale({
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name, u.${DatabaseConstants.colProfileImage} as artist_image
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE aw.${DatabaseConstants.colIsForSale} = 1
      ORDER BY aw.${DatabaseConstants.colCreatedAt} DESC
      LIMIT ? OFFSET ?
    ''',
      [limit, offset],
    );

    return _parseArtworksList(results);
  }

  /// البحث في الأعمال الفنية
  Future<List<Map<String, dynamic>>> searchArtworks(String query) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE aw.${DatabaseConstants.colTitle} LIKE ? 
         OR aw.${DatabaseConstants.colDescription} LIKE ?
         OR u.${DatabaseConstants.colName} LIKE ?
         OR aw.${DatabaseConstants.colCategory} LIKE ?
      ORDER BY aw.${DatabaseConstants.colRating} DESC
    ''',
      ['%$query%', '%$query%', '%$query%', '%$query%'],
    );

    return _parseArtworksList(results);
  }

  /// الحصول على أعمال حسب الفئة
  Future<List<Map<String, dynamic>>> getArtworksByCategory(
    String category, {
    int limit = 50,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT aw.*, u.${DatabaseConstants.colName} as artist_name
      FROM ${DatabaseConstants.tableArtworks} aw
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE aw.${DatabaseConstants.colCategory} = ?
      ORDER BY aw.${DatabaseConstants.colCreatedAt} DESC
      LIMIT ?
    ''',
      [category, limit],
    );

    return _parseArtworksList(results);
  }

  /// زيادة عدد المشاهدات
  Future<int> incrementViews(String id) async {
    final db = await _dbHelper.database;
    return await db.rawUpdate(
      '''
      UPDATE ${DatabaseConstants.tableArtworks}
      SET ${DatabaseConstants.colViews} = ${DatabaseConstants.colViews} + 1
      WHERE ${DatabaseConstants.colId} = ?
    ''',
      [id],
    );
  }

  /// عدد الأعمال الفنية
  Future<int> getArtworksCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableArtworks}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// تحويل النتائج وتحليل JSON
  List<Map<String, dynamic>> _parseArtworksList(
    List<Map<String, dynamic>> results,
  ) {
    return results.map((artwork) {
      final parsed = Map<String, dynamic>.from(artwork);
      if (parsed[DatabaseConstants.colTags] != null &&
          parsed[DatabaseConstants.colTags] is String) {
        try {
          parsed[DatabaseConstants.colTags] = jsonDecode(
            parsed[DatabaseConstants.colTags],
          );
        } catch (_) {
          parsed[DatabaseConstants.colTags] = [];
        }
      }
      return parsed;
    }).toList();
  }
}
