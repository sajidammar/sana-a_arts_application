import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';

class ExhibitionProvider with ChangeNotifier {
  List<Exhibition> _exhibitions = [];
  List<Artwork> _artworks = [];
  ExhibitionType _currentFilter = ExhibitionType.virtual;
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';

  List<Exhibition> get exhibitions => _exhibitions;
  List<Artwork> get artworks => _artworks;
  ExhibitionType get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  // بيانات تجريبية للمعارض
  final List<Exhibition> _demoExhibitions = [
    Exhibition(
      id: '1',
      title: 'تراث صنعاء الخالد',
      curator: 'أحمد المقطري',
      type: ExhibitionType.virtual,
      status: 'مفتوح الآن',
      description:
          'معرض افتراضي يعرض 50 لوحة تجسد جمال التراث المعماري في صنعاء القديمة',
      date: '15 يناير - 28 فبراير 2025',
      location: 'معرض افتراضي',
      artworksCount: 50,
      visitorsCount: 1250,
      isFeatured: true,
      startDate: DateTime(2025, 1, 15),
      endDate: DateTime(2025, 2, 28),
      tags: ['تراث', 'عمارة', 'صنعاء'],
      rating: 4.5,
      ratingCount: 127,
      isActive: true,
      imageUrl: 'assets/images/image1.jpg',
    ),
    Exhibition(
      id: '2',
      title: 'ألوان من اليمن السعيد',
      curator: 'فاطمة الحمادي',
      type: ExhibitionType.reality,
      status: 'قريباً',
      description:
          'معرض واقعي في قاعة الفنون بصنعاء يضم أعمال 20 فناناً يمنياً معاصراً',
      date: '5 مارس - 20 مارس 2025',
      location: 'قاعة الفنون، صنعاء',
      artworksCount: 75,
      visitorsCount: 0,
      startDate: DateTime(2025, 3, 5),
      endDate: DateTime(2025, 3, 20),
      tags: ['معاصر', 'فنون', 'صنعاء'],
      rating: 0.0,
      ratingCount: 0,
      imageUrl: 'assets/images/image2.jpg',
      isActive: true,
    ),
    Exhibition(
      id: '3',
      title: 'إبداعات شابة',
      curator: 'محمد الشامي',
      type: ExhibitionType.open,
      status: 'مفتوح للمشاركة',
      description:
          'معرض مفتوح للفنانين الشباب تحت سن 30 لعرض أعمالهم الإبداعية',
      date: 'مستمر',
      location: 'منصة رقمية',
      artworksCount: 120,
      visitorsCount: 2100,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2025, 12, 31),
      tags: ['شباب', 'إبداع', 'مفتوح'],
      rating: 4.2,
      ratingCount: 89,
      isActive: true,
      imageUrl: 'assets/images/image3.jpg',
    ),
    Exhibition(
      id: '4',
      title: 'طبيعة حضرموت الساحرة',
      curator: 'عائشة بامطرف',
      type: ExhibitionType.virtual,
      status: 'مفتوح الآن',
      description: 'جولة افتراضية في المناظر الطبيعية الخلابة لوادي حضرموت',
      date: '1 فبراير - 15 مارس 2025',
      location: 'معرض افتراضي 360°',
      artworksCount: 35,
      visitorsCount: 850,
      isFeatured: true,
      startDate: DateTime(2025, 2, 1),
      endDate: DateTime(2025, 3, 15),
      tags: ['طبيعة', 'حضرموت', 'مناظر'],
      rating: 4.7,
      ratingCount: 45,
      isActive: true,
      imageUrl: 'assets/images/image4.jpg',
    ),
    Exhibition(
      id: '5',
      title: 'فن الخط العربي المعاصر',
      curator: 'سالم الحكيمي',
      type: ExhibitionType.reality,
      status: 'انتهى',
      description: 'معرض متخصص في فن الخط العربي وتطوره في العصر الحديث',
      date: '10 ديسمبر - 25 ديسمبر 2024',
      location: 'مركز الفنون، عدن',
      artworksCount: 40,
      visitorsCount: 1800,
      startDate: DateTime(2024, 12, 10),
      endDate: DateTime(2024, 12, 25),
      tags: ['خط عربي', 'تراث', 'حديث'],
      rating: 4.8,
      ratingCount: 156,
      isActive: true,
      imageUrl: 'assets/images/image5.jpg',
    ),
    Exhibition(
      id: '6',
      title: 'وجوه يمنية',
      curator: 'نادية القاضي',
      type: ExhibitionType.open,
      status: 'مفتوح للمشاركة',
      description:
          'معرض مفتوح لرسم البورتريه والوجوه اليمنية التراثية والمعاصرة',
      date: 'مستمر',
      location: 'منصة رقمية',
      artworksCount: 95,
      visitorsCount: 1600,
      startDate: DateTime(2024, 1, 1),
      endDate: DateTime(2025, 12, 31),
      tags: ['بورتريه', 'وجوه', 'تراث'],
      rating: 4.4,
      ratingCount: 78,
      isActive: true,
      imageUrl: 'assets/images/image6.jpg',
    ),
  ];

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

  Future<void> loadExhibitions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // محاكاة جلب البيانات من API
      await Future.delayed(const Duration(seconds: 2));

      _exhibitions = _demoExhibitions;
      _error = '';
    } catch (e) {
      _error = 'فشل في تحميل المعارض: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  List<Exhibition> get activeExhibitions {
    return _exhibitions.where((ex) => ex.isActive).toList();
  }

  List<Exhibition> get upcomingExhibitions {
    return _exhibitions.where((ex) => ex.isUpcoming).toList();
  }

  get currentExhibitions => '';

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

  void addExhibition(Exhibition exhibition) {
    _exhibitions.add(exhibition);
    notifyListeners();
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
