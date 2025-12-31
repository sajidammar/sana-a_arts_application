import 'dart:convert';

class Artwork {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final int year;
  final String technique;
  final String dimensions;
  final String description;
  final double rating;
  final int ratingCount;
  final double price;
  final String currency;
  final String category;
  final List<String> tags;
  final String imageUrl;
  final DateTime createdAt;
  final bool isFeatured;
  final bool isForSale;
  final int views;
  final int likes;
  final List<ArtworkComment> comments;

  Artwork({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.year,
    required this.technique,
    required this.dimensions,
    required this.description,
    required this.rating,
    required this.ratingCount,
    required this.price,
    required this.currency,
    required this.category,
    required this.tags,
    required this.imageUrl,
    required this.createdAt,
    this.isFeatured = false,
    this.isForSale = true,
    this.views = 0,
    this.likes = 0,
    this.comments = const [],
  });

  String get formattedPrice {
    return '$price $currency';
  }

  String get formattedRating {
    return '$rating ($ratingCount تقييم)';
  }

  String get formattedDimensions {
    return dimensions;
  }

  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 100)}...';
  }

  bool get isNew {
    return createdAt.isAfter(DateTime.now().subtract(const Duration(days: 30)));
  }

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      artistId: json['artist_id'] ?? '',
      year: json['year'] ?? 2024,
      technique: json['technique'] ?? '',
      dimensions: json['dimensions'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? '\$',
      category: json['category'] ?? '',
      tags: json['tags'] is String
          ? jsonDecode(json['tags'])
          : List<String>.from(json['tags'] ?? []),
      imageUrl: json['image_url'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      isForSale: json['is_for_sale'] == 1 || json['is_for_sale'] == true,
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      comments: [], // Comments usually handled separately or via another DAO
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'artist_id': artistId,
      'year': year,
      'technique': technique,
      'dimensions': dimensions,
      'description': description,
      'rating': rating,
      'rating_count': ratingCount,
      'price': price,
      'currency': currency,
      'category': category,
      'tags': jsonEncode(tags),
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'is_featured': isFeatured ? 1 : 0,
      'is_for_sale': isForSale ? 1 : 0,
      'views': views,
      'likes': likes,
    };
  }
}

class ArtworkComment {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final DateTime createdAt;
  final int likes;
  final List<ArtworkComment> replies;

  ArtworkComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
    this.likes = 0,
    this.replies = const [],
  });

  factory ArtworkComment.fromJson(Map<String, dynamic> json) {
    return ArtworkComment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      likes: json['likes'] ?? 0,
      replies: List<Map<String, dynamic>>.from(
        json['replies'] ?? [],
      ).map((reply) => ArtworkComment.fromJson(reply)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}
