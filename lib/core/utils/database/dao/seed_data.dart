import '../database_helper.dart';
import '../database_constants.dart';
import 'user_dao.dart';
import 'post_dao.dart';
import 'artist_dao.dart';
import 'artwork_dao.dart';
import 'exhibition_dao.dart';

/// SeedData - بيانات وهمية لتهيئة قاعدة البيانات
/// تُستخدم عند أول تشغيل للتطبيق
class SeedData {
  final UserDao _userDao = UserDao();
  final PostDao _postDao = PostDao();
  final ArtistDao _artistDao = ArtistDao();
  final ArtworkDao _artworkDao = ArtworkDao();
  final ExhibitionDao _exhibitionDao = ExhibitionDao();

  /// التحقق من الحاجة للبيانات الأولية
  Future<bool> needsSeeding() async {
    final count = await _userDao.getUsersCount();
    return count == 0;
  }

  /// إدراج جميع البيانات الأولية
  Future<void> seedAll() async {
    if (!await needsSeeding()) return;

    await _seedUsers();
    await _seedArtists();
    await _seedArtworks();
    await _seedExhibitions();
    await _seedPosts();
  }

  /// بيانات المستخدمين
  Future<void> _seedUsers() async {
    final users = [
      {
        DatabaseConstants.colId: 'user_1',
        DatabaseConstants.colName: 'أحمد المقطري',
        DatabaseConstants.colEmail: 'ahmed@art.com',
        DatabaseConstants.colPhone: '+967771234567',
        DatabaseConstants.colProfileImage: 'assets/images/image5.jpg',
        DatabaseConstants.colRole: 'artist',
        DatabaseConstants.colJoinDate: DateTime(2023, 1, 15).toIso8601String(),
        DatabaseConstants.colIsEmailVerified: 1,
        DatabaseConstants.colPoints: 1500,
        DatabaseConstants.colMembershipLevel: 'محترف',
      },
      {
        DatabaseConstants.colId: 'user_2',
        DatabaseConstants.colName: 'فاطمة الحمادي',
        DatabaseConstants.colEmail: 'fatima@art.com',
        DatabaseConstants.colPhone: '+967772345678',
        DatabaseConstants.colProfileImage: 'assets/images/image6.jpg',
        DatabaseConstants.colRole: 'artist',
        DatabaseConstants.colJoinDate: DateTime(2023, 3, 20).toIso8601String(),
        DatabaseConstants.colIsEmailVerified: 1,
        DatabaseConstants.colPoints: 2200,
        DatabaseConstants.colMembershipLevel: 'موهوب',
      },
      {
        DatabaseConstants.colId: 'user_3',
        DatabaseConstants.colName: 'سارة العريقي',
        DatabaseConstants.colEmail: 'sara@art.com',
        DatabaseConstants.colPhone: '+967773456789',
        DatabaseConstants.colProfileImage: 'assets/images/image3.jpg',
        DatabaseConstants.colRole: 'artist',
        DatabaseConstants.colJoinDate: DateTime(2024, 1, 10).toIso8601String(),
        DatabaseConstants.colIsEmailVerified: 1,
        DatabaseConstants.colPoints: 800,
        DatabaseConstants.colMembershipLevel: 'صاعد',
      },
      {
        DatabaseConstants.colId: 'user_4',
        DatabaseConstants.colName: 'محمد الصنعاني',
        DatabaseConstants.colEmail: 'mohammed@example.com',
        DatabaseConstants.colPhone: '+967774567890',
        DatabaseConstants.colProfileImage: 'assets/images/image7.jpg',
        DatabaseConstants.colRole: 'user',
        DatabaseConstants.colJoinDate: DateTime(2024, 6, 1).toIso8601String(),
        DatabaseConstants.colIsEmailVerified: 1,
        DatabaseConstants.colPoints: 350,
        DatabaseConstants.colMembershipLevel: 'عادي',
      },
      {
        DatabaseConstants.colId: 'current_user',
        DatabaseConstants.colName: 'المستخدم الحالي',
        DatabaseConstants.colEmail: 'user@example.com',
        DatabaseConstants.colPhone: '+967775678901',
        DatabaseConstants.colProfileImage: 'assets/images/image7.jpg',
        DatabaseConstants.colRole: 'user',
        DatabaseConstants.colJoinDate: DateTime.now().toIso8601String(),
        DatabaseConstants.colIsEmailVerified: 0,
        DatabaseConstants.colPoints: 100,
        DatabaseConstants.colMembershipLevel: 'عادي',
      },
    ];

    for (final user in users) {
      await _userDao.insertUser(user);
    }
  }

