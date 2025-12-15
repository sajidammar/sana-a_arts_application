import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// نوع العنصر في المفضلة
enum WishlistItemType { artwork, exhibition, artist }

/// WishlistDao - Data Access Object للمفضلة
class WishlistDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إضافة عنصر للمفضلة
  Future<int> addToWishlist({
    required String userId,
    required String itemId,
    required WishlistItemType itemType,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final id = 'wish_${userId}_${itemType.name}_$itemId';

    return await db.insert(DatabaseConstants.tableWishlist, {
      DatabaseConstants.colId: id,
      DatabaseConstants.colUserId: userId,
      'item_id': itemId,
      'item_type': itemType.name,
      DatabaseConstants.colCreatedAt: now,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// إزالة عنصر من المفضلة
  Future<int> removeFromWishlist({
    required String userId,
    required String itemId,
    required WishlistItemType itemType,
  }) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableWishlist,
      where:
          '${DatabaseConstants.colUserId} = ? AND item_id = ? AND item_type = ?',
      whereArgs: [userId, itemId, itemType.name],
    );
  }

  /// تبديل حالة المفضلة
  Future<bool> toggleWishlist({
    required String userId,
    required String itemId,
    required WishlistItemType itemType,
  }) async {
    final isInWishlist = await isInWishlistCheck(
      userId: userId,
      itemId: itemId,
      itemType: itemType,
    );

    if (isInWishlist) {
      await removeFromWishlist(
        userId: userId,
        itemId: itemId,
        itemType: itemType,
      );
      return false;
    } else {
      await addToWishlist(userId: userId, itemId: itemId, itemType: itemType);
      return true;
    }
  }

  /// التحقق من وجود عنصر في المفضلة
  Future<bool> isInWishlistCheck({
    required String userId,
    required String itemId,
    required WishlistItemType itemType,
  }) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.tableWishlist,
      where:
          '${DatabaseConstants.colUserId} = ? AND item_id = ? AND item_type = ?',
      whereArgs: [userId, itemId, itemType.name],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// الحصول على الأعمال الفنية في المفضلة
  Future<List<Map<String, dynamic>>> getWishlistArtworks(String userId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT w.*, aw.*, u.${DatabaseConstants.colName} as artist_name
      FROM ${DatabaseConstants.tableWishlist} w
      LEFT JOIN ${DatabaseConstants.tableArtworks} aw ON w.item_id = aw.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE w.${DatabaseConstants.colUserId} = ? AND w.item_type = 'artwork'
      ORDER BY w.${DatabaseConstants.colCreatedAt} DESC
    ''',
      [userId],
    );
  }

  /// الحصول على جميع عناصر المفضلة
  Future<List<Map<String, dynamic>>> getAllWishlistItems(String userId) async {
    final db = await _dbHelper.database;
    return await db.query(
      DatabaseConstants.tableWishlist,
      where: '${DatabaseConstants.colUserId} = ?',
      whereArgs: [userId],
      orderBy: '${DatabaseConstants.colCreatedAt} DESC',
    );
  }

  /// إفراغ المفضلة
  Future<int> clearWishlist(String userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableWishlist,
      where: '${DatabaseConstants.colUserId} = ?',
      whereArgs: [userId],
    );
  }

  /// عدد العناصر في المفضلة
  Future<int> getWishlistCount(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableWishlist} WHERE ${DatabaseConstants.colUserId} = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// الحصول على معرفات الأعمال الفنية في المفضلة
  Future<List<String>> getWishlistArtworkIds(String userId) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableWishlist,
      columns: ['item_id'],
      where: '${DatabaseConstants.colUserId} = ? AND item_type = ?',
      whereArgs: [userId, 'artwork'],
    );
    return results.map((r) => r['item_id'] as String).toList();
  }
}
