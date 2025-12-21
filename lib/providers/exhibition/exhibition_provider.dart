import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';

import 'package:sanaa_artl/utils/database/dao/exhibition_dao.dart';

class ExhibitionProvider with ChangeNotifier {
  final ExhibitionDao _dao = ExhibitionDao();
  List<Exhibition> _exhibitions = [];
  List<Artwork> _artworks = [];
  ExhibitionType _currentFilter = ExhibitionType.virtual;
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  // ... (Keep existing properties)
  final Set<ExhibitionType> _ownedExhibitionTypes = {};

  List<Exhibition> get exhibitions => _exhibitions;
  List<Artwork> get artworks => _artworks;
  ExhibitionType get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  bool hasExhibitionType(ExhibitionType type) =>
      _ownedExhibitionTypes.contains(type);

  // بيانات تجريبية للمعارض (تم تفريغها لاستخدام التوليد الديناميكي)

  // بيانات تجريبية للأعمال الفنية
  final List<Artwork> _demoArtworks = [
    Artwork(
      id: '1',
      title: 'بوابة صنعاء القديمة',
      artist: 'أحمد المقطري',
      artistId: 'artist1',
      year: 2024,
      technique: 'ألوان زيتية',
      dimensions: '120×80 سم',
      description:
          'لوحة فنية تجسد جمال البوابات التراثية في صنعاء القديمة، مع التركيز على التفاصيل المعمارية الفريدة والألوان التقليدية التي تعكس روح الحضارة اليمنية العريقة.',
      rating: 4.5,
      ratingCount: 127,
      price: 1200,
      currency: '\$',
      category: 'تراث معماري',
      tags: ['تراث', 'عمارة', 'صنعاء'],
      imageUrl: '',
      createdAt: DateTime(2024, 1, 1),
      isFeatured: true,
      views: 1250,
      likes: 89,
    ),
    Artwork(
      id: '2',
      title: 'منازل صنعاء التراثية',
      artist: 'فاطمة الحمادي',
      artistId: 'artist2',
      year: 2023,
      technique: 'ألوان مائية',
      dimensions: '100×70 سم',
      description:
          'عمل فني يصور جمال العمارة اليمنية التقليدية في البيوت الطينية متعددة الطوابق التي تميز صنعاء القديمة.',
      rating: 4.7,
      ratingCount: 89,
      price: 800,
      currency: '\$',
      category: 'عمارة تقليدية',
      tags: ['عمارة', 'تراث', 'بيوت طينية'],
      imageUrl: '',
      createdAt: DateTime(2023, 12, 1),
      views: 980,
      likes: 67,
    ),
    Artwork(
      id: '3',
      title: 'سوق الملح التراثي',
      artist: 'محمد الشامي',
      artistId: 'artist3',
      year: 2024,
      technique: 'أكريليك',
      dimensions: '90×120 سم',
      description:
          'لوحة تعكس الحياة التجارية التراثية في الأسواق الشعبية القديمة، مع إبراز الألوان والحركة الدائمة في هذه الأماكن العريقة.',
      rating: 4.3,
      ratingCount: 156,
      price: 950,
      currency: '\$',
      category: 'حياة شعبية',
      tags: ['سوق', 'تراث', 'حياة شعبية'],
      imageUrl: '',
      createdAt: DateTime(2024, 1, 15),
      views: 1100,
      likes: 78,
    ),
    Artwork(
      id: '4',
      title: 'غروب صنعاء الذهبي',
      artist: 'سارة العريقي',
      artistId: 'artist4',
      year: 2024,
      technique: 'ألوان زيتية',
      dimensions: '140×100 سم',
      description:
          'منظر خلاب لغروب الشمس فوق مدينة صنعاء القديمة، حيث تتداخل الألوان الذهبية مع العمارة التراثية في لوحة فنية ساحرة.',
      rating: 4.9,
      ratingCount: 203,
      price: 1500,
      currency: '\$',
      category: 'مناظر طبيعية',
      tags: ['غروب', 'طبيعة', 'صنعاء'],
      imageUrl: '',
      createdAt: DateTime(2024, 2, 1),
      isFeatured: true,
      views: 2100,
      likes: 156,
    ),
    Artwork(
      id: '5',
      title: 'المرأة اليمنية الأصيلة',
      artist: 'عبدالله الوزير',
      artistId: 'artist5',
      year: 2023,
      technique: 'فحم وباستيل',
      dimensions: '80×60 سم',
      description:
          'بورتريه فني يجسد جمال وقوة المرأة اليمنية، مع التركيز على التفاصيل الدقيقة في الملامح والزي التقليدي.',
      rating: 4.6,
      ratingCount: 142,
      price: 700,
      currency: '\$',
      category: 'بورتريه',
      tags: ['بورتريه', 'مرأة', 'تراث'],
      imageUrl: '',
      createdAt: DateTime(2023, 11, 15),
      views: 890,
      likes: 45,
    ),
  ];
  // ...

