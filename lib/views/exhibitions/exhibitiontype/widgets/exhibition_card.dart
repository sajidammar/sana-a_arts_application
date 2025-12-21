import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';
import 'package:sanaa_artl/views/exhibitions/exhibitiontype/open_exhibition_page.dart';
import 'package:sanaa_artl/views/exhibitions/exhibitiontype/vr_exhibition_page.dart';
import 'package:sanaa_artl/views/shared/share_dialog.dart';

class ExhibitionCard extends StatelessWidget {
  final Exhibition exhibition;
  final AnimationController? animationController;
  final Duration animationDelay;
  final VoidCallback? onTap;

  const ExhibitionCard({
    super.key,
    required this.exhibition,
    this.animationController,
    this.animationDelay = Duration.zero,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return ScaleAnimation(
      delay: animationDelay,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          side: BorderSide(
            color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.getCardColor(isDark),
                  AppColors.getCardColor(isDark).withValues(alpha: 0.95),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المعرض
                _buildImageSection(context),

                // محتوى البطاقة
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildContentSection(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Stack(
      children: [
        // صورة الخلفية
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.getPrimaryColor(isDark),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadius),
                topRight: Radius.circular(AppConstants.borderRadius),
              ),
              image: exhibition.imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(exhibition.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: exhibition.imageUrl.isEmpty
                ? Center(
                    child: Icon(
                      exhibition.type.icon,
                      size: 60,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppConstants.borderRadius),
                        topRight: Radius.circular(AppConstants.borderRadius),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
          ),
        ),

        // الشارات
        Positioned(top: 12, right: 12, child: _buildBadge(context)),

        Positioned(top: 12, left: 12, child: _buildLikeButton(context)),

        Positioned(bottom: 12, left: 12, child: _buildStatusBadge(context)),
      ],
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    return Consumer<ExhibitionProvider>(
      builder: (context, provider, _) {
        final isLiked = exhibition.isLiked;
        return InkWell(
          onTap: () => provider.toggleLike(exhibition.id),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.white,
              size: 20,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: exhibition.type.color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        exhibition.type.badgeText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    Color statusColor;
    switch (exhibition.status) {
      case 'مفتوح الآن':
        statusColor = const Color(0xFF4CAF50); // Success
      case 'قريباً':
        statusColor = const Color(0xFFFFA726); // Warning
      case 'انتهى':
        statusColor = const Color(0xFFF44336); // Error
      default:
        statusColor = const Color(0xFF2196F3); // Info
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            exhibition.status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            exhibition.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: AppColors.getTextColor(isDark),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // المنسق
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.getPrimaryColor(isDark),
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'المنسق: ${exhibition.curator}',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.getPrimaryColor(isDark),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // الوصف
          Text(
            exhibition.description,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          // التفاصيل
          _buildDetailsGrid(context),

          const SizedBox(height: 8),

          // الأزرار
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          childAspectRatio: 3.5,
        ),
        children: [
          _buildDetailItem(Icons.calendar_today, exhibition.date, context),
          _buildDetailItem(Icons.location_on, exhibition.location, context),
          _buildDetailItem(
            Icons.photo_library,
            '${exhibition.artworksCount} عمل',
            context,
          ),
          _buildDetailItem(
            Icons.people,
            '${exhibition.visitorsCount} زائر',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Row(
      children: [
        Icon(icon, color: AppColors.getPrimaryColor(isDark), size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.getSubtextColor(isDark),
              fontSize: 10,
              fontFamily: 'Tajawal',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            exhibition.type == ExhibitionType.virtual ? 'دخول' : 'عرض',
            exhibition.type == ExhibitionType.virtual
                ? Icons.login
                : Icons.visibility,
            true,
            context,
            onPressed: () {
              if (exhibition.type == ExhibitionType.virtual) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VRExhibitionPage()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OpenExhibitionPage(exhibition: exhibition),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildActionButton(
            'مشاركة',
            Icons.share,
            false,
            context,
            onPressed: () {
              showDialog(context: context, builder: (_) => const ShareDialog());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    bool isPrimary,
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
    final isDark = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? AppColors.getPrimaryColor(isDark)
            : Colors.transparent,
        foregroundColor: isPrimary
            ? (isDark ? Colors.black : Colors.white)
            : AppColors.getPrimaryColor(isDark),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: AppColors.getPrimaryColor(isDark),
            width: 1.5,
          ),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 13),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'Tajawal',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

