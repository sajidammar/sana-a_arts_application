import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';



class ExhibitionController {
  final ExhibitionProvider _exhibitionProvider;

  ExhibitionController(this._exhibitionProvider);

  Future<void> loadExhibitions() async {
    await _exhibitionProvider.loadExhibitions();
  }

  Future<void> loadArtworks() async {
    await _exhibitionProvider.loadArtworks();
  }

  void setFilter(ExhibitionType filter) {
    _exhibitionProvider.setFilter(filter);
  }

  void setSearchQuery(String query) {
    _exhibitionProvider.setSearchQuery(query);
  }

  void clearSearch() {
    _exhibitionProvider.clearSearch();
  }

  List<Exhibition> get filteredExhibitions {
    return _exhibitionProvider.filteredExhibitions;
  }

  List<Exhibition> get featuredExhibitions {
    return _exhibitionProvider.featuredExhibitions;
  }

  List<Exhibition> get activeExhibitions {
    return _exhibitionProvider.activeExhibitions;
  }

  List<Exhibition> get upcomingExhibitions {
    return _exhibitionProvider.upcomingExhibitions;
  }

  Exhibition? getExhibitionById(String id) {
    return _exhibitionProvider.getExhibitionById(id);
  }

  Artwork? getArtworkById(String id) {
    return _exhibitionProvider.getArtworkById(id);
  }

  List<Artwork> getArtworksByExhibition(String exhibitionId) {
    return _exhibitionProvider.getArtworksByExhibition(exhibitionId);
  }

  List<Artwork> getFeaturedArtworks() {
    return _exhibitionProvider.getFeaturedArtworks();
  }

  void addExhibition(Exhibition exhibition) {
    _exhibitionProvider.addExhibition(exhibition);
  }

  void updateExhibition(String id, Exhibition updatedExhibition) {
    _exhibitionProvider.updateExhibition(id, updatedExhibition);
  }

  void deleteExhibition(String id) {
    _exhibitionProvider.deleteExhibition(id);
  }

  void addArtwork(Artwork artwork) {
    _exhibitionProvider.addArtwork(artwork);
  }

  void updateArtwork(String id, Artwork updatedArtwork) {
    _exhibitionProvider.updateArtwork(id, updatedArtwork);
  }

  void deleteArtwork(String id) {
    _exhibitionProvider.deleteArtwork(id);
  }

  void rateExhibition(String id, double rating) {
    _exhibitionProvider.rateExhibition(id, rating);
  }

  void rateArtwork(String id, double rating) {
    _exhibitionProvider.rateArtwork(id, rating);
  }

  bool get isLoading => _exhibitionProvider.isLoading;
  String get error => _exhibitionProvider.error;
  ExhibitionType get currentFilter => _exhibitionProvider.currentFilter;
}