  Future<void> loadExhibitions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final data = await _dao.getAllExhibitions();
      if (data.isNotEmpty) {
        // Check if exhibitions have images and featured items
        final hasImages = data.any(
          (e) =>
              e['image_url'] != null && (e['image_url'] as String).isNotEmpty,
        );

        final hasFeatured = data.any(
          (e) => e['is_featured'] == 1 || e['is_featured'] == true,
        );

        if (!hasImages || !hasFeatured) {
          // Old data without images or featured - regenerate
          await _dao.deleteAllExhibitions();
          _exhibitions = _generateDynamicExhibitions();
          for (var ex in _exhibitions) {
            await _dao.insertExhibition(ex.toJson());
          }
        } else {
          _exhibitions = data.map((e) => Exhibition.fromJson(e)).toList();
        }
      } else {
        // If empty, generate demo data and save to DB
        _exhibitions = _generateDynamicExhibitions();
        for (var ex in _exhibitions) {
          await _dao.insertExhibition(ex.toJson());
        }
      }
      _error = '';
    } catch (e) {
      _error = 'فشل في تحميل المعارض: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkUserExhibitions(String userId) async {
    try {
      final allExhibitions = await _dao.getAllExhibitions();
      _ownedExhibitionTypes.clear();

      for (var e in allExhibitions) {
        final ex = Exhibition.fromJson(e);
        if (ex.curator == userId || ex.id.contains(userId)) {
          _ownedExhibitionTypes.add(ex.type);
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking user exhibitions: $e');
    }
  }

  Future<void> addExhibition(Exhibition exhibition) async {
    try {
      await _dao.insertExhibition(exhibition.toJson());
      _exhibitions.add(exhibition);
      // Update owned types locally immediately
      _ownedExhibitionTypes.add(exhibition.type);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add exhibition: $e';
      notifyListeners();
      rethrow;
    }
  }

  List<Exhibition> _generateDynamicExhibitions() {
    // ... (Titles/Curators/Images setup)
    final titles = [
      'أطياف يمنية',
      'رحلة في صنعاء',
      'فنون المرتفعات',
      'ذاكرة المكان',
      'شموخ الجبال',
      'إيقاع الألوان',
      'نقوش سبأ',
      'حكاية حجر',
    ];

    final curators = [
      'أحمد المقطري',
      'فاطمة الحمادي',
      'محمد الشامي',
      'سارة العريقي',
      'عبدالله الوزير',
      'منى اليافعي',
    ];

    final locations = [
      'معرض افتراضي',
      'قاعة الفنون بصنعاء',
      'المركز الثقافي',
      'منصة رقمية',
    ];

    final images = [
      'assets/images/image1.jpg',
      'assets/images/image2.jpg',
      'assets/images/image3.jpg',
      'assets/images/image4.jpg',
      'assets/images/image5.jpg',
      'assets/images/image6.jpg',
      'assets/images/image7.jpg',
    ];

    List<Exhibition> generated = [];
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < 8; i++) {
      int titleIndex = (random + i) % titles.length;
      int curatorIndex = (random + i * 2) % curators.length;
      int imgIndex = (random + i * 3) % images.length;
      int typeIndex = (random + i) % 3; // 0, 1, 2
      ExhibitionType type;
      if (typeIndex == 0) {
        type = ExhibitionType.virtual;
      } else if (typeIndex == 1) {
        type = ExhibitionType.personal; // Replaced reality with personal
      } else {
        type = ExhibitionType.open;
      }

      generated.add(
        Exhibition(
          id: 'gen_\$i',
          title: titles[titleIndex],
          curator: curators[curatorIndex],
          type: type,
          status: i % 3 == 0 ? 'مفتوح الآن' : (i % 3 == 1 ? 'قريباً' : 'انتهى'),
          description:
              'معرض فني متميز يعرض مجموعة من أجمل الأعمال الفنية للفنان ${curators[curatorIndex]}، يجسد رؤية فنية فريدة.',
          date: '2025/0\$((i % 9) + 1)/15',
          location: locations[i % locations.length],
          artworksCount: 20 + i * 5,
          visitorsCount: 100 + i * 50,
          isFeatured: i % 2 == 0,
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 30)),
          tags: ['فنون', 'يمن', 'تراث'],
          rating: 4.0 + (i % 10) / 10,
          ratingCount: 10 + i * 2,
          isActive: true,
          imageUrl: images[imgIndex],
        ),
      );
    }
    return generated;
  }

  Future<void> loadArtworks() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // محاكاة جلب البيانات من API
      await Future.delayed(const Duration(seconds: 1));

      _artworks = _demoArtworks;
      _error = '';
    } catch (e) {
      _error = 'فشل في تحميل الأعمال الفنية: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(ExhibitionType filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  List<Exhibition> get filteredExhibitions {
    var filtered = _exhibitions;

    // التصفية حسب النوع
    if (_currentFilter != ExhibitionType.virtual) {
      filtered = filtered.where((ex) => ex.type == _currentFilter).toList();
    }

    // التصفية حسب البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (ex) =>
                ex.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                ex.curator.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                ex.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                ex.tags.any(
                  (tag) =>
                      tag.toLowerCase().contains(_searchQuery.toLowerCase()),
                ),
          )
          .toList();
    }

    return filtered;
  }

  List<Exhibition> get featuredExhibitions {
    return _exhibitions.where((ex) => ex.isFeatured).toList();
  }

  List<Exhibition> get mostVisitedExhibitions {
    final sorted = List<Exhibition>.from(_exhibitions);
    sorted.sort((a, b) => b.visitorsCount.compareTo(a.visitorsCount));
    return sorted.take(5).toList();
  }

  List<Exhibition> get activeExhibitions {
    return _exhibitions.where((ex) => ex.isActive).toList();
  }

  List<Exhibition> get upcomingExhibitions {
    return _exhibitions.where((ex) => ex.isUpcoming).toList();
  }

  List<Exhibition> get currentExhibitions => _exhibitions;

  Exhibition? getExhibitionById(String id) {
    try {
      return _exhibitions.firstWhere((ex) => ex.id == id);
    } catch (e) {
      return null;
    }
  }

  Artwork? getArtworkById(String id) {
    try {
      return _artworks.firstWhere((artwork) => artwork.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Artwork> getArtworksByExhibition(String exhibitionId) {
    // في التطبيق الحقيقي، سيتم ربط الأعمال الفنية بالمعارض
    return _artworks.take(5).toList();
  }

  List<Artwork> getFeaturedArtworks() {
    return _artworks.where((artwork) => artwork.isFeatured).toList();
  }

  void updateExhibition(String id, Exhibition updatedExhibition) {
    final index = _exhibitions.indexWhere((ex) => ex.id == id);
    if (index != -1) {
      _exhibitions[index] = updatedExhibition;
      notifyListeners();
    }
  }

  void deleteExhibition(String id) {
    _exhibitions.removeWhere((ex) => ex.id == id);
    notifyListeners();
  }

  void addArtwork(Artwork artwork) {
    _artworks.add(artwork);
    notifyListeners();
  }

  void updateArtwork(String id, Artwork updatedArtwork) {
    final index = _artworks.indexWhere((artwork) => artwork.id == id);
    if (index != -1) {
      _artworks[index] = updatedArtwork;
      notifyListeners();
    }
  }

  void deleteArtwork(String id) {
    _artworks.removeWhere((artwork) => artwork.id == id);
    notifyListeners();
  }

  void rateExhibition(String id, double rating) {
    final exhibition = getExhibitionById(id);
    if (exhibition != null) {
      // محاكاة تحديث التقييم
      final newRatingCount = exhibition.ratingCount + 1;
      final newRating =
          ((exhibition.rating * exhibition.ratingCount) + rating) /
          newRatingCount;

      updateExhibition(
        id,
        exhibition.copyWith(
          rating: double.parse(newRating.toStringAsFixed(1)),
          ratingCount: newRatingCount,
        ),
      );
    }
  }

  Future<void> toggleLike(String id) async {
    final index = _exhibitions.indexWhere((ex) => ex.id == id);
    if (index != -1) {
      final exhibition = _exhibitions[index];
      final newStatus = !exhibition.isLiked;

      // Optimistic update
      _exhibitions[index] = exhibition.copyWith(isLiked: newStatus);
      notifyListeners();

      try {
        await _dao.updateLikeStatus(id, newStatus);
      } catch (e) {
        // Revert on failure
        _exhibitions[index] = exhibition.copyWith(isLiked: !newStatus);
        notifyListeners();
        _error = 'Failed to update like status: $e';
        debugPrint(_error);
      }
    }
  }

  void rateArtwork(String id, double rating) {
    final artwork = getArtworkById(id);
    if (artwork != null) {
      // محاكاة تحديث التقييم
      final newRatingCount = artwork.ratingCount + 1;
      final newRating =
          ((artwork.rating * artwork.ratingCount) + rating) / newRatingCount;

      updateArtwork(
        id,
        artwork.copyWith(
          rating: double.parse(newRating.toStringAsFixed(1)),
          ratingCount: newRatingCount,
        ),
      );
    }
  }
}

// امتدادات للمساعدة في تحديث الكائنات
extension ExhibitionCopyWith on Exhibition {
  Exhibition copyWith({
    String? id,
    String? title,
    String? curator,
    ExhibitionType? type,
    String? status,
    String? description,
    String? date,
    String? location,
    int? artworksCount,
    int? visitorsCount,
    String? imageUrl,
    bool? isFeatured,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    double? rating,
    int? ratingCount,
    bool? isLiked,
  }) {
    return Exhibition(
      id: id ?? this.id,
      title: title ?? this.title,
      curator: curator ?? this.curator,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      artworksCount: artworksCount ?? this.artworksCount,
      visitorsCount: visitorsCount ?? this.visitorsCount,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isActive: true,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

extension ArtworkCopyWith on Artwork {
  Artwork copyWith({
    String? id,
    String? title,
    String? artist,
    String? artistId,
    int? year,
    String? technique,
    String? dimensions,
    String? description,
    double? rating,
    int? ratingCount,
    double? price,
    String? currency,
    String? category,
    List<String>? tags,
    String? imageUrl,
    DateTime? createdAt,
    bool? isFeatured,
    bool? isForSale,
    int? views,
    int? likes,
    List<ArtworkComment>? comments,
  }) {
    return Artwork(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      year: year ?? this.year,
      technique: technique ?? this.technique,
      dimensions: dimensions ?? this.dimensions,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isForSale: isForSale ?? this.isForSale,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }
}
