import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';


class AppProvider with ChangeNotifier {
  final List<Exhibition> _featuredExhibitions = [];
  final List<Artwork> _featuredArtworks = [];
  bool _isLoading = false;

  List<Exhibition> get featuredExhibitions => _featuredExhibitions;
  List<Artwork> get featuredArtworks => _featuredArtworks;
  bool get isLoading => _isLoading;

  Future<void> loadFeaturedData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // محاكاة جلب البيانات من API
      await Future.delayed(const Duration(seconds: 2));

      _featuredExhibitions.addAll(_getSampleExhibitions());
      _featuredArtworks.addAll(_getSampleArtworks());
    } catch (e) {
      if (kDebugMode) {
        print('Error loading data: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Exhibition> _getSampleExhibitions() {
    return [
      Exhibition(
        id: '1',
        title: 'معرض التراث اليمني',
        description: 'أجمل اللوحات المستوحاة من التراث اليمني الأصيل',
        imageUrl: '',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),isActive: true, 
        location: 'صنعاء', curator: '', type: ExhibitionType.open, status: '', date: '', artworksCount: 2000, visitorsCount: 1000,
      ),
      Exhibition(
        id: '2',
        title: 'فنون معاصرة',
        description: 'أعمال فنية معاصرة تجمع بين الأصالة والحداثة',
        imageUrl: '',
        startDate: DateTime(2024, 1, 1),
        endDate: DateTime(2024, 12, 31),isActive: true, 
        location: 'صنعاء', curator: '', type: ExhibitionType.open, status: '', date: '', artworksCount: 2000, visitorsCount: 1000,
      ),
    ];
  }

  List<Artwork> _getSampleArtworks() {
    return [
      Artwork(
        id: '1',
        title: 'لوحة تراثية',
        artist: 'أحمد الشامي',
        description: 'لوحة تعبر عن التراث اليمني',
        price: 1500.0,
        imageUrl: '',
        category: 'تراث',
        createdAt: DateTime(2024, 1, 1), artistId: '', year: 2025, technique: '', dimensions: '', rating: 20.1, ratingCount: 3000, currency: '', tags: [],
      ),
    ];
  }
}