import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'database_helper.dart';
import 'database_constants.dart';
import '../../models/artwork_model.dart';

class DBSeeder {
  static const _uuid = Uuid();

  // قائمة الصور كما تم اكتشافها
  static const List<String> _tImages = [
    't1.jpg',
    't2.jpg',
    't3.jpg',
    't4.jpg',
    't5.jpg',
  ];

  static const List<String> _otherImages = [
    'IMG-20251219-WA0059.jpg',
    'IMG-20251219-WA0069.jpg',
    'IMG-20251219-WA0072.jpg',
    'IMG-20251219-WA0073.jpg',
    'IMG-20251219-WA0075.jpg',
    'IMG-20251219-WA0076.jpg',
    'IMG-20251219-WA0077.jpg',
    'IMG-20251219-WA0079.jpg',
    'IMG-20251219-WA0082.jpg',
    'IMG-20251219-WA0084.jpg',
    'IMG-20251219-WA0087.jpg',
  ];

  static Future<void> seedInitialData() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    // تنظيف البيانات القديمة للتأكد من ظهور الصور الجديدة
    // هذا مهم لأن المستخدم طلب "استبدال" الصور
    await db.delete(DatabaseConstants.tableArtworks);
    await db.delete(DatabaseConstants.tableExhibitions);
    // يمكننا حذف المستخدم أيضاً إذا أردنا إعادة إنشائه، لكن لنحذف الفنان فقط ربما
    // للحفاظ على المستخدم الحالي إذا كان مسجلاً للدخول، سنبحث عن سحر أولاً

    // التحقق مما إذا كان المستخدم "سحر" موجوداً
    final userResults = await db.query(
      DatabaseConstants.tableUsers,
      where: '${DatabaseConstants.colEmail} = ?',
      whereArgs: ['sahar@sanaa.art'],
    );

    String userId;
    if (userResults.isNotEmpty) {
      userId = userResults.first[DatabaseConstants.colId] as String;
    } else {
      userId = _uuid.v4();
      final timestamp = DateTime.now().toIso8601String();
      await db.insert(DatabaseConstants.tableUsers, {
        DatabaseConstants.colId: userId,
        DatabaseConstants.colName: 'سحر الروحاني',
        DatabaseConstants.colEmail: 'sahar@sanaa.art',
        DatabaseConstants.colRole: 'artist',
        DatabaseConstants.colJoinDate: timestamp,
        DatabaseConstants.colCreatedAt: timestamp,
        DatabaseConstants.colUpdatedAt: timestamp,
      });
    }