  /// بيانات الفنانين
  Future<void> _seedArtists() async {
    final artists = [
      {
        DatabaseConstants.colId: 'artist_1',
        DatabaseConstants.colUserId: 'user_1',
        DatabaseConstants.colBio:
            'فنان تشكيلي يمني متخصص في الفن الزيتي والمائي، أعمالي مستوحاة من التراث اليمني الأصيل',
        DatabaseConstants.colSpecialization: 'رسم زيتي',
        DatabaseConstants.colYearsOfExperience: 12,
        DatabaseConstants.colLocation: 'صنعاء، اليمن',
        DatabaseConstants.colWebsite: 'https://ahmed-art.com',
        DatabaseConstants.colRating: 4.8,
        DatabaseConstants.colRatingCount: 156,
        DatabaseConstants.colFollowers: 1250,
        DatabaseConstants.colIsVerified: 1,
      },
      {
        DatabaseConstants.colId: 'artist_2',
        DatabaseConstants.colUserId: 'user_2',
        DatabaseConstants.colBio:
            'فنانة شغوفة بالفن التجريدي والتعبيري، أسعى لنقل المشاعر من خلال الألوان',
        DatabaseConstants.colSpecialization: 'فن تجريدي',
        DatabaseConstants.colYearsOfExperience: 8,
        DatabaseConstants.colLocation: 'عدن، اليمن',
        DatabaseConstants.colWebsite: '',
        DatabaseConstants.colRating: 4.9,
        DatabaseConstants.colRatingCount: 203,
        DatabaseConstants.colFollowers: 1890,
        DatabaseConstants.colIsVerified: 1,
      },
      {
        DatabaseConstants.colId: 'artist_3',
        DatabaseConstants.colUserId: 'user_3',
        DatabaseConstants.colBio:
            'فنانة ناشئة تستكشف عالم الفن الرقمي والتقليدي',
        DatabaseConstants.colSpecialization: 'فن رقمي',
        DatabaseConstants.colYearsOfExperience: 3,
        DatabaseConstants.colLocation: 'تعز، اليمن',
        DatabaseConstants.colWebsite: '',
        DatabaseConstants.colRating: 4.5,
        DatabaseConstants.colRatingCount: 45,
        DatabaseConstants.colFollowers: 320,
        DatabaseConstants.colIsVerified: 0,
      },
    ];

    for (final artist in artists) {
      await _artistDao.insertArtist(artist);
    }
  }

