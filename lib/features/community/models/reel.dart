import 'package:sanaa_artl/core/utils/database/database_constants.dart';
import 'dart:convert';

class Reel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String? videoUrl;
  final String? thumbnailUrl;
  final String? description;
  final int likes;
  final int commentsCount;
  final int views;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLiked;
  final List<String> tags;
  final String syncStatus; // synced, pending, failed

  Reel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    this.videoUrl,
    this.thumbnailUrl,
    this.description,
    this.likes = 0,
    this.commentsCount = 0,
    this.views = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
    this.tags = const [],
    this.syncStatus = 'synced',
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id:
          json[DatabaseConstants.colId]?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      authorId: json[DatabaseConstants.colAuthorId]?.toString() ?? '',
      authorName:
          json[DatabaseConstants.colAuthorName]?.toString() ?? 'Unknown',
      authorAvatar: json[DatabaseConstants.colAuthorAvatar]?.toString(),
      videoUrl: json[DatabaseConstants.colVideoUrl]?.toString(),
      thumbnailUrl: json[DatabaseConstants.colThumbnailUrl]?.toString(),
      description: json[DatabaseConstants.colDescription]?.toString(),
      likes:
          int.tryParse(json[DatabaseConstants.colLikes]?.toString() ?? '0') ??
          0,
      commentsCount:
          int.tryParse(
            json[DatabaseConstants.colCommentsCount]?.toString() ?? '0',
          ) ??
          0,
      views:
          int.tryParse(json[DatabaseConstants.colViews]?.toString() ?? '0') ??
          0,
      createdAt: json[DatabaseConstants.colCreatedAt] != null
          ? DateTime.tryParse(
                  json[DatabaseConstants.colCreatedAt].toString(),
                ) ??
                DateTime.now()
          : DateTime.now(),
      updatedAt: json[DatabaseConstants.colUpdatedAt] != null
          ? DateTime.tryParse(
                  json[DatabaseConstants.colUpdatedAt].toString(),
                ) ??
                DateTime.now()
          : DateTime.now(),
      isLiked: (json[DatabaseConstants.colIsLiked] ?? 0).toString() == '1',
      tags: json[DatabaseConstants.colTags] != null
          ? (json[DatabaseConstants.colTags] is String
                ? List<String>.from(jsonDecode(json[DatabaseConstants.colTags]))
                : List<String>.from(json[DatabaseConstants.colTags]))
          : [],
      syncStatus: json[DatabaseConstants.colSyncStatus]?.toString() ?? 'synced',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      DatabaseConstants.colId: id,
      DatabaseConstants.colAuthorId: authorId,
      DatabaseConstants.colAuthorName: authorName,
      DatabaseConstants.colAuthorAvatar: authorAvatar,
      DatabaseConstants.colVideoUrl: videoUrl,
      DatabaseConstants.colThumbnailUrl: thumbnailUrl,
      DatabaseConstants.colDescription: description,
      DatabaseConstants.colLikes: likes,
      DatabaseConstants.colCommentsCount: commentsCount,
      DatabaseConstants.colViews: views,
      DatabaseConstants.colCreatedAt: createdAt.toIso8601String(),
      DatabaseConstants.colUpdatedAt: updatedAt.toIso8601String(),
      DatabaseConstants.colIsLiked: isLiked ? 1 : 0,
      DatabaseConstants.colTags: jsonEncode(tags),
      DatabaseConstants.colSyncStatus: syncStatus,
    };
  }

  Reel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? videoUrl,
    String? thumbnailUrl,
    String? description,
    int? likes,
    int? commentsCount,
    int? views,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
    List<String>? tags,
    String? syncStatus,
  }) {
    return Reel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      tags: tags ?? this.tags,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
