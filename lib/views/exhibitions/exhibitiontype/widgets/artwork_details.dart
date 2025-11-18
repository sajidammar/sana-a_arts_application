import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/themes/exhibition/colors.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';

class ArtworkDetails extends StatelessWidget {
  final AnimationController animationController;
  final VRProvider vrProvider;

  const ArtworkDetails({
    super.key,
    required this.animationController,
    required this.vrProvider,
  });

  BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    final artwork = vrProvider.currentArtwork;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم
            _buildSectionHeader('تفاصيل العمل الحالي'),

            const SizedBox(height: 16),

            // معلومات العمل الفني
            _buildArtworkInfo(artwork, context),

            const SizedBox(height: 24),

            // الميزات التفاعلية
            _buildInteractiveFeatures(),

            const SizedBox(height: 24),

            // إجراءات العمل
            _buildArtworkActions(),

            const SizedBox(height: 24),

            // التقييم
            _buildRatingSection(),

            const SizedBox(height: 24),

            // التعليقات
            _buildCommentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 200),
      child: Row(
        children: [
          Expanded(child: Icon(Icons.info, color: AppColors.primaryColor)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context!).colorScheme.onSurface,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkInfo(Artwork artwork, BuildContext context) {
    return ScaleAnimation(
      delay: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Column(
          children: [
            _buildInfoRow('العنوان:', artwork.title, context),
            _buildInfoRow('الفنان:', artwork.artist, context),
            _buildInfoRow('السنة:', artwork.year.toString(), context),
            _buildInfoRow('التقنية:', artwork.technique, context),
            _buildInfoRow('الأبعاد:', artwork.dimensions, context),
            _buildInfoRow('السعر:', artwork.formattedPrice, context),
            _buildInfoRow('التصنيف:', artwork.category, context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFeatures() {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الميزات التفاعلية'),
          const SizedBox(height: 12),
          ..._buildFeatureList(),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList() {
    final features = [
      {'icon': Icons.zoom_in, 'text': 'تكبير عالي الدقة (حتى 4K)'},
      {'icon': Icons.info_outline, 'text': 'معلومات تفصيلية عند النقر'},
      {'icon': Icons.tour, 'text': 'جولة مرشدة تلقائية'},
      {'icon': Icons.share, 'text': 'مشاركة العمل الحالي'},
      {'icon': Icons.bookmark, 'text': 'حفظ في المفضلة'},
      {'icon': Icons.download, 'text': 'تحميل نسخة عالية الجودة'},
    ];

    return features
        .map(
          (feature) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(
                  feature['icon'] as IconData,
                  color: Theme.of(context!).colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature['text'] as String,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildArtworkActions() {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('إجراءات العمل'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                'إضافة للمفضلة',
                Icons.favorite,
                AppColors.primaryColor,
                vrProvider.addToFavorites,
              ),
              _buildActionButton(
                'إضافة للسلة',
                Icons.shopping_cart,
                AppColors.virtualGradient.colors.first,
                vrProvider.addToCart,
              ),
              _buildActionButton(
                'تحميل عالي الجودة',
                Icons.download,
                AppColors.realityGradient.colors.first,
                vrProvider.downloadHighRes,
              ),
              _buildActionButton(
                'ملف الفنان',
                Icons.person,
                AppColors.openGradient.colors.first,
                vrProvider.viewArtistProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Theme.of(context!).colorScheme.onSurface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Icon(icon, color: color, size: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context!).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('تقييم العمل'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context!).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              children: [
                // النجوم
                _buildRatingStars(),
                const SizedBox(height: 8),
                // معلومات التقييم
                Text(
                  'التقييم الحالي: ${vrProvider.currentArtwork.rating}/5 (${vrProvider.currentArtwork.ratingCount} تقييم)',
                  style: TextStyle(
                    color: Theme.of(context!).primaryColorDark,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Expanded(
          child: IconButton(
            onPressed: () => vrProvider.rateArtwork(index + 1),
            icon: Icon(
              index < vrProvider.userRating ? Icons.star : Icons.star_border,
              color: Theme.of(context!).primaryColor,
              size: 28,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        );
      }),
    );
  }

  Widget _buildCommentSection() {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التعليقات المباشرة'),
          const SizedBox(height: 12),

          // حقل إدخال التعليق
          TextField(
            controller: TextEditingController(text: vrProvider.newComment),
            onChanged: vrProvider.setNewComment,
            decoration: InputDecoration(
              hintText: 'اكتب تعليقك عن هذا العمل الفني...',
              hintStyle: TextStyle(
                fontFamily: 'Tajawal',
                color: Theme.of(context!).colorScheme.secondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            maxLines: 3,
            textAlign: TextAlign.right,
          ),

          const SizedBox(height: 12),

          // زر إرسال التعليق
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => vrProvider.addComment(vrProvider.newComment),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context!).primaryColor,
                foregroundColor: Theme.of(context!).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: const Icon(
                      Icons.send,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(child: const SizedBox(width: 6)),
                  Expanded(
                    child: const Text(
                      'إرسال التعليق',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // التعليقات الأخيرة
          _buildRecentComments(),
        ],
      ),
    );
  }

  Widget _buildRecentComments() {
    if (vrProvider.comments.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تعليقات بعد',
          style: Theme.of(context!).textTheme.bodyMedium,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('آخر التعليقات:', style: Theme.of(context!).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...vrProvider.comments
            .take(3)
            .map((comment) => _buildCommentItem(comment)),
      ],
    );
  }

  Widget _buildCommentItem(ArtworkComment comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context!).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  comment.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  _formatDate(comment.createdAt),
                  style: Theme.of(context!).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment.comment, style: Theme.of(context!).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                onPressed: () => vrProvider.likeComment(comment.id),
                icon: Icon(
                  Icons.thumb_up,
                  color: Theme.of(context!).primaryColorDark,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                comment.likes.toString(),
                style: Theme.of(context!).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
