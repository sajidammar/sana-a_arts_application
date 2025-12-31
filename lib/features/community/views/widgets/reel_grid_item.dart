import 'package:flutter/material.dart';
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
                    ? Image.network(reel.thumbnailUrl!, fit: BoxFit.cover)
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
              // معلومات المؤلف
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
                          ? (reel.authorAvatar!.startsWith('assets')
                                ? AssetImage(reel.authorAvatar!)
                                      as ImageProvider
                                : NetworkImage(reel.authorAvatar!))
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
}
