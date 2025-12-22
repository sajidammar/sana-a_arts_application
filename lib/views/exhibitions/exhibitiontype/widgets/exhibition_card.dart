import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/themes/exhibition/app_themes.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';

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
    return ScaleAnimation(
      delay: animationDelay,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          side: BorderSide(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
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
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
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
    return Stack(
      children: [
        // صورة الخلفية
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
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
                      color: Colors.white.withOpacity(0.8),
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

        Positioned(bottom: 12, left: 12, child: _buildStatusBadge(context)),
      ],
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
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color statusColor;
    switch (exhibition.status) {
      case 'مفتوح الآن':
        statusColor = AppThemes.getSuccessColor(context);
      case 'قريباً':
        statusColor = AppThemes.getWarningColor(context);
      case 'انتهى':
        statusColor = AppThemes.getErrorColor(context);
      default:
        statusColor = AppThemes.getInfoColor(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(dynamic context) {
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Theme.of(context).textTheme.titleLarge?.color,
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
                color: Theme.of(context).primaryColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'المنسق: ${exhibition.curator}',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.9)
                        : Theme.of(context).primaryColor,
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.8)
                  : Theme.of(context).textTheme.bodyMedium?.color,
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

  Widget _buildDetailsGrid(dynamic context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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

  Widget _buildDetailItem(IconData icon, String text, context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 14),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.85)
                  : Theme.of(context).primaryColorDark,
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

  Widget _buildActionButtons(context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            exhibition.type == ExhibitionType.virtual ? 'دخول' : 'عرض',
            exhibition.type == ExhibitionType.virtual
                ? Icons.card_membership_sharp
                : Icons.visibility,
            true,
            context,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildActionButton(
            exhibition.type == ExhibitionType.virtual ? 'مشاركة' : 'إعجاب',
            exhibition.type == ExhibitionType.virtual
                ? Icons.share
                : Icons.thumb_up,
            false,
            context!,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    bool isPrimary,
    context,
  ) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? Theme.of(context!).primaryColor
            : Colors.transparent,
        foregroundColor: isPrimary
            ? Colors.white
            : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
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
