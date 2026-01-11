import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/exhibitions/models/exhibition.dart';
import 'package:sanaa_artl/features/exhibitions/models/artwork.dart';

abstract class ExhibitionRepository {
  Future<Result<List<Exhibition>>> getAllExhibitions();
  Future<Result<void>> forceRegenerateExhibitions();
  Future<Result<void>> addExhibition(Exhibition exhibition);
  Future<Result<void>> updateExhibition(Exhibition exhibition);
  Future<Result<void>> deleteExhibition(String id);
  Future<Result<void>> toggleLikeExhibition(String id, bool isActive);
  Future<Result<void>> rateExhibition(String id, double rating);

  Future<Result<List<Artwork>>> getAllArtworks();
  Future<Result<void>> addArtwork(Artwork artwork);
  Future<Result<void>> updateArtwork(Artwork artwork);
  Future<Result<void>> deleteArtwork(String id);
  Future<Result<void>> rateArtwork(String id, double rating);
}
