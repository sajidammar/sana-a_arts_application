import 'package:flutter/material.dart';
import 'dart:io';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String bio;
  final int followers;
  final int following;
  final int posts;
  final bool isDark;
  final Color primaryColor;
  final Color textColor;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.posts,
    required this.isDark,
    required this.primaryColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  backgroundImage: _getImageProvider(imageUrl),
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? Text(
                          name.isNotEmpty
                              ? name.characters.first.toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 30),
              // Stats
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(posts.toString(), 'منشورات'),
                    _buildStatItem(_formatNumber(followers), 'متابعين'),
                    _buildStatItem(_formatNumber(following), 'أتابع'),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),

          const SizedBox(height: 4),

          // Bio
          if (bio.isNotEmpty)
            Text(
              bio,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withValues(alpha: 0.8),
                fontFamily: 'Tajawal',
                height: 1.4,
              ),
            ),

          const SizedBox(height: 12),

          // CV Button (Instagram style business button)
          ElevatedButton.icon(
            onPressed: () {
              // Logic to open/view CV
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('فتح السيرة الذاتية...')),
              );
            },
            icon: const Icon(
              Icons.description_outlined,
              size: 18,
              color: Colors.white,
            ),
            label: const Text(
              'عرض السيرة الذاتية',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(0, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: textColor.withValues(alpha: 0.6),
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }

  ImageProvider? _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }

    if (imagePath.startsWith('/') ||
        imagePath.contains(':\\') ||
        imagePath.contains(':/')) {
      // Local file path
      return FileImage(File(imagePath));
    }

    // Check for valid URL scheme
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }

    // Default fallback
    return AssetImage(imagePath);
  }
}
