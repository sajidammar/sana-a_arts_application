import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'database_constants.dart';

/// DatabaseHelper - Singleton لإدارة قاعدة البيانات
/// يتبع أفضل الممارسات للأمان والأداء
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;
  static bool _initialized = false;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  /// تهيئة databaseFactory للمنصات المكتبية
  static void _initializeDatabaseFactory() {
    if (!_initialized) {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        // Initialize ffi for desktop platforms
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      _initialized = true;
    }
  }

  /// الحصول على مثيل قاعدة البيانات
  Future<Database> get database async {
    _initializeDatabaseFactory();
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// تهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    _initializeDatabaseFactory();
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
        ${DatabaseConstants.colCvUrl} TEXT,
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
        ${DatabaseConstants.colPostId} TEXT,
        reel_id TEXT,
        ${DatabaseConstants.colAuthorId} TEXT NOT NULL,
        ${DatabaseConstants.colContent} TEXT NOT NULL,
        ${DatabaseConstants.colTimestamp} TEXT NOT NULL
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
        ${DatabaseConstants.colCvUrl} TEXT,
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
        UNIQUE(${DatabaseConstants.colFollowerId}, ${DatabaseConstants.colFollowingId})
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

    // جدول الريلز (Reels)
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableReels} (
        ${DatabaseConstants.colId} TEXT PRIMARY KEY,
        ${DatabaseConstants.colAuthorId} TEXT NOT NULL,
        ${DatabaseConstants.colAuthorName} TEXT NOT NULL,
        ${DatabaseConstants.colAuthorAvatar} TEXT,
        ${DatabaseConstants.colVideoUrl} TEXT,
        ${DatabaseConstants.colThumbnailUrl} TEXT,
        ${DatabaseConstants.colDescription} TEXT,
        ${DatabaseConstants.colLikes} INTEGER DEFAULT 0,
        ${DatabaseConstants.colCommentsCount} INTEGER DEFAULT 0,
        ${DatabaseConstants.colViews} INTEGER DEFAULT 0,
        ${DatabaseConstants.colIsLiked} INTEGER DEFAULT 0,
        ${DatabaseConstants.colTags} TEXT,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    // جدول المحادثات
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableConversations} (
        ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colReceiverId} TEXT NOT NULL,
        ${DatabaseConstants.colReceiverName} TEXT NOT NULL,
        ${DatabaseConstants.colReceiverImage} TEXT,
        ${DatabaseConstants.colLastMessage} TEXT,
        ${DatabaseConstants.colLastMessageTime} TEXT,
        ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
        ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
      )
    ''');

    // جدول الرسائل
    await db.execute('''
      CREATE TABLE ${DatabaseConstants.tableMessages} (
        ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DatabaseConstants.colConversationId} INTEGER NOT NULL,
        ${DatabaseConstants.colSenderId} TEXT NOT NULL,
        ${DatabaseConstants.colMessageText} TEXT NOT NULL,
        ${DatabaseConstants.colIsSeen} INTEGER DEFAULT 0,
        ${DatabaseConstants.colTimestamp} TEXT NOT NULL,
        FOREIGN KEY (${DatabaseConstants.colConversationId}) REFERENCES ${DatabaseConstants.tableConversations} (${DatabaseConstants.colId}) ON DELETE CASCADE
      )
    ''');
  }

  /// ترقية قاعدة البيانات (للإصدارات المستقبلية)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('🆙 Upgrading database from $oldVersion to $newVersion');
    if (oldVersion < 2) {
      debugPrint('🆙 Upgrading to version 2 (Exhibitions like column)');
      await db.execute(
        'ALTER TABLE ${DatabaseConstants.tableExhibitions} ADD COLUMN ${DatabaseConstants.colIsLiked} INTEGER DEFAULT 0',
      );
    }
    if (oldVersion < 3) {
      debugPrint('🆙 Upgrading to version 3 (Reels table)');
      // Skip creation here if we are upgrading to 4
    }
    if (oldVersion < 4) {
      debugPrint('🆙 Upgrading to version 4 (Reels table fix - No FK)');
      // Drop existing reels table if it exists to remove FK constraint
      await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.tableReels}');
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.tableReels} (
          ${DatabaseConstants.colId} TEXT PRIMARY KEY,
          ${DatabaseConstants.colAuthorId} TEXT NOT NULL,
          ${DatabaseConstants.colAuthorName} TEXT NOT NULL,
          ${DatabaseConstants.colAuthorAvatar} TEXT,
          ${DatabaseConstants.colVideoUrl} TEXT,
          ${DatabaseConstants.colThumbnailUrl} TEXT,
          ${DatabaseConstants.colDescription} TEXT,
          ${DatabaseConstants.colLikes} INTEGER DEFAULT 0,
          ${DatabaseConstants.colCommentsCount} INTEGER DEFAULT 0,
          ${DatabaseConstants.colViews} INTEGER DEFAULT 0,
          ${DatabaseConstants.colIsLiked} INTEGER DEFAULT 0,
          ${DatabaseConstants.colTags} TEXT,
          ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
          ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 5) {
      debugPrint('🆙 Upgrading to version 5 (Reels comments support)');
      await db.execute(
        'ALTER TABLE ${DatabaseConstants.tableComments} ADD COLUMN reel_id TEXT',
      );
    }
    if (oldVersion < 6) {
      debugPrint(
        '🆙 Upgrading to version 6 (Fixing comments and followers schema)',
      );

      // Fix comments table (ensure post_id is NULLable and remove restrictive FKs for demo data)
      await db.execute(
        'CREATE TABLE comments_new (id TEXT PRIMARY KEY, post_id TEXT, reel_id TEXT, author_id TEXT NOT NULL, content TEXT NOT NULL, timestamp TEXT NOT NULL)',
      );
      await db.execute(
        'INSERT INTO comments_new SELECT id, post_id, reel_id, author_id, content, timestamp FROM comments',
      );
      await db.execute('DROP TABLE comments');
      await db.execute('ALTER TABLE comments_new RENAME TO comments');

      // Fix followers table (remove FKs to allow following demo artists like "artist_1")
      await db.execute(
        'CREATE TABLE followers_new (id TEXT PRIMARY KEY, follower_id TEXT NOT NULL, following_id TEXT NOT NULL, created_at TEXT NOT NULL, UNIQUE(follower_id, following_id))',
      );
      try {
        await db.execute(
          'INSERT INTO followers_new SELECT id, follower_id, following_id, created_at FROM followers',
        );
      } catch (e) {
        debugPrint(
          'Note: No previous followers data found or error during migration: $e',
        );
      }
      await db.execute('DROP TABLE IF EXISTS followers');
      await db.execute('ALTER TABLE followers_new RENAME TO followers');
    }
    if (oldVersion < 7) {
      debugPrint('🆙 Upgrading to version 7 (Adding CV support)');
      await db.execute(
        'ALTER TABLE ${DatabaseConstants.tableUsers} ADD COLUMN ${DatabaseConstants.colCvUrl} TEXT',
      );
      await db.execute(
        'ALTER TABLE ${DatabaseConstants.tableArtists} ADD COLUMN ${DatabaseConstants.colCvUrl} TEXT',
      );
    }
    if (oldVersion < 8) {
      debugPrint('🆙 Upgrading to version 8 (Adding Chat support)');
      // جدول المحادثات
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.tableConversations} (
          ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DatabaseConstants.colReceiverId} TEXT NOT NULL,
          ${DatabaseConstants.colReceiverName} TEXT NOT NULL,
          ${DatabaseConstants.colReceiverImage} TEXT,
          ${DatabaseConstants.colLastMessage} TEXT,
          ${DatabaseConstants.colLastMessageTime} TEXT,
          ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
          ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
        )
      ''');

      // جدول الرسائل
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.tableMessages} (
          ${DatabaseConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DatabaseConstants.colConversationId} INTEGER NOT NULL,
          ${DatabaseConstants.colSenderId} TEXT NOT NULL,
          ${DatabaseConstants.colMessageText} TEXT NOT NULL,
          ${DatabaseConstants.colIsSeen} INTEGER DEFAULT 0,
          ${DatabaseConstants.colTimestamp} TEXT NOT NULL,
          FOREIGN KEY (${DatabaseConstants.colConversationId}) REFERENCES ${DatabaseConstants.tableConversations} (${DatabaseConstants.colId}) ON DELETE CASCADE
        )
      ''');
    }
    if (oldVersion < 9) {
      debugPrint('🆙 Upgrading to version 9 (Adding Admin Requests & Reports)');
      // جدول الطلبات (Requests)
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.tableRequests} (
          ${DatabaseConstants.colId} TEXT PRIMARY KEY,
          ${DatabaseConstants.colRequesterId} TEXT NOT NULL,
          ${DatabaseConstants.colRequestType} TEXT NOT NULL,
          ${DatabaseConstants.colRequestData} TEXT,
          ${DatabaseConstants.colStatus} TEXT DEFAULT 'pending',
          ${DatabaseConstants.colCreatedAt} TEXT NOT NULL,
          ${DatabaseConstants.colUpdatedAt} TEXT NOT NULL
        )
      ''');

      // جدول البلاغات (Reports)
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.tableReports} (
          ${DatabaseConstants.colId} TEXT PRIMARY KEY,
          ${DatabaseConstants.colReporterId} TEXT NOT NULL,
          ${DatabaseConstants.colTargetId} TEXT NOT NULL,
          ${DatabaseConstants.colTargetType} TEXT NOT NULL,
          ${DatabaseConstants.colReason} TEXT NOT NULL,
          ${DatabaseConstants.colStatus} TEXT DEFAULT 'pending',
          ${DatabaseConstants.colCreatedAt} TEXT NOT NULL
        )
      ''');
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
