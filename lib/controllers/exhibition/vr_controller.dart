import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';


class VRController {
  final VRProvider _vrProvider;

  VRController(this._vrProvider);

  Future<void> loadArtworks(List<Artwork> artworks) async {
    await _vrProvider.loadArtworks(artworks);
  }

  void navigateToNextArtwork() {
    _vrProvider.navigateToNextArtwork();
  }

  void navigateToPreviousArtwork() {
    _vrProvider.navigateToPreviousArtwork();
  }

  void setCurrentArtworkIndex(int index) {
    _vrProvider.setCurrentArtworkIndex(index);
  }

  void toggleVRMode() {
    _vrProvider.toggleVRMode();
  }

  void toggle360Mode() {
    _vrProvider.toggle360Mode();
  }

  void toggle3DMode() {
    _vrProvider.toggle3DMode();
  }

  void toggleAudioGuide() {
    _vrProvider.toggleAudioGuide();
  }

  void toggleAutoTour() {
    _vrProvider.toggleAutoTour();
  }

  void toggleFullscreenMode() {
    _vrProvider.toggleFullscreenMode();
  }

  void setUserRating(int rating) {
    _vrProvider.setUserRating(rating);
  }

  void setZoomLevel(double level) {
    _vrProvider.setZoomLevel(level);
  }

  void setRotation(double x, double y) {
    _vrProvider.setRotation(x, y);
  }

  void setNewComment(String comment) {
    _vrProvider.setNewComment(comment);
  }

  void zoomIn() {
    _vrProvider.zoomIn();
  }

  void zoomOut() {
    _vrProvider.zoomOut();
  }

  void resetView() {
    _vrProvider.resetView();
  }

  void addComment(String comment) {
    _vrProvider.addComment(comment);
  }

  void rateArtwork(int rating) {
    _vrProvider.rateArtwork(rating);
  }

  void likeComment(String commentId) {
    _vrProvider.likeComment(commentId);
  }

  void addToFavorites() {
    _vrProvider.addToFavorites();
  }

  void addToCart() {
    _vrProvider.addToCart();
  }

  void downloadHighRes() {
    _vrProvider.downloadHighRes();
  }

  void viewArtistProfile() {
    _vrProvider.viewArtistProfile();
  }

  void shareArtwork() {
    _vrProvider.shareArtwork();
  }

  // Getters
  int get currentArtworkIndex => _vrProvider.currentArtworkIndex;
  bool get isVRMode => _vrProvider.isVRMode;
  bool get is360Mode => _vrProvider.is360Mode;
  bool get is3DMode => _vrProvider.is3DMode;
  bool get isAudioGuideOn => _vrProvider.isAudioGuideOn;
  bool get isAutoTourOn => _vrProvider.isAutoTourOn;
  bool get isFullscreenMode => _vrProvider.isFullscreenMode;
  int get userRating => _vrProvider.userRating;
  double get zoomLevel => _vrProvider.zoomLevel;
  List<Artwork> get artworks => _vrProvider.artworks;
  bool get isLoading => _vrProvider.isLoading;
  String get error => _vrProvider.error;
  double get rotationX => _vrProvider.rotationX;
  double get rotationY => _vrProvider.rotationY;
  List<ArtworkComment> get comments => _vrProvider.comments;
  String get newComment => _vrProvider.newComment;
  Artwork get currentArtwork => _vrProvider.currentArtwork;
}
