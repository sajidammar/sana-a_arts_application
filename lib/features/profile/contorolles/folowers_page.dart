import 'package:flutter/material.dart';

class FolowersPage extends StatelessWidget {
  final int followers;
  final int following;
  final int posts;
  final Color textColor;
  const FolowersPage({
    super.key,
    required this.followers,
    required this.following,
    required this.posts,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat(followers.toString(), 'متابعين'),
        _divider(),
        _buildStat(following.toString(), 'متابعة'),
        _divider(),
        _buildStat(posts.toString(), 'اعمال'),
      ],
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: textColor.withValues(alpha: 0.7),
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 30,
      width: 1,
      color: textColor.withValues(alpha: 0.2),
    );
  }
}

