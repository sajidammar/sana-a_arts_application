import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/themes/exhibition/colors.dart' show AppColors;
import 'package:sanaa_artl/utils/exhibition/animations.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';
import 'package:sanaa_artl/views/exhibitions/exhibitiontype/vr_exhibition_page.dart';

class ExhibitionTypesSection extends StatelessWidget {
  final AnimationController animationController;

  const ExhibitionTypesSection({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // عنوان القسم
          SlideInAnimation(
            delay: const Duration(milliseconds: 200),
            child: Text(
              'أنواع المعارض',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                foreground:
                    Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorDark,
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                fontFamily: 'Tajawal',
              ),
            ),
          ),

          const SizedBox(height: 8),

          // خط تحت العنوان
          SlideInAnimation(
            delay: const Duration(milliseconds: 300),
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                gradient: AppColors.goldGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 48),

          // شبكة أنواع المعارض
          _buildTypesGrid(context),
        ],
      ),
    );
  }

  Widget _buildTypesGrid(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      children: [
        _buildTypeCard(
          context: context,
          type: ExhibitionType.virtual,
          title: 'المعرض الافتراضي',
          description:
              'تجربة تفاعلية ثلاثية الأبعاد تمكنك من استكشاف الأعمال الفنية بتقنية الواقع الافتراضي',
          icon: Icons.card_membership_sharp,
          features: [
            'دعم الواقع الافتراضي VR و 360°',
            'تقنيات ثلاثية الأبعاد',
            'واجهة تفاعلية متقدمة',
            'تكبير وتصغير بدقة عالية',
            'جولات صوتية مرشدة',
          ],
          buttonText: 'ادخل المعرض',
          buttonIcon: Icons.play_arrow,
          onTap: () => _openVirtualExhibition(context),
        ),

        _buildTypeCard(
          context: context,
          type: ExhibitionType.open,
          title: 'المعرض المفتوح',
          description:
              'منصة مفتوحة للفنانين لعرض أعمالهم والمشاركة في مجتمع فني إبداعي',
          icon: Icons.upload,
          features: [
            'رفع الأعمال بموافقة الإدارة',
            'نظام تصويت وتقييم',
            'فلترة حسب الأسلوب والفنان',
            'تنبيهات وملاحظات للمستخدمين',
            'مجتمع تفاعلي للفنانين',
          ],
          buttonText: 'ارفع عملك',
          buttonIcon: Icons.add,
          onTap: () => _showOpenExhibitions(context),
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required ExhibitionType type,
    required String title,
    required String description,
    required IconData icon,
    required List<String> features,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onTap,
  }) {
    return ScaleAnimation(
      delay: const Duration(milliseconds: 400),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(
                  context,
                ).scaffoldBackgroundColor.withValues(alpha: 0.8),
                Theme.of(context).colorScheme.surface,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // الأيقونة
                Icon(icon, size: 60, color: Theme.of(context).primaryColor),

                // العنوان
                Text(
                  title,
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),

                // الوصف
                Expanded(
                  child: Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // الميزات
                Column(
                  children:
                      features
                          .take(3)
                          .map(
                            (feature) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),

                // الزر
                Expanded(
                  flex: 0,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(buttonIcon, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Tajawal',
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
      ),
    );
  }

  void _openVirtualExhibition(BuildContext context) {
    final exhibitionProvider = Provider.of<ExhibitionProvider>(
      context,
      listen: false,
    );
    final vrProvider = Provider.of<VRProvider>(context, listen: false);

    vrProvider.loadArtworks(exhibitionProvider.artworks);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VRExhibitionPage()),
    );
  }

  void _showOpenExhibitions(BuildContext context) {
    final exhibitionProvider = Provider.of<ExhibitionProvider>(
      context,
      listen: false,
    );
    exhibitionProvider.setFilter(ExhibitionType.open);
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }
}
