import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// ReelDao - Data Access Object للريلز (Reels)
class ReelDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج Reel جديد
  Future<int> insertReel(Map<String, dynamic> reel) async {
    try {
      final db = await _dbHelper.database;
      final now = DateTime.now().toIso8601String();
      reel[DatabaseConstants.colCreatedAt] = now;
      reel[DatabaseConstants.colUpdatedAt] = now;

      if (reel[DatabaseConstants.colTags] is List) {
        reel[DatabaseConstants.colTags] = jsonEncode(
          reel[DatabaseConstants.colTags],
        );
      }

      final result = await db.insert(
        DatabaseConstants.tableReels,
        reel,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// الحصول على جميع الريلز
  Future<List<Map<String, dynamic>>> getAllReels() async {
    try {
      final db = await _dbHelper.database;
      final results = await db.query(
        DatabaseConstants.tableReels,
        orderBy: '${DatabaseConstants.colCreatedAt} DESC',
      );
      return results.map((e) => _parseReel(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// حذف Reel
  Future<int> deleteReel(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableReels,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// تحديث حالة الإعجاب
  Future<int> toggleLike(String id, bool isLiked) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConstants.tableReels,
      {DatabaseConstants.colIsLiked: isLiked ? 1 : 0},
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// زيادة عدد المشاهدات
  Future<int> incrementViews(String id) async {
    final db = await _dbHelper.database;
    return await db.rawUpdate(
      'UPDATE ${DatabaseConstants.tableReels} SET ${DatabaseConstants.colViews} = ${DatabaseConstants.colViews} + 1 WHERE ${DatabaseConstants.colId} = ?',
      [id],
    );
  }

  /// زيادة عدد التعليقات
  Future<int> incrementCommentsCount(String id) async {
    final db = await _dbHelper.database;
    return await db.rawUpdate(
      'UPDATE ${DatabaseConstants.tableReels} SET ${DatabaseConstants.colCommentsCount} = ${DatabaseConstants.colCommentsCount} + 1 WHERE ${DatabaseConstants.colId} = ?',
      [id],
    );
  }

  /// حذف جميع الريلز
  Future<int> deleteAllReels() async {
    final db = await _dbHelper.database;
    return await db.delete(DatabaseConstants.tableReels);
  }

  /// تحويل وتحليل JSON
  Map<String, dynamic> _parseReel(Map<String, dynamic> reel) {
    final parsed = Map<String, dynamic>.from(reel);
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
