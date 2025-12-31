import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/management_models.dart';

class ManagementDatabaseHelper {
  static final ManagementDatabaseHelper _instance =
      ManagementDatabaseHelper._internal();
  factory ManagementDatabaseHelper() => _instance;
  ManagementDatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'management_system_v2.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE academy_management (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        instructor TEXT,
        status TEXT,
        date_added TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE store_management (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_name TEXT,
        price REAL,
        stock INTEGER,
        category TEXT
      )
    ''');

    // Initial Seed Data
    await db.insert('academy_management', {
      'title': 'دورة الرسم الكلاسيكي',
      'instructor': 'ليلى علوي',
      'status': 'نشط',
      'date_added': '2025-01-01',
    });

    await db.insert('store_management', {
      'product_name': 'لوحة الغروب',
      'price': 120.0,
      'stock': 5,
      'category': 'لوحات زيتية',
    });
  }

  // Academy CRUD
  Future<int> insertAcademyItem(AcademyItem item) async {
    final db = await database;
    return await db.insert('academy_management', item.toMap());
  }

  Future<List<AcademyItem>> getAllAcademyItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'academy_management',
    );
    return List.generate(maps.length, (i) => AcademyItem.fromMap(maps[i]));
  }

  // Store CRUD
  Future<int> insertStoreProduct(ManagementProduct product) async {
    final db = await database;
    return await db.insert('store_management', product.toMap());
  }

  Future<List<ManagementProduct>> getAllStoreProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('store_management');
    return List.generate(
      maps.length,
      (i) => ManagementProduct.fromMap(maps[i]),
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'store_management',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

