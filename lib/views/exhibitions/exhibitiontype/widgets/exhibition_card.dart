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
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المعرض
                _buildImageSection(context),

                // محتوى البطاقة
                Expanded(child: _buildContentSection(context)),
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
        Container(
          height: 140,
          decoration: BoxDecoration(
            // gradient: exhibition.type.gradient,
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppConstants.borderRadius),
              topRight: Radius.circular(AppConstants.borderRadius),
            ),
          ),
          child: Center(
            child: Icon(
              exhibition.type.icon,
              size: 60,
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.8),
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
        color: exhibition.type.color.withValues(alpha:0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        exhibition.type.badgeText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.surface,
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
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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
              color: Theme.of(context).colorScheme.surface,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            exhibition.title,
            style: Theme.of(context).textTheme.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

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
                    color: Theme.of(context).primaryColor,
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

          const SizedBox(height: 6),

          // الوصف
          Expanded(
            child: Text(
              exhibition.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          // التفاصيل
          _buildDetailsGrid(context),

          const SizedBox(height: 12),

          // الأزرار
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid(dynamic context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3,
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
              color: Theme.of(context).primaryColorDark,
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
            exhibition.type == ExhibitionType.virtual
                ? 'دخول افتراضي'
                : exhibition.type == ExhibitionType.reality
                ? 'حجز تذكرة'
                : 'مشاهدة الأعمال',
            exhibition.type == ExhibitionType.virtual
                ? Icons.card_membership_sharp
                : exhibition.type == ExhibitionType.reality
                ? Icons.confirmation_num
                : Icons.visibility,
            true,
            context,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            exhibition.type == ExhibitionType.virtual
                ? 'مشاركة'
                : exhibition.type == ExhibitionType.reality
                ? 'الاتجاهات'
                : 'تصويت',
            exhibition.type == ExhibitionType.virtual
                ? Icons.share
                : exhibition.type == ExhibitionType.reality
                ? Icons.directions
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
        backgroundColor:
            isPrimary
                ? Theme.of(context!).primaryColor
                : Theme.of(context!).colorScheme.onSurface,
        foregroundColor:
            isPrimary
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color:
                isPrimary
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).primaryColor,
            width: 1,
          ),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.surface),
          ),
        ],
      ),
    );
  }
}