    try {
      // الآن نقوم بتهيئة بيانات الفنان والأعمال الفنية دائماً
      await _seedSaharAlRouhani(db, userId);
    } catch (e) {
      print('Error seeding data: $e');
    }
  }

  static Future<void> _seedSaharAlRouhani(Database db, String userId) async {
    final timestamp = DateTime.now().toIso8601String();

    // 1. Create User (This step is now handled in seedInitialData)
    // final userId = _uuid.v4();
    // await db.insert(DatabaseConstants.tableUsers, {
    //   DatabaseConstants.colId: userId,
    //   DatabaseConstants.colName: 'سحر الروحاني',
    //   DatabaseConstants.colEmail: 'sahar@sanaa.art',
    //   DatabaseConstants.colRole: 'artist',
    //   DatabaseConstants.colJoinDate: timestamp,
    //   DatabaseConstants.colCreatedAt: timestamp,
    //   DatabaseConstants.colUpdatedAt: timestamp,
    // });

    // 2. Create or Update Artist Profile
    // نحذف ملف الفنان القديم إذا وجد لنعيد إنشائه
    await db.delete(
      DatabaseConstants.tableArtists,
      where: '${DatabaseConstants.colUserId} = ?',
      whereArgs: [userId],
    );

    final artistId = _uuid.v4();
    await db.insert(DatabaseConstants.tableArtists, {
      DatabaseConstants.colId: artistId,
      DatabaseConstants.colUserId: userId,
      DatabaseConstants.colBio:
          'فنانة مبدعة متخصصة في الفنون التشكيلية والتطريز',
      DatabaseConstants.colSpecialization: 'فنون متنوعة',
      DatabaseConstants.colCreatedAt: timestamp,
      DatabaseConstants.colUpdatedAt: timestamp,
    });

    // 3. Insert Artworks - Series T (Embroidery)
    for (var img in _tImages) {
      await db.insert(DatabaseConstants.tableArtworks, {
        DatabaseConstants.colId: _uuid.v4(),
        DatabaseConstants.colTitle: 'عمل تطريز فني',
        DatabaseConstants.colArtistId: artistId,
        DatabaseConstants.colDescription:
            'لوحة فنية رائعة من التطريز اليدوي الدقيق', // "اترك لك المجال لتصفها"
        DatabaseConstants.colCategory: 'تطريز',
        DatabaseConstants.colImageUrl: 'assets/images/$img',
        DatabaseConstants.colPrice:
            150.0 + (_tImages.indexOf(img) * 10), // سعر افتراضي متفاوت
        DatabaseConstants.colIsFeatured: 1,
        DatabaseConstants.colCreatedAt: timestamp,
        DatabaseConstants.colUpdatedAt: timestamp,
      });
    }

    // 4. Insert Artworks - Other Images (Painting/General)
    for (var img in _otherImages) {
      await db.insert(DatabaseConstants.tableArtworks, {
        DatabaseConstants.colId: _uuid.v4(),
        DatabaseConstants.colTitle: 'لوحة فنية',
        DatabaseConstants.colArtistId: artistId,
        DatabaseConstants.colDescription: 'عمل فني مميز للفنانة سحر الروحاني',
        DatabaseConstants.colCategory: 'رسم تشكيلي',
        DatabaseConstants.colImageUrl: 'assets/images/$img',
        DatabaseConstants.colPrice: 200.0 + (_otherImages.indexOf(img) * 15),
        DatabaseConstants.colIsFeatured:
            1, // جعل الكل مميز للعرض في الصفحة الرئيسية
        DatabaseConstants.colCreatedAt: timestamp,
        DatabaseConstants.colUpdatedAt: timestamp,
      });
    }

    // 5. Create Exhibitions
    // معرض التطريز
    await db.insert(DatabaseConstants.tableExhibitions, {
      DatabaseConstants.colId: _uuid.v4(),
      DatabaseConstants.colTitle: 'سحر الخيوط: معرض التطريز',
      DatabaseConstants.colDescription:
          'معرض خاص يعرض إبداعات الفنانة سحر الروحاني في فن التطريز اليدوي.',
      DatabaseConstants.colImageUrl: 'assets/images/t1.jpg',
      DatabaseConstants.colStartDate: timestamp,
      DatabaseConstants.colEndDate: timestamp,
      DatabaseConstants.colLocation: 'صنعاء، اليمن',
      DatabaseConstants.colCurator: 'سحر الروحاني',
      DatabaseConstants.colType: 'reality',
      DatabaseConstants.colStatus: 'مفتوح',
      DatabaseConstants.colDate: '2025/01/01',
      DatabaseConstants.colArtworksCount: _tImages.length,
      DatabaseConstants.colIsFeatured: 1,
      DatabaseConstants.colIsActive: 1,
      DatabaseConstants.colTags: 'تطريز, فن يدوي',
      DatabaseConstants.colCreatedAt: timestamp,
      DatabaseConstants.colUpdatedAt: timestamp,
    });

    // معرض الرسم
    await db.insert(DatabaseConstants.tableExhibitions, {
      DatabaseConstants.colId: _uuid.v4(),
      DatabaseConstants.colTitle: 'ألوان الروح: معرض الفن التشكيلي',
      DatabaseConstants.colDescription:
          'مجموعة مختارة من اللوحات الفنية التي تعكس رؤية الفنانة سحر الروحاني.',
      DatabaseConstants.colImageUrl: 'assets/images/image1.jpg',
      DatabaseConstants.colStartDate: timestamp,
      DatabaseConstants.colEndDate: timestamp,
      DatabaseConstants.colLocation: 'معرض افتراضي',
      DatabaseConstants.colCurator: 'سحر الروحاني',
      DatabaseConstants.colType: 'virtual',
      DatabaseConstants.colStatus: 'مفتوح',
      DatabaseConstants.colDate: '2025/02/01',
      DatabaseConstants.colArtworksCount: _otherImages.length,
      DatabaseConstants.colIsFeatured: 1,
      DatabaseConstants.colIsActive: 1,
      DatabaseConstants.colTags: 'رسم, فن تشكيلي',
      DatabaseConstants.colCreatedAt: timestamp,
      DatabaseConstants.colUpdatedAt: timestamp,
    });

    print(
      'DATABASE SEEDED SUCCESSFULLY WITH SAHAR DATA (ARTWORKS & EXHIBITIONS)',
    );
  }

  // ignore: unused_element
  static Future<void> _clearAllData(Database db) async {
    await db.delete(DatabaseConstants.tableArtworks);
    await db.delete(DatabaseConstants.tableArtists);
    await db.delete(DatabaseConstants.tableUsers);
  }
}