  /// بيانات الأعمال الفنية
  Future<void> _seedArtworks() async {
    final artworks = [
      {
        DatabaseConstants.colId: 'artwork_1',
        DatabaseConstants.colTitle: 'صنعاء القديمة',
        DatabaseConstants.colArtistId: 'artist_1',
        DatabaseConstants.colYear: 2024,
        DatabaseConstants.colTechnique: 'زيت على قماش',
        DatabaseConstants.colDimensions: '80x60 سم',
        DatabaseConstants.colDescription:
            'لوحة تصور جمال العمارة اليمنية التقليدية في صنعاء القديمة',
        DatabaseConstants.colPrice: 1500.0,
        DatabaseConstants.colCurrency: '\$',
        DatabaseConstants.colCategory: 'منظر طبيعي',
        DatabaseConstants.colTags: ['صنعاء', 'تراث', 'عمارة'],
        DatabaseConstants.colImageUrl: 'assets/images/image1.jpg',
        DatabaseConstants.colIsFeatured: 1,
        DatabaseConstants.colIsForSale: 1,
        DatabaseConstants.colViews: 1250,
        DatabaseConstants.colLikes: 89,
        DatabaseConstants.colRating: 4.8,
        DatabaseConstants.colRatingCount: 32,
      },
      {
        DatabaseConstants.colId: 'artwork_2',
        DatabaseConstants.colTitle: 'ألوان الروح',
        DatabaseConstants.colArtistId: 'artist_2',
        DatabaseConstants.colYear: 2024,
        DatabaseConstants.colTechnique: 'أكريليك على قماش',
        DatabaseConstants.colDimensions: '100x80 سم',
        DatabaseConstants.colDescription: 'تعبير تجريدي عن مشاعر الحرية والأمل',
        DatabaseConstants.colPrice: 2200.0,
        DatabaseConstants.colCurrency: '\$',
        DatabaseConstants.colCategory: 'تجريدي',
        DatabaseConstants.colTags: ['تجريدي', 'ألوان', 'تعبيري'],
        DatabaseConstants.colImageUrl: 'assets/images/image2.jpg',
        DatabaseConstants.colIsFeatured: 1,
        DatabaseConstants.colIsForSale: 1,
        DatabaseConstants.colViews: 980,
        DatabaseConstants.colLikes: 156,
        DatabaseConstants.colRating: 4.9,
        DatabaseConstants.colRatingCount: 45,
      },
      {
        DatabaseConstants.colId: 'artwork_3',
        DatabaseConstants.colTitle: 'وجوه يمنية',
        DatabaseConstants.colArtistId: 'artist_1',
        DatabaseConstants.colYear: 2023,
        DatabaseConstants.colTechnique: 'زيت على قماش',
        DatabaseConstants.colDimensions: '60x50 سم',
        DatabaseConstants.colDescription: 'بورتريهات تصور ملامح الإنسان اليمني',
        DatabaseConstants.colPrice: 1200.0,
        DatabaseConstants.colCurrency: '\$',
        DatabaseConstants.colCategory: 'بورتريه',
        DatabaseConstants.colTags: ['بورتريه', 'يمن', 'وجوه'],
        DatabaseConstants.colImageUrl: 'assets/images/image3.jpg',
        DatabaseConstants.colIsFeatured: 0,
        DatabaseConstants.colIsForSale: 1,
        DatabaseConstants.colViews: 750,
        DatabaseConstants.colLikes: 67,
        DatabaseConstants.colRating: 4.7,
        DatabaseConstants.colRatingCount: 28,
      },
      {
        DatabaseConstants.colId: 'artwork_4',
        DatabaseConstants.colTitle: 'حلم رقمي',
        DatabaseConstants.colArtistId: 'artist_3',
        DatabaseConstants.colYear: 2024,
        DatabaseConstants.colTechnique: 'فن رقمي',
        DatabaseConstants.colDimensions: 'رقمي',
        DatabaseConstants.colDescription:
            'عمل فني رقمي يمزج بين الواقع والخيال',
        DatabaseConstants.colPrice: 500.0,
        DatabaseConstants.colCurrency: '\$',
        DatabaseConstants.colCategory: 'رقمي',
        DatabaseConstants.colTags: ['رقمي', 'خيال', 'حديث'],
        DatabaseConstants.colImageUrl: 'assets/images/image4.jpg',
        DatabaseConstants.colIsFeatured: 0,
        DatabaseConstants.colIsForSale: 1,
        DatabaseConstants.colViews: 420,
        DatabaseConstants.colLikes: 45,
        DatabaseConstants.colRating: 4.4,
        DatabaseConstants.colRatingCount: 15,
      },
      {
        DatabaseConstants.colId: 'artwork_5',
        DatabaseConstants.colTitle: 'غروب عدن',
        DatabaseConstants.colArtistId: 'artist_2',
        DatabaseConstants.colYear: 2023,
        DatabaseConstants.colTechnique: 'ألوان مائية',
        DatabaseConstants.colDimensions: '50x40 سم',
        DatabaseConstants.colDescription: 'منظر غروب الشمس على شاطئ عدن',
        DatabaseConstants.colPrice: 800.0,
        DatabaseConstants.colCurrency: '\$',
        DatabaseConstants.colCategory: 'منظر طبيعي',
        DatabaseConstants.colTags: ['عدن', 'غروب', 'بحر'],
        DatabaseConstants.colImageUrl: 'assets/images/image5.jpg',
        DatabaseConstants.colIsFeatured: 1,
        DatabaseConstants.colIsForSale: 1,
        DatabaseConstants.colViews: 890,
        DatabaseConstants.colLikes: 112,
        DatabaseConstants.colRating: 4.8,
        DatabaseConstants.colRatingCount: 38,
      },
    ];

    for (final artwork in artworks) {
      await _artworkDao.insertArtwork(artwork);
    }
  }

