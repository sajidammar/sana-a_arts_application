import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/features/exhibitions/models/artwork.dart';
import 'package:sanaa_artl/features/exhibitions/models/exhibition.dart';
import 'package:sanaa_artl/features/exhibitions/data/exhibition_repository.dart';
import 'package:sanaa_artl/features/exhibitions/data/exhibition_repository_impl.dart';

class ExhibitionProvider with ChangeNotifier {
  final ExhibitionRepository _repository;

  List<Exhibition> _exhibitions = [];
  List<Artwork> _artworks = [];
  ExhibitionType _currentFilter = ExhibitionType.virtual;
  bool _isLoading = false;
  String _error = '';
  String _searchQuery = '';
  final Set<ExhibitionType> _ownedExhibitionTypes = {};

  ExhibitionProvider({ExhibitionRepository? repository})
    : _repository = repository ?? ExhibitionRepositoryImpl();

  List<Exhibition> get exhibitions => _exhibitions;
  List<Artwork> get artworks => _artworks;
  ExhibitionType get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;

  bool hasExhibitionType(ExhibitionType type) =>
      _ownedExhibitionTypes.contains(type);

  Future<void> loadExhibitions() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final result = await _repository.getAllExhibitions();

    result.fold(
      (failure) {
        _error = 'فشل في تحميل المعارض: ${failure.message}';
      },
      (data) {
        _exhibitions = data;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkUserExhibitions(String userId) async {
    // This logic filters loaded exhibitions to find "owned" ones.
    // It's efficient enough to do in-memory if exhibitions are loaded.
    // If not loaded, we might need to load or ask repo.
    // Assuming loadExhibitions is called first.
    try {
      if (_exhibitions.isEmpty) {
        await loadExhibitions();
      }

      _ownedExhibitionTypes.clear();
      for (var ex in _exhibitions) {
        if (ex.curator == userId || ex.id.contains(userId)) {
          _ownedExhibitionTypes.add(ex.type);
        }
      }
      notifyListeners();
    } catch (e) {
      // Error checking user exhibitions
    }
  }

  Future<void> forceRegenerateExhibitions() async {
    _isLoading = true;
    notifyListeners();

    final result = await _repository.forceRegenerateExhibitions();

    result.fold(
      (failure) {
        _error = 'فشل في إعادة توليد المعارض: ${failure.message}';
      },
      (_) async {
        // Reload after regeneration
        await loadExhibitions();
      },
    );

    // Note: loadExhibitions handles _isLoading = false locally, but since we await it,
    // it's redundant but safe.
  }

  Future<void> addExhibition(Exhibition exhibition) async {
    final result = await _repository.addExhibition(exhibition);

    result.fold(
      (failure) {
        _error = 'Failed to add exhibition: ${failure.message}';
        notifyListeners();
        throw Exception(
          failure.message,
        ); // Rethrow to let caller know or handle better
      },
      (_) {
        _exhibitions.add(exhibition);
        _ownedExhibitionTypes.add(exhibition.type);
        notifyListeners();
      },
    );
  }

  Future<void> loadArtworks() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final result = await _repository.getAllArtworks();

    result.fold(
      (failure) {
        _error = 'فشل في تحميل الأعمال الفنية: ${failure.message}';
      },
      (data) {
        _artworks = data;
      },
    );

    _isLoading = false;
    notifyListeners();
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

  List<Exhibition> get currentExhibitions {
    // عرض جميع المعارض النشطة
    return _exhibitions.where((ex) => ex.isActive).toList();
  }

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
    // For demo purposes, return all artworks
    // In a real app, you would filter by exhibition_id in the database
    // If the exhibition is featured or has specific artworks, filter accordingly

    if (_artworks.isEmpty) {
      return [];
    }

    // Return all available artworks for the exhibition
    // You can enhance this to filter by actual exhibition-artwork relationship
    return _artworks;
  }

  List<Artwork> getFeaturedArtworks() {
    return _artworks.where((artwork) => artwork.isFeatured).toList();
  }

  Future<void> updateExhibition(String id, Exhibition updatedExhibition) async {
    final index = _exhibitions.indexWhere((ex) => ex.id == id);
    if (index != -1) {
      // Optimistic update
      final oldExhibition = _exhibitions[index];
      _exhibitions[index] = updatedExhibition;
      notifyListeners();

      final result = await _repository.updateExhibition(updatedExhibition);

      result.fold(
        (failure) {
          // Revert
          _exhibitions[index] = oldExhibition;
          notifyListeners();
          _error = 'Update failed: ${failure.message}';
        },
        (_) {}, // Success
      );
    }
  }

  Future<void> deleteExhibition(String id) async {
    final result = await _repository.deleteExhibition(id);

    result.fold(
      (failure) {
        _error = 'Delete failed: ${failure.message}';
        notifyListeners();
      },
      (_) {
        _exhibitions.removeWhere((ex) => ex.id == id);
        notifyListeners();
      },
    );
  }

  Future<void> addArtwork(Artwork artwork) async {
    final result = await _repository.addArtwork(artwork);

    result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
      },
      (_) {
        _artworks.add(artwork);
        notifyListeners();
      },
    );
  }

  Future<void> updateArtwork(String id, Artwork updatedArtwork) async {
    final index = _artworks.indexWhere((artwork) => artwork.id == id);
    if (index != -1) {
      _artworks[index] = updatedArtwork;
      notifyListeners();
      await _repository.updateArtwork(updatedArtwork);
    }
  }

  Future<void> deleteArtwork(String id) async {
    await _repository.deleteArtwork(id);
    _artworks.removeWhere((artwork) => artwork.id == id);
    notifyListeners();
  }

  Future<void> rateExhibition(String id, double rating) async {
    final exhibition = getExhibitionById(id);
    if (exhibition != null) {
      final newRatingCount = exhibition.ratingCount + 1;
      final newRating =
          ((exhibition.rating * exhibition.ratingCount) + rating) /
          newRatingCount;

      final updated = exhibition.copyWith(
        rating: double.parse(newRating.toStringAsFixed(1)),
        ratingCount: newRatingCount,
      );

      final index = _exhibitions.indexWhere((ex) => ex.id == id);
      if (index != -1) {
        _exhibitions[index] = updated;
        notifyListeners();
        await _repository.rateExhibition(id, rating);
      }
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

      final result = await _repository.toggleLikeExhibition(id, newStatus);

      result.fold(
        (failure) {
          // Revert
          _exhibitions[index] = exhibition.copyWith(isLiked: !newStatus);
          notifyListeners();
          _error = 'Failed to update like status: ${failure.message}';
          debugPrint(_error);
        },
        (_) {}, // Success
      );
    }
  }

  Future<void> rateArtwork(String id, double rating) async {
    final artwork = getArtworkById(id);
    if (artwork != null) {
      final newRatingCount = artwork.ratingCount + 1;
      final newRating =
          ((artwork.rating * artwork.ratingCount) + rating) / newRatingCount;

      final updated = artwork.copyWith(
        rating: double.parse(newRating.toStringAsFixed(1)),
        ratingCount: newRatingCount,
      );

      final index = _artworks.indexWhere((a) => a.id == id);
      if (index != -1) {
        _artworks[index] = updated;
        notifyListeners();
        await _repository.rateArtwork(id, rating);
      }
    }
  }
}
