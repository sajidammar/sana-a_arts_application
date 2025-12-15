import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_constants.dart';

/// UserDao - Data Access Object للمستخدمين
/// يوفر عمليات CRUD آمنة للمستخدمين
class UserDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// إدراج مستخدم جديد
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await _dbHelper.database;
    final now = DateTime.now().toIso8601String();
    user[DatabaseConstants.colCreatedAt] = now;
    user[DatabaseConstants.colUpdatedAt] = now;

    return await db.insert(
      DatabaseConstants.tableUsers,
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// تحديث بيانات المستخدم
  Future<int> updateUser(String id, Map<String, dynamic> user) async {
    final db = await _dbHelper.database;
    user[DatabaseConstants.colUpdatedAt] = DateTime.now().toIso8601String();

    return await db.update(
      DatabaseConstants.tableUsers,
      user,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// حذف مستخدم
  Future<int> deleteUser(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// الحصول على مستخدم بالمعرف
  Future<Map<String, dynamic>?> getUserById(String id) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// الحصول على مستخدم بالبريد الإلكتروني
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;
    final results = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colEmail} = ?',
      whereArgs: [email],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// الحصول على جميع المستخدمين
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _dbHelper.database;
    return await db.query(
      DatabaseConstants.tableUsers,
      orderBy: '${DatabaseConstants.colName} ASC',
    );
  }

  /// الحصول على المستخدمين حسب الدور
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    final db = await _dbHelper.database;
    return await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colRole} = ?',
      whereArgs: [role],
      orderBy: '${DatabaseConstants.colName} ASC',
    );
  }

  /// الحصول على المستخدم مع تفضيلاته
  Future<Map<String, dynamic>?> getUserWithPreferences(String id) async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      '''
      SELECT u.*, p.${DatabaseConstants.colDarkMode}, p.${DatabaseConstants.colNotifications},
             p.${DatabaseConstants.colEmailNotifications}, p.${DatabaseConstants.colSmsNotifications},
             p.${DatabaseConstants.colLanguage}, p.${DatabaseConstants.colCurrency}, p.${DatabaseConstants.colThemeColor}
      FROM ${DatabaseConstants.tableUsers} u
      LEFT JOIN ${DatabaseConstants.tableUserPreferences} p ON u.${DatabaseConstants.colId} = p.${DatabaseConstants.colUserId}
      WHERE u.${DatabaseConstants.colId} = ?
    ''',
      [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// إدراج أو تحديث تفضيلات المستخدم
  Future<int> upsertUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    final db = await _dbHelper.database;
    preferences[DatabaseConstants.colUserId] = userId;
    preferences[DatabaseConstants.colId] = 'pref_$userId';

    return await db.insert(
      DatabaseConstants.tableUserPreferences,
      preferences,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// البحث عن مستخدمين
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    final db = await _dbHelper.database;
    return await db.query(
      DatabaseConstants.tableUsers,
      where:
          '${DatabaseConstants.colName} LIKE ? OR ${DatabaseConstants.colEmail} LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: '${DatabaseConstants.colName} ASC',
    );
  }

  /// تحديث آخر تسجيل دخول
  Future<int> updateLastLogin(String id) async {
    final db = await _dbHelper.database;
    return await db.update(
      DatabaseConstants.tableUsers,
      {DatabaseConstants.colLastLogin: DateTime.now().toIso8601String()},
      where: '${DatabaseConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  /// عدد المستخدمين
  Future<int> getUsersCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM ${DatabaseConstants.tableUsers}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
