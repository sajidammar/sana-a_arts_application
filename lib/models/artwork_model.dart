import 'package:sanaa_artl/models/exhibition/exhibition.dart';

class Artwork {
  final String id;
  final String title;
  final String artist;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final DateTime createdAt;

  const Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.createdAt, required String artistId, required int year, required String technique, required String dimensions, required int rating, required int ratingCount, required String currency, required List tags, required bool isFeatured, required int views, required int likes,
  });
}

class Exhibition {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;

  const Exhibition({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location, required String curator, required ExhibitionType type, required String status, required int artworksCount, required String date, required int visitorsCount, required bool isFeatured, required double rating, required List<String> tags, required int ratingCount,
  });
}

class Artist {
  final String id;
  final String name;
  final String bio;
  final String profileImage;
  final String specialty;

  const Artist({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImage,
    required this.specialty,
  });
}
