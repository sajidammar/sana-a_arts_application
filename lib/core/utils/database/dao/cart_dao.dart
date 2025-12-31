import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// CartDao - Data Access Object لعناصر السلة
class CartDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إضافة عنصر للسلة
  Future<int> addToCart({
    required String userId,
    required String artworkId,
    required double price,
    int quantity = 1,
  }) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    final id = 'cart_${userId}_$artworkId';

    // التحقق من وجود العنصر
    final existing = await db.query(
      DatabaseConstants.tableCartItems,
      where: '${DatabaseConstants.colUserId} = ? AND artwork_id = ?',
      whereArgs: [userId, artworkId],
    );

    if (existing.isNotEmpty) {
      // تحديث الكمية
      final currentQty = existing.first['quantity'] as int;
      return await db.update(
        DatabaseConstants.tableCartItems,
        {
          'quantity': currentQty + quantity,
          DatabaseConstants.colUpdatedAt: now,
        },
        where: '${DatabaseConstants.colId} = ?',
        whereArgs: [existing.first[DatabaseConstants.colId]],
      );
    } else {
      // إضافة جديد
      return await db.insert(
        DatabaseConstants.tableCartItems,
        {
          DatabaseConstants.colId: id,
          DatabaseConstants.colUserId: userId,
          'artwork_id': artworkId,
          DatabaseConstants.colPrice: price,
          'quantity': quantity,
          DatabaseConstants.colCreatedAt: now,
          DatabaseConstants.colUpdatedAt: now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// إزالة عنصر من السلة
  Future<int> removeFromCart(String userId, String artworkId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableCartItems,
      where: '${DatabaseConstants.colUserId} = ? AND artwork_id = ?',
      whereArgs: [userId, artworkId],
    );
  }

  /// تحديث كمية العنصر
  Future<int> updateQuantity(
    String userId,
    String artworkId,
    int quantity,
  ) async {
    final db = await _dbHelper.database;
    if (quantity <= 0) {
      return await removeFromCart(userId, artworkId);
    }
    return await db.update(
      DatabaseConstants.tableCartItems,
      {
        'quantity': quantity,
        DatabaseConstants.colUpdatedAt: DateTime.now().toIso8601String(),
      },
      where: '${DatabaseConstants.colUserId} = ? AND artwork_id = ?',
      whereArgs: [userId, artworkId],
    );
  }

  /// الحصول على عناصر السلة لمستخدم معين
  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(
      '''
      SELECT c.*, aw.${DatabaseConstants.colTitle}, aw.${DatabaseConstants.colImageUrl},
             u.${DatabaseConstants.colName} as artist_name
      FROM ${DatabaseConstants.tableCartItems} c
      LEFT JOIN ${DatabaseConstants.tableArtworks} aw ON c.artwork_id = aw.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableArtists} a ON aw.${DatabaseConstants.colArtistId} = a.${DatabaseConstants.colId}
      LEFT JOIN ${DatabaseConstants.tableUsers} u ON a.${DatabaseConstants.colUserId} = u.${DatabaseConstants.colId}
      WHERE c.${DatabaseConstants.colUserId} = ?
      ORDER BY c.${DatabaseConstants.colCreatedAt} DESC
    ''',
      [userId],
    );
  }

  /// إفراغ السلة
  Future<int> clearCart(String userId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableCartItems,
      where: '${DatabaseConstants.colUserId} = ?',
      whereArgs: [userId],
    );
  }

  /// عدد العناصر في السلة
  Future<int> getCartItemsCount(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableCartItems} WHERE ${DatabaseConstants.colUserId} = ?',
      [userId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// إجمالي السلة
  Future<double> getCartTotal(String userId) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM(${DatabaseConstants.colPrice} * quantity) as total FROM ${DatabaseConstants.tableCartItems} WHERE ${DatabaseConstants.colUserId} = ?',
      [userId],
    );
    return (result.first['total'] as double?) ?? 0.0;
  }

  /// التحقق من وجود عنصر في السلة
  Future<bool> isInCart(String userId, String artworkId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      DatabaseConstants.tableCartItems,
      where: '${DatabaseConstants.colUserId} = ? AND artwork_id = ?',
      whereArgs: [userId, artworkId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}

