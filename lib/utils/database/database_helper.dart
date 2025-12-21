import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'database_constants.dart';

/// DatabaseHelper - Singleton لإدارة قاعدة البيانات
/// يتبع أفضل الممارسات للأمان والأداء
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// الحصول على مثيل قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// تهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DatabaseConstants.databaseName);

    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// تكوين قاعدة البيانات (تفعيل المفاتيح الأجنبية)
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// إنشاء الجداول
  Future<void> _onCreate(Database db, int version) async {
    // جدول المستخدمين
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableUsers} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colName} TEXT NOT NULL,
        ${DatabaseConstants.colEmail} TEXT UNIQUE NOT NULL,
        ${DatabaseConstants.colPhone} TEXT,
        ${DatabaseConstants.colProfileImage} TEXT,
        ${DatabaseConstants.colRole} TEXT DEFAULT 'user',
        ${DatabaseConstants.colJoinDate} TEXT NOT NULL,
        ${DatabaseConstants.colLastLogin} TEXT,
        ${DatabaseConstants.colIsEmailVerified} INTEGER DEFAULT 0,
        ${DatabaseConstants.colIsPhoneVerified} INTEGER DEFAULT 0,
        ${DatabaseConstants.colPoints} INTEGER DEFAULT 0,
        ${DatabaseConstants.colMembershipLevel} TEXT DEFAULT 'عادي',
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    // فهرس على البريد الإلكتروني للبحث السريع
    await db.execute('''
      CREATE INDEX idx_users_email ON ${DatabaseConstants.tableUsers} (${DatabaseConstants.colEmail})
    ''');

    // جدول تفضيلات المستخدمين
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableUserPreferences} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserId} TEXT UNIQUE NOT NULL,
        ${DatabaseConstants.colDarkMode} INTEGER DEFAULT 0,
        ${DatabaseConstants.colNotifications} INTEGER DEFAULT 1,
        ${DatabaseConstants.colEmailNotifications} INTEGER DEFAULT 1,
        ${DatabaseConstants.colSmsNotifications} INTEGER DEFAULT 0,
        ${DatabaseConstants.colLanguage} TEXT DEFAULT 'ar',
        ${DatabaseConstants.colCurrency} TEXT DEFAULT '\$',
        ${DatabaseConstants.colThemeColor} TEXT DEFAULT 'gold',
        FOREIGN KEY (${DatabaseConstants.colUserId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // جدول المنشورات
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tablePosts} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colAuthorId} TEXT NOT NULL,
        ${DatabaseConstants.colContent} TEXT NOT NULL,
        ${DatabaseConstants.colImageUrl} TEXT,
        ${DatabaseConstants.colTimestamp} TEXT NOT NULL,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colAuthorId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // فهرس على المنشورات حسب المؤلف
    await db.execute('''
      CREATE INDEX idx_posts_author ON ${DatabaseConstants.tablePosts} (${DatabaseConstants.colAuthorId})
    ''');

    // فهرس على المنشورات حسب الوقت
    await db.execute('''
      CREATE INDEX idx_posts_timestamp ON ${DatabaseConstants.tablePosts} (${DatabaseConstants.colTimestamp} DESC)
    ''');

    // جدول التعليقات
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableComments} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colPostId} TEXT NOT NULL,
        ${DatabaseConstants.colAuthorId} TEXT NOT NULL,
        ${DatabaseConstants.colContent} TEXT NOT NULL,
        ${DatabaseConstants.colTimestamp} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colPostId}) REFERENCES ${DatabaseConstants.tablePosts} (${DatabaseConstants.colId}) ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.colAuthorId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // فهرس على التعليقات حسب المنشور
    await db.execute('''
      CREATE INDEX idx_comments_post ON ${DatabaseConstants.tableComments} (${DatabaseConstants.colPostId})
    ''');

    // جدول الإعجابات
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableLikes} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserId} TEXT NOT NULL,
        ${DatabaseConstants.colPostId} TEXT NOT NULL,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        UNIQUE(${DatabaseConstants.colUserId}, ${DatabaseConstants.colPostId}),
        FOREIGN KEY (${DatabaseConstants.colUserId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.colPostId}) REFERENCES ${DatabaseConstants.tablePosts} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // جدول الفنانين
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableArtists} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserId} TEXT UNIQUE NOT NULL,
        ${DatabaseConstants.colBio} TEXT,
        ${DatabaseConstants.colSpecialization} TEXT,
        ${DatabaseConstants.colYearsOfExperience} INTEGER DEFAULT 0,
        ${DatabaseConstants.colLocation} TEXT,
        ${DatabaseConstants.colWebsite} TEXT,
        ${DatabaseConstants.colRating} REAL DEFAULT 0,
        ${DatabaseConstants.colRatingCount} INTEGER DEFAULT 0,
        ${DatabaseConstants.colFollowers} INTEGER DEFAULT 0,
        ${DatabaseConstants.colIsVerified} INTEGER DEFAULT 0,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colUserId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // جدول الأعمال الفنية
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableArtworks} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colTitle} TEXT NOT NULL,
        ${DatabaseConstants.colArtistId} TEXT NOT NULL,
        ${DatabaseConstants.colYear} INTEGER,
        ${DatabaseConstants.colTechnique} TEXT,
        ${DatabaseConstants.colDimensions} TEXT,
        ${DatabaseConstants.colDescription} TEXT,
        ${DatabaseConstants.colPrice} REAL DEFAULT 0,
        ${DatabaseConstants.colCurrency} TEXT DEFAULT '\$',
        ${DatabaseConstants.colCategory} TEXT,
        ${DatabaseConstants.colTags} TEXT,
        ${DatabaseConstants.colImageUrl} TEXT,
        ${DatabaseConstants.colIsFeatured} INTEGER DEFAULT 0,
        ${DatabaseConstants.colIsForSale} INTEGER DEFAULT 1,
        ${DatabaseConstants.colViews} INTEGER DEFAULT 0,
        ${DatabaseConstants.colLikes} INTEGER DEFAULT 0,
        ${DatabaseConstants.colRating} REAL DEFAULT 0,
        ${DatabaseConstants.colRatingCount} INTEGER DEFAULT 0,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colArtistId}) REFERENCES ${DatabaseConstants.tableArtists} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // فهرس على الأعمال الفنية حسب الفنان
    await db.execute('''
      CREATE INDEX idx_artworks_artist ON ${DatabaseConstants.tableArtworks} (${DatabaseConstants.colArtistId})
    ''');

    // فهرس على الأعمال المميزة
    await db.execute('''
      CREATE INDEX idx_artworks_featured ON ${DatabaseConstants.tableArtworks} (${DatabaseConstants.colIsFeatured})
    ''');

    // جدول المعارض
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableExhibitions} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colTitle} TEXT NOT NULL,
        ${DatabaseConstants.colDescription} TEXT,
        ${DatabaseConstants.colImageUrl} TEXT,
        ${DatabaseConstants.colStartDate} TEXT NOT NULL,
        ${DatabaseConstants.colEndDate} TEXT NOT NULL,
        ${DatabaseConstants.colLocation} TEXT,
        ${DatabaseConstants.colCurator} TEXT,
        ${DatabaseConstants.colType} TEXT DEFAULT 'virtual',
        ${DatabaseConstants.colStatus} TEXT,
        ${DatabaseConstants.colDate} TEXT,
        ${DatabaseConstants.colArtworksCount} INTEGER DEFAULT 0,
        ${DatabaseConstants.colVisitorsCount} INTEGER DEFAULT 0,
        ${DatabaseConstants.colIsFeatured} INTEGER DEFAULT 0,
        ${DatabaseConstants.colIsActive} INTEGER DEFAULT 1,
        ${DatabaseConstants.colRating} REAL DEFAULT 0,
        ${DatabaseConstants.colRatingCount} INTEGER DEFAULT 0,
        ${DatabaseConstants.colTags} TEXT,
        ${DatabaseConstants.colIsLiked} INTEGER DEFAULT 0,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    // جدول المتابعين
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableFollowers} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colFollowerId} TEXT NOT NULL,
        ${DatabaseConstants.colFollowingId} TEXT NOT NULL,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        UNIQUE(${DatabaseConstants.colFollowerId}, ${DatabaseConstants.colFollowingId}),
        FOREIGN KEY (${DatabaseConstants.colFollowerId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE,
        FOREIGN KEY (${DatabaseConstants.colFollowingId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // جدول إعجابات الأعمال الفنية
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableArtworkLikes} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserId} TEXT NOT NULL,
        artwork_id TEXT NOT NULL,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        UNIQUE(${DatabaseConstants.colUserId}, artwork_id),
        FOREIGN KEY (${DatabaseConstants.colUserId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE,
        FOREIGN KEY (artwork_id) REFERENCES ${DatabaseConstants.tableArtworks} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // جدول عناصر السلة
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableCartItems} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserId} TEXT NOT NULL,
        artwork_id TEXT NOT NULL,
        quantity INTEGER DEFAULT 1,
        ${DatabaseConstants.colPrice} REAL NOT NULL,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL,
        UNIQUE(${DatabaseConstants.colUserId}, artwork_id),
        FOREIGN KEY (${DatabaseConstants.colUserId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE,
        FOREIGN KEY (artwork_id) REFERENCES ${DatabaseConstants.tableArtworks} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // جدول المفضلة
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableWishlist} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colUserId} TEXT NOT NULL,
        item_id TEXT NOT NULL,
        item_type TEXT NOT NULL,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        UNIQUE(${DatabaseConstants.colUserId}, item_id, item_type),
        FOREIGN KEY (${DatabaseConstants.colUserId}) REFERENCES ${DatabaseConstants.tableUsers} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');
  }

  /// ترقية قاعدة البيانات (للإصدارات المستقبلية)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE ${DatabaseConstants.tableExhibitions} ADD COLUMN ${DatabaseConstants.colIsLiked} INTEGER DEFAULT 0',
      );
    }
  }

  /// إغلاق قاعدة البيانات
  Future<void> close() async {
    final db = await database;
    db.close();
    _database = null;
  }

  /// حذف قاعدة البيانات (للاختبار فقط)
  Future<void> deleteDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DatabaseConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// التحقق من وجود قاعدة البيانات
  Future<bool> databaseExists() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DatabaseConstants.databaseName);
    return await databaseFactory.databaseExists(path);
  }
}
