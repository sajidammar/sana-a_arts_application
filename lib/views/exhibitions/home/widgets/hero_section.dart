import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';
import 'package:sanaa_artl/views/exhibitions/exhibitiontype/vr_exhibition_page.dart';

class HeroSection extends StatelessWidget {
  final AnimationController animationController;

  const HeroSection({
    super.key,
    required this.animationController,
    required this.context,
  });

  final BuildContext? context;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // نمط الخلفية المتحرك
          _buildBackgroundPattern(),

          // المحتوى الرئيسي
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // العنوان الرئيسي
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      'المعارض الفنية',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 60, 40),
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).chipTheme.backgroundColor,
                        fontFamily: 'Tajawal',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // العنوان الفرعي
                  Expanded(
                    child: SlideInAnimation(
                      delay: const Duration(milliseconds: 500),
                      child: Text(
                        'استكشف عالم الفن التشكيلي اليمني',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(context, 32, 24),
                          fontWeight: FontWeight.w300,
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.95),
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // الوصف
                  Expanded(
                    child: SlideInAnimation(
                      delay: const Duration(milliseconds: 700),
                      child: Text(
                        'معارض افتراضية وواقعية ومفتوحة تعرض أجمل الأعمال الفنية من صنعاء إلى العالم',
                        style: TextStyle(
                          fontSize: _getResponsiveFontSize(context, 20, 16),
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.9),
                          fontFamily: 'Tajawal',
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // زر الاستكشاف الرئيسي
                  Expanded(
                    child: SlideInAnimation(
                      delay: const Duration(milliseconds: 900),
                      child: _buildExploreButton(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 45),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-100 * value, -100 * value),
          child: Transform.rotate(
            angle: value * 2 * 3.14159,
            child: CustomPaint(
              size: Size.infinite,
              painter: _ExhibitionPatternPainter(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExploreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showExhibitionDropdown(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 10,
        shadowColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cable, size: 24),
          const SizedBox(width: 12),
          Text(
            'استكشف المعارض',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _showExhibitionDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      builder: (context) => _buildExhibitionDropdown(context),
    );
  }

  Widget _buildExhibitionDropdown(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // رأس القائمة المنسدلة
          _buildDropdownHeader(),

          // خيارات المعارض
          _buildExhibitionOptions(context),
        ],
      ),
    );
  }

  Widget _buildDropdownHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context!).colorScheme.onPrimary),
        ),
      ),
      child: Column(
        children: [
          Text(
            'اختر نوع المعرض',
            style: Theme.of(context!).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'اكتشف الفن بطرق مختلفة ومبتكرة',
            style: Theme.of(context!).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildExhibitionOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildExhibitionOption(
            title: 'المعرض الافتراضي',
            description: 'تجربة تفاعلية ثلاثية الأبعاد مع تقنية VR',
            gradient: Theme.of(context).primaryColorDark,
            icon: Icons.card_membership_sharp,
            features: ['VR 360°', 'جولات تفاعلية', 'تقييم مباشر'],
            onTap: () {
              Navigator.pop(context);
              _openVirtualExhibition(context);
            },
          ),
          const SizedBox(height: 12),
          // _buildExhibitionOption(
          //   title: 'المعرض الواقعي',
          //   description: 'معارض فنية في مواقع حقيقية يمكنك زيارتها',
          //   gradient: AppColors.realityGradient,
          //   icon: Icons.location_on,
          //   features: ['حجز مباشر', 'خرائط تفاعلية', 'جولات مرشدة'],
          //   onTap: () {
          //     Navigator.pop(context);
          //     _showRealityExhibitions(context);
          //   },
          // ),
          const SizedBox(height: 12),
          _buildExhibitionOption(
            title: 'المعرض المفتوح',
            description: 'منصة مفتوحة للفنانين لعرض أعمالهم',
            gradient: Theme.of(context).primaryColorDark,
            icon: Icons.upload,
            features: ['مشاركة مفتوحة', 'تصويت جماعي', 'مجتمع فني'],
            onTap: () {
              Navigator.pop(context);
              _showOpenExhibitions(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExhibitionOption({
    required String title,
    required String description,
    required Color gradient,
    required IconData icon,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: Border.all(color: Theme.of(context!).colorScheme.onPrimary),
          ),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context!).colorScheme.surface,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context!).colorScheme.secondary,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // الميزات
                    Wrap(
                      spacing: 8,
                      children:
                          features
                              .map(
                                (feature) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context!,
                                        ).scaffoldBackgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
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

  // void _showRealityExhibitions(BuildContext context) {
  //   final exhibitionProvider = Provider.of<ExhibitionProvider>(
  //     context,
  //     listen: false,
  //   );
  //   exhibitionProvider.setFilter(ExhibitionType.reality);
  //   // يمكن إضافة تمرير إلى قسم المعارض
  // }

  void _showOpenExhibitions(BuildContext context) {
    final exhibitionProvider = Provider.of<ExhibitionProvider>(
      context,
      listen: false,
    );
    exhibitionProvider.setFilter(ExhibitionType.open);
    // يمكن إضافة تمرير إلى قسم المعارض
  }

  double _getResponsiveFontSize(
    BuildContext context,
    double desktop,
    double mobile,
  ) {
    final width = MediaQuery.of(context).size.width;
    return width > 768 ? desktop : mobile;
  }
}

class _ExhibitionPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // رسم النمط المشابه للتصميم الأصلي
    for (double x = 20; x < size.width; x += 100) {
      for (double y = 20; y < size.height; y += 100) {
        // رسم المستطيل
        canvas.drawRect(Rect.fromLTWH(x, y, 60, 40), paint);

        // رسم الدائرة
        canvas.drawCircle(Offset(x + 50, y + 40), 15, paint);

        // رسم الخط
        canvas.drawLine(Offset(x + 30, y + 70), Offset(x + 70, y + 70), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
