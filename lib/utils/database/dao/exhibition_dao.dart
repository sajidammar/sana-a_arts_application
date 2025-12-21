import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// ExhibitionDao - Data Access Object للمعارض
class ExhibitionDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج معرض جديد
  Future<int> insertExhibition(Map<String, dynamic> exhibition) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    exhibition[DatabaseConstants.colCreatedAt] = now;
    exhibition[DatabaseConstants.colUpdatedAt] = now;

    // تحويل القائمة إلى JSON للتخزين
    if (exhibition[DatabaseConstants.colTags] is List) {
      exhibition[DatabaseConstants.colTags] = jsonEncode(
        exhibition[DatabaseConstants.colTags],
      );
    }

    return await db.insert(
      DatabaseConstants.tableExhibitions,
      exhibition,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// تحديث معرض
  Future<int> updateExhibition(
    String id,
    Map<String, dynamic> exhibition,
  ) async {
    final db = await _dbHelper.database;
    exhibition[DatabaseConstants.colUpdatedAt] = DateTime.now()
        .toIso8601String();

    if (exhibition[DatabaseConstants.colTags] is List) {
      exhibition[DatabaseConstants.colTags] = jsonEncode(
        exhibition[DatabaseConstants.colTags],
      );
    }

    return await db.update(
      DatabaseConstants.tableExhibitions,
      exhibition,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// حذف معرض
  Future<int> deleteExhibition(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableExhibitions,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// الحصول على معرض بالمعرف
  Future<Map<String, dynamic>?> getExhibitionById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isNotEmpty) {
      return _parseExhibition(results.first);
    }
    return null;
  }

  /// الحصول على جميع المعارض
  Future<List<Map<String, dynamic>>> getAllExhibitions({
    int limit = 50,
    int offset = 0,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      orderBy: '${DatabaseConstants.colStartDate} DESC',
      limit: limit,
      offset: offset,
    );

    return results.map((e) => _parseExhibition(e)).toList();
  }

  /// الحصول على المعارض النشطة
  Future<List<Map<String, dynamic>>> getActiveExhibitions({
    int limit = 20,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      where:
          '${DatabaseConstants.colIsActive} = 1 AND ${DatabaseConstants.colEndDate} >= ?',
      whereArgs: [now],
      orderBy: '${DatabaseConstants.colStartDate} ASC',
      limit: limit,
    );

    return results.map((e) => _parseExhibition(e)).toList();
  }

  /// الحصول على المعارض المميزة
  Future<List<Map<String, dynamic>>> getFeaturedExhibitions({
    int limit = 10,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      where: '${DatabaseConstants.colIsFeatured} = 1',
      orderBy: '${DatabaseConstants.colRating} DESC',
      limit: limit,
    );

    return results.map((e) => _parseExhibition(e)).toList();
  }

  /// الحصول على المعارض القادمة
  Future<List<Map<String, dynamic>>> getUpcomingExhibitions({
    int limit = 10,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();

    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      where: '${DatabaseConstants.colStartDate} > ?',
      whereArgs: [now],
      orderBy: '${DatabaseConstants.colStartDate} ASC',
      limit: limit,
    );

    return results.map((e) => _parseExhibition(e)).toList();
  }

  /// الحصول على المعارض حسب النوع
  Future<List<Map<String, dynamic>>> getExhibitionsByType(
    String type, {
    int limit = 20,
  }) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      where: '${DatabaseConstants.colType} = ?',
      whereArgs: [type],
      orderBy: '${DatabaseConstants.colStartDate} DESC',
      limit: limit,
    );

    return results.map((e) => _parseExhibition(e)).toList();
  }

  /// البحث في المعارض
  Future<List<Map<String, dynamic>>> searchExhibitions(String query) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableExhibitions,
      where:
          '${DatabaseConstants.colTitle} LIKE ? OR ${DatabaseConstants.colDescription} LIKE ? OR ${DatabaseConstants.colLocation} LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: '${DatabaseConstants.colStartDate} DESC',
    );

    return results.map((e) => _parseExhibition(e)).toList();
  }

  /// تحديث حالة الإعجاب
  Future<int> updateLikeStatus(String id, bool isLiked) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConstants.tableExhibitions,
      {DatabaseConstants.colIsLiked: isLiked ? 1 : 0},
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// حذف جميع المعارض
  Future<int> deleteAllExhibitions() async {
    final db = await _dbHelper.database;
    return await db.delete(DatabaseConstants.tableExhibitions);
  }

  /// زيادة عدد الزوار
  Future<int> incrementVisitors(String id) async {
    final db = await _dbHelper.database;
    return await db.rawUpdate(
      '''
      UPDATE ${DatabaseConstants.tableExhibitions}
      SET ${DatabaseConstants.colVisitorsCount} = ${DatabaseConstants.colVisitorsCount} + 1
      WHERE ${DatabaseConstants.colId} = ?
    ''',
      [id],
    );
  }

  /// عدد المعارض
  Future<int> getExhibitionsCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableExhibitions}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// تحويل وتحليل JSON
  Map<String, dynamic> _parseExhibition(Map<String, dynamic> exhibition) {
    final parsed = Map<String, dynamic>.from(exhibition);
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
  }
}