  /// بيانات المعارض
  Future<void> _seedExhibitions() async {
    final now = DateTime.now();
    final exhibitions = [
      {
        DatabaseConstants.colId: 'exhibition_1',
        DatabaseConstants.colTitle: 'معرض فنون صنعاء 2024',
        DatabaseConstants.colDescription:
            'معرض سنوي يجمع أبرز الفنانين اليمنيين لعرض أعمالهم الفنية المتنوعة',
        DatabaseConstants.colImageUrl: 'assets/images/image1.jpg',
        DatabaseConstants.colStartDate: now
            .subtract(const Duration(days: 5))
            .toIso8601String(),
        DatabaseConstants.colEndDate: now
            .add(const Duration(days: 25))
            .toIso8601String(),
        DatabaseConstants.colLocation: 'قاعة الفنون الجميلة، صنعاء',
        DatabaseConstants.colCurator: 'أحمد المقطري',
        DatabaseConstants.colType: 'reality',
        DatabaseConstants.colStatus: 'نشط',
        DatabaseConstants.colDate: '${now.day}/${now.month}/${now.year}',
        DatabaseConstants.colArtworksCount: 45,
        DatabaseConstants.colVisitorsCount: 1250,
        DatabaseConstants.colIsFeatured: 1,
        DatabaseConstants.colIsActive: 1,
        DatabaseConstants.colRating: 4.8,
        DatabaseConstants.colRatingCount: 89,
        DatabaseConstants.colTags: ['صنعاء', 'فن تشكيلي', 'معرض سنوي'],
      },
      {
        DatabaseConstants.colId: 'exhibition_2',
        DatabaseConstants.colTitle: 'المعرض الافتراضي للفن الرقمي',
        DatabaseConstants.colDescription:
            'معرض افتراضي يعرض أحدث الأعمال الفنية الرقمية لفنانين يمنيين صاعدين',
        DatabaseConstants.colImageUrl: 'assets/images/image2.jpg',
        DatabaseConstants.colStartDate: now.toIso8601String(),
        DatabaseConstants.colEndDate: now
            .add(const Duration(days: 60))
            .toIso8601String(),
        DatabaseConstants.colLocation: 'أونلاين',
        DatabaseConstants.colCurator: 'سارة العريقي',
        DatabaseConstants.colType: 'virtual',
        DatabaseConstants.colStatus: 'نشط',
        DatabaseConstants.colDate: '${now.day}/${now.month}/${now.year}',
        DatabaseConstants.colArtworksCount: 30,
        DatabaseConstants.colVisitorsCount: 3500,
        DatabaseConstants.colIsFeatured: 1,
        DatabaseConstants.colIsActive: 1,
        DatabaseConstants.colRating: 4.6,
        DatabaseConstants.colRatingCount: 156,
        DatabaseConstants.colTags: ['فن رقمي', 'افتراضي', 'حديث'],
      },
      {
        DatabaseConstants.colId: 'exhibition_3',
        DatabaseConstants.colTitle: 'معرض التراث اليمني',
        DatabaseConstants.colDescription:
            'معرض يحتفي بالتراث الفني اليمني عبر العصور',
        DatabaseConstants.colImageUrl: 'assets/images/image3.jpg',
        DatabaseConstants.colStartDate: now
            .add(const Duration(days: 30))
            .toIso8601String(),
        DatabaseConstants.colEndDate: now
            .add(const Duration(days: 60))
            .toIso8601String(),
        DatabaseConstants.colLocation: 'المتحف الوطني، صنعاء',
        DatabaseConstants.colCurator: 'فاطمة الحمادي',
        DatabaseConstants.colType: 'reality',
        DatabaseConstants.colStatus: 'قريباً',
        DatabaseConstants.colDate: '-',
        DatabaseConstants.colArtworksCount: 60,
        DatabaseConstants.colVisitorsCount: 0,
        DatabaseConstants.colIsFeatured: 0,
        DatabaseConstants.colIsActive: 1,
        DatabaseConstants.colRating: 0.0,
        DatabaseConstants.colRatingCount: 0,
        DatabaseConstants.colTags: ['تراث', 'تاريخ', 'يمن'],
      },
      {
        DatabaseConstants.colId: 'exhibition_4',
        DatabaseConstants.colTitle: 'معرض الفن التجريدي',
        DatabaseConstants.colDescription:
            'معرض مفتوح للمشاركة يعرض أعمال الفن التجريدي',
        DatabaseConstants.colImageUrl: 'assets/images/image4.jpg',
        DatabaseConstants.colStartDate: now
            .subtract(const Duration(days: 10))
            .toIso8601String(),
        DatabaseConstants.colEndDate: now
            .add(const Duration(days: 20))
            .toIso8601String(),
        DatabaseConstants.colLocation: 'أونلاين - مفتوح للجميع',
        DatabaseConstants.colCurator: 'مجتمع الفنانين',
        DatabaseConstants.colType: 'open',
        DatabaseConstants.colStatus: 'نشط',
        DatabaseConstants.colDate: '${now.day}/${now.month}/${now.year}',
        DatabaseConstants.colArtworksCount: 85,
        DatabaseConstants.colVisitorsCount: 2100,
        DatabaseConstants.colIsFeatured: 0,
        DatabaseConstants.colIsActive: 1,
        DatabaseConstants.colRating: 4.5,
        DatabaseConstants.colRatingCount: 67,
        DatabaseConstants.colTags: ['تجريدي', 'مفتوح', 'مشاركة'],
      },
    ];

    for (final exhibition in exhibitions) {
      await _exhibitionDao.insertExhibition(exhibition);
    }
  }

