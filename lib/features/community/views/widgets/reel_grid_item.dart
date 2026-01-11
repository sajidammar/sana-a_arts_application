import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sanaa_artl/features/community/models/reel.dart';

class ReelGridItem extends StatelessWidget {
  final Reel reel;
  final VoidCallback onTap;

  const ReelGridItem({super.key, required this.reel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // صورة مصغرة (Placeholder using author avatar or color if thumbnail is null)
              Container(
                color: primaryColor.withValues(alpha: 0.2),
                child: reel.thumbnailUrl != null
                    ? Image(
                        image: _getImageProvider(reel.thumbnailUrl!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: primaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.movie_outlined,
                          size: 40,
                          color: primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
              ),
              // تدرج لسهولة القراءة
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // المؤشر الخاص بحالة المزامنة (Pending) - WhatsApp Style
              if (reel.syncStatus == 'pending')
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              // المعلومات الأساسية
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage:
                          reel.authorAvatar != null &&
                              reel.authorAvatar!.isNotEmpty
                          ? _getImageProvider(reel.authorAvatar!)
                          : null,
                      child:
                          reel.authorAvatar == null ||
                              reel.authorAvatar!.isEmpty
                          ? const Icon(Icons.person, size: 12)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reel.authorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // عدد المشاهدات
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${reel.views}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }
    // Check if it's a local file path
    if (imageUrl.startsWith('/') ||
        imageUrl.contains(':\\') ||
        imageUrl.contains(':/')) {
      return FileImage(File(imageUrl));
    }
    return AssetImage(imageUrl);
  }
}
