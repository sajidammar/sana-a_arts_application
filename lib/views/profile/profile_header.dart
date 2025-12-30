import 'package:flutter/material.dart';
import 'package:sanaa_artl/views/profile/contorolles/folowers_page.dart';
import 'profile_bio.dart';

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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage:
                  imageUrl != null ? NetworkImage(imageUrl!) : null,
              child: imageUrl == null
                  ? Text(
                      name.isNotEmpty
                          ? name.characters.first.toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Followers
          FolowersPage(
            followers: followers,
            following: following,
            posts: posts,
            textColor: textColor,
          ),

          const SizedBox(height: 20),

          // Bio
          if (bio.isNotEmpty) ProfileBio(bio: bio),
        ],
      ),
    );
  }
}