  /// بيانات المنشورات
  Future<void> _seedPosts() async {
    final now = DateTime.now();
    final posts = [
      {
        DatabaseConstants.colId: 'post_1',
        DatabaseConstants.colAuthorId: 'user_1',
        DatabaseConstants.colContent:
            'سعيد بمشاركتي في معرض صنعاء للفنون، أتمنى أن تنال أعمالي إعجابكم #فن #صنعاء',
        DatabaseConstants.colImageUrl: 'assets/images/image1.jpg',
        DatabaseConstants.colTimestamp: now
            .subtract(const Duration(hours: 2))
            .toIso8601String(),
      },
      {
        DatabaseConstants.colId: 'post_2',
        DatabaseConstants.colAuthorId: 'user_2',
        DatabaseConstants.colContent:
            'العمل جارٍ على لوحتي الجديدة المستوحاة من التراث اليمني الأصيل',
        DatabaseConstants.colImageUrl: 'assets/images/image2.jpg',
        DatabaseConstants.colTimestamp: now
            .subtract(const Duration(hours: 5))
            .toIso8601String(),
      },
      {
        DatabaseConstants.colId: 'post_3',
        DatabaseConstants.colAuthorId: 'user_3',
        DatabaseConstants.colContent: 'صباح الفن والجمال 🎨',
        DatabaseConstants.colImageUrl: null,
        DatabaseConstants.colTimestamp: now
            .subtract(const Duration(days: 1))
            .toIso8601String(),
      },
      {
        DatabaseConstants.colId: 'post_4',
        DatabaseConstants.colAuthorId: 'user_1',
        DatabaseConstants.colContent:
            'مشاركة من ورشتي الأخيرة لتعليم أساسيات الرسم الزيتي',
        DatabaseConstants.colImageUrl: 'assets/images/image4.jpg',
        DatabaseConstants.colTimestamp: now
            .subtract(const Duration(days: 2))
            .toIso8601String(),
      },
      {
        DatabaseConstants.colId: 'post_5',
        DatabaseConstants.colAuthorId: 'user_2',
        DatabaseConstants.colContent: 'أنهيت للتو هذه اللوحة، ماذا تظنون؟',
        DatabaseConstants.colImageUrl: 'assets/images/image5.jpg',
        DatabaseConstants.colTimestamp: now
            .subtract(const Duration(days: 3))
            .toIso8601String(),
      },
    ];

    for (final post in posts) {
      await _postDao.insertPost(post);
    }

    // إضافة بعض الإعجابات والتعليقات
    await _seedLikesAndComments();
  }

