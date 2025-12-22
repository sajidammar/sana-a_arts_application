import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/app_colors.dart';
import 'package:sanaa_artl/models/exhibition/artwork.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final artwork = vrProvider.currentArtwork;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان القسم
            _buildSectionHeader('تفاصيل العمل الحالي', isDark),

            const SizedBox(height: 16),

            // معلومات العمل الفني
            _buildArtworkInfo(artwork, context, isDark),

            const SizedBox(height: 24),

            // الميزات التفاعلية
            _buildInteractiveFeatures(isDark),

            const SizedBox(height: 24),

            // إجراءات العمل
            _buildArtworkActions(isDark),

            const SizedBox(height: 24),

            // التقييم
            _buildRatingSection(isDark),

            const SizedBox(height: 24),

            // التعليقات
            _buildCommentSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 200),
      child: Row(
        children: [
          Icon(Icons.info, color: AppColors.getPrimaryColor(isDark)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkInfo(Artwork artwork, BuildContext context, bool isDark) {
    return ScaleAnimation(
      delay: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getBackgroundColor(isDark),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Column(
          children: [
            _buildInfoRow('العنوان:', artwork.title, isDark),
            _buildInfoRow('الفنان:', artwork.artist, isDark),
            _buildInfoRow('السنة:', artwork.year.toString(), isDark),
            _buildInfoRow('التقنية:', artwork.technique, isDark),
            _buildInfoRow('الأبعاد:', artwork.dimensions, isDark),
            _buildInfoRow('السعر:', artwork.formattedPrice, isDark),
            _buildInfoRow('التصنيف:', artwork.category, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
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
                color: AppColors.getPrimaryColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveFeatures(bool isDark) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الميزات التفاعلية', isDark),
          const SizedBox(height: 12),
          ..._buildFeatureList(isDark),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureList(bool isDark) {
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
                  color: AppColors.getPrimaryColor(isDark),
                  size: 18,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature['text'] as String,
                    style: TextStyle(
                      color: AppColors.getSubtextColor(isDark),
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

  Widget _buildArtworkActions(bool isDark) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('إجراءات العمل', isDark),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                'إضافة للمفضلة',
                Icons.favorite,
                AppColors.getPrimaryColor(isDark),
                vrProvider.addToFavorites,
                isDark,
              ),
              _buildActionButton(
                'إضافة للسلة',
                Icons.shopping_cart,
                AppColors.virtualGradient.colors.first,
                vrProvider.addToCart,
                isDark,
              ),
              _buildActionButton(
                'تحميل عالي الجودة',
                Icons.download,
                AppColors.openGradient.colors.first,
                vrProvider.downloadHighRes,
                isDark,
              ),
              _buildActionButton(
                'ملف الفنان',
                Icons.person,
                AppColors.getPrimaryColor(isDark),
                vrProvider.viewArtistProfile,
                isDark,
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
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
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
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.getTextColor(isDark),
                  fontSize: 14,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection(bool isDark) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('تقييم العمل', isDark),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.getBackgroundColor(isDark),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Column(
              children: [
                // النجوم
                _buildRatingStars(isDark),
                const SizedBox(height: 8),
                // معلومات التقييم
                Text(
                  'التقييم الحالي: ${vrProvider.currentArtwork.rating}/5 (${vrProvider.currentArtwork.ratingCount} تقييم)',
                  style: TextStyle(
                    color: AppColors.getTextColor(isDark),
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

  Widget _buildRatingStars(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => vrProvider.rateArtwork(index + 1),
          icon: Icon(
            index < vrProvider.userRating ? Icons.star : Icons.star_border,
            color: AppColors.getPrimaryColor(isDark),
            size: 28,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        );
      }),
    );
  }

  Widget _buildCommentSection(bool isDark) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 1200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التعليقات المباشرة', isDark),
          const SizedBox(height: 12),

          // حقل إدخال التعليق
          TextField(
            controller: TextEditingController(text: vrProvider.newComment),
            onChanged: vrProvider.setNewComment,
            style: TextStyle(color: AppColors.getTextColor(isDark)),
            decoration: InputDecoration(
              hintText: 'اكتب تعليقك عن هذا العمل الفني...',
              hintStyle: TextStyle(
                fontFamily: 'Tajawal',
                color: AppColors.getSubtextColor(isDark),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.getPrimaryColor(isDark),
                ),
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
                backgroundColor: AppColors.getPrimaryColor(isDark),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.send, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'إرسال التعليق',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // التعليقات الأخيرة
          _buildRecentComments(isDark),
        ],
      ),
    );
  }

  Widget _buildRecentComments(bool isDark) {
    if (vrProvider.comments.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تعليقات بعد',
          style: TextStyle(
            color: AppColors.getSubtextColor(isDark),
            fontFamily: 'Tajawal',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'آخر التعليقات:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(isDark),
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 8),
        ...vrProvider.comments
            .take(3)
            .map((comment) => _buildCommentItem(comment, isDark)),
      ],
    );
  }

  Widget _buildCommentItem(ArtworkComment comment, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.getBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextColor(isDark),
                  fontFamily: 'Tajawal',
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(comment.createdAt),
                style: TextStyle(
                  color: AppColors.getSubtextColor(isDark),
                  fontSize: 12,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            comment.comment,
            style: TextStyle(
              color: AppColors.getTextColor(isDark),
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                onPressed: () => vrProvider.likeComment(comment.id),
                icon: Icon(
                  Icons.thumb_up,
                  color: AppColors.getPrimaryColor(isDark),
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 4),
              Text(
                comment.likes.toString(),
                style: TextStyle(
                  color: AppColors.getSubtextColor(isDark),
                  fontFamily: 'Tajawal',
                ),
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
