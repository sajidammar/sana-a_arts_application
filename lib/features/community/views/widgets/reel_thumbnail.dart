import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/community/models/reel.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class ReelThumbnail extends StatelessWidget {
  final Reel reel;
  final VoidCallback onTap;

  const ReelThumbnail({super.key, required this.reel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(left: 12),
        child: Column(
          children: [
            Stack(
              children: [
                // مظهر القصة (Story line)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.5),
                        Colors.orange,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.getBackgroundColor(isDark),
                    ),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
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
                          ? Icon(Icons.person, color: primaryColor, size: 40)
                          : null,
                    ),
                  ),
                ),
                // أيقونة الفيديو الصغيرة
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.getBackgroundColor(isDark),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              reel.authorName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