  /// إضافة إعجابات وتعليقات
  Future<void> _seedLikesAndComments() async {
    final db = await DatabaseHelper().database;
    final now = DateTime.now();

    // إعجابات
    final likes = [
      {
        'id': 'like_1',
        'user_id': 'user_2',
        'post_id': 'post_1',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_2',
        'user_id': 'user_3',
        'post_id': 'post_1',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_3',
        'user_id': 'user_4',
        'post_id': 'post_1',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_4',
        'user_id': 'user_1',
        'post_id': 'post_2',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_5',
        'user_id': 'user_3',
        'post_id': 'post_2',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_6',
        'user_id': 'current_user',
        'post_id': 'post_2',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_7',
        'user_id': 'user_1',
        'post_id': 'post_4',
        'created_at': now.toIso8601String(),
      },
      {
        'id': 'like_8',
        'user_id': 'current_user',
        'post_id': 'post_4',
        'created_at': now.toIso8601String(),
      },
    ];

    for (final like in likes) {
      await db.insert(DatabaseConstants.tableLikes, like);
    }

    // تعليقات
    final comments = [
      {
        'id': 'comment_1',
        'post_id': 'post_1',
        'author_id': 'user_2',
        'content': 'عمل رائع! بالتوفيق 🎨',
        'timestamp': now.subtract(const Duration(hours: 1)).toIso8601String(),
      },
      {
        'id': 'comment_2',
        'post_id': 'post_1',
        'author_id': 'user_3',
        'content': 'ماشاء الله، إبداع حقيقي',
        'timestamp': now
            .subtract(const Duration(minutes: 30))
            .toIso8601String(),
      },
      {
        'id': 'comment_3',
        'post_id': 'post_2',
        'author_id': 'user_1',
        'content': 'أتطلع لرؤية النتيجة النهائية',
        'timestamp': now.subtract(const Duration(hours: 4)).toIso8601String(),
      },
      {
        'id': 'comment_4',
        'post_id': 'post_4',
        'author_id': 'user_4',
        'content': 'هل هناك ورش قادمة؟',
        'timestamp': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
    ];

    for (final comment in comments) {
      await db.insert(DatabaseConstants.tableComments, comment);
    }
  }
}

