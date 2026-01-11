import 'dart:convert';
import 'package:flutter/material.dart';

class Exhibition {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final bool isActive;
  final String curator;
  final ExhibitionType type;
  final String status;
  final String date;
  final int artworksCount;
  final int visitorsCount;
  final bool isFeatured;
  final List<String> tags;
  final double rating;
  final int ratingCount;
  final bool isLiked;

  Exhibition({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.isActive,
    required this.curator,
    required this.type,
    required this.status,
    required this.date,
    required this.artworksCount,
    required this.visitorsCount,
    this.isFeatured = false,
    this.tags = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isLiked = false,
  });

  bool get isUpcoming => status == 'قريباً';
  bool get isClosed => status == 'انتهى';

  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      curator: json['curator'] ?? '',
      type: _parseExhibitionType(json['type'] ?? 'virtual'),
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      artworksCount: json['artworks_count'] ?? 0,
      visitorsCount: json['visitors_count'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      startDate: DateTime.parse(
        json['start_date'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['end_date'] ?? DateTime.now().toIso8601String(),
      ),
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingCount: json['rating_count'] ?? 0,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
    );
  }

  String get dateRange => '';

  static ExhibitionType _parseExhibitionType(String type) {
    switch (type) {
      case 'open':
        return ExhibitionType.open;
      case 'personal':
        return ExhibitionType.personal;
      case 'group':
        return ExhibitionType.group;
      case 'virtual':
      default:
        return ExhibitionType.virtual;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'curator': curator,
      'type': type.toString().split('.').last,
      'status': status,
      'description': description,
      'date': date,
      'location': location,
      'artworks_count': artworksCount,
      'visitors_count': visitorsCount,
      'image_url': imageUrl,
      'is_featured': isFeatured ? 1 : 0,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'tags': jsonEncode(tags),
      'rating': rating,
      'rating_count': ratingCount,
      'is_active': isActive ? 1 : 0,
      'is_liked': isLiked ? 1 : 0,
    };
  }

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
    bool? isActive,
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
      isActive: isActive ?? this.isActive,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

enum ExhibitionType { virtual, open, personal, group }

extension ExhibitionTypeExtension on ExhibitionType {
  String get displayName {
    switch (this) {
      case ExhibitionType.virtual:
        return 'افتراضي';
      case ExhibitionType.open:
        return 'مفتوح';
      case ExhibitionType.personal:
        return 'شخصي';
      case ExhibitionType.group:
        return 'جماعي';
    }
  }

  String get badgeText {
    switch (this) {
      case ExhibitionType.virtual:
        return 'افتراضي';
      case ExhibitionType.open:
        return 'مفتوح';
      case ExhibitionType.personal:
        return 'شخصي';
      case ExhibitionType.group:
        return 'جماعي';
    }
  }

  Gradient get gradient {
    switch (this) {
      case ExhibitionType.virtual:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ExhibitionType.open:
        return const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ExhibitionType.personal:
        return const LinearGradient(
          colors: [Color(0xFFff9a9e), Color(0xFFfecfef)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case ExhibitionType.group:
        return const LinearGradient(
          colors: [Color(0xFF84fab0), Color(0xFF8fd3f4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color get color {
    switch (this) {
      case ExhibitionType.virtual:
        return const Color(0xFF667eea);
      case ExhibitionType.open:
        return const Color(0xFF4facfe);
      case ExhibitionType.personal:
        return const Color(0xFFff9a9e);
      case ExhibitionType.group:
        return const Color(0xFF84fab0);
    }
  }

  IconData get icon {
    switch (this) {
      case ExhibitionType.virtual:
        return Icons.card_membership_sharp;
      case ExhibitionType.open:
        return Icons.upload;
      case ExhibitionType.personal:
        return Icons.person;
      case ExhibitionType.group:
        return Icons.groups;
    }
  }
}
