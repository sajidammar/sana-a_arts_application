import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/vr_provider.dart';
import 'package:sanaa_artl/features/exhibitions/models/artwork.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'vr_comments_sidebar.dart';

class VRViewer extends StatefulWidget {
  final AnimationController animationController;
  final VRProvider vrProvider;

  const VRViewer({
    super.key,
    required this.animationController,
    required this.vrProvider,
  });

  @override
  State<VRViewer> createState() => _VRViewerState();
}

class _VRViewerState extends State<VRViewer> {
  bool _isCommentsVisible = false;

  void _toggleComments() {
    setState(() {
      _isCommentsVisible = !_isCommentsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final currentArtwork = widget.vrProvider.currentArtwork;

    return Container(
      decoration: BoxDecoration(
        gradient:
            widget.vrProvider.isVRMode ||
                widget.vrProvider.is360Mode ||
                widget.vrProvider.is3DMode
            ? AppColors.goldGradient
            : AppColors.virtualGradient,
      ),
      child: Stack(
        children: [
          // نمط الشبكة الخلفية
          if (widget.vrProvider.isVRMode ||
              widget.vrProvider.is360Mode ||
              widget.vrProvider.is3DMode)
            _buildVRGrid(),

          // عرض العمل الفني
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الصورة مع التأثيرات
                    if (widget.vrProvider.artworks.isNotEmpty)
                      _buildArtworkImage(currentArtwork)
                    else
                      _buildNoArtworkMessage(),

                    const SizedBox(height: 24),

                    // عناصر التحكم الأساسية
                    _buildBasicControls(context),

                    const SizedBox(height: 16),

                    // عناصر التحكم المتقدمة
                    if (widget.vrProvider.isVRMode ||
                        widget.vrProvider.is360Mode ||
                        widget.vrProvider.is3DMode)
                      _buildAdvancedControls(context),

                    const SizedBox(height: 24),

                    // تفاصيل العمل الفني
                    if (widget.vrProvider.artworks.isNotEmpty)
                      _buildArtworkDetails(currentArtwork, isDark),

                    // عناصر التكبير والتنقل
                    if (widget.vrProvider.is3DMode)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _buildNavigationControls(context),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // شارة الجولة التلقائية
          if (widget.vrProvider.isAutoTourOn)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'الجولة التلقائية نشطة',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // زر التعليقات العائم
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: _toggleComments,
              backgroundColor: AppColors.getPrimaryColor(isDark),
              child: const Icon(Icons.comment_rounded, color: Colors.white),
            ),
          ),

          // شريط التعليقات الجانبي
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: 0,
            bottom: 0,
            right: _isCommentsVisible ? 0 : -320,
            child: VRCommentsSidebar(
              artworkId: currentArtwork.id,
              onClose: _toggleComments,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoArtworkMessage() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.image_not_supported,
            size: 80,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد أعمال فنية لعرضها',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkImage(Artwork artwork) {
    Widget imageWidget = Container(
      constraints: BoxConstraints(maxWidth: 500, maxHeight: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: artwork.imageUrl.isNotEmpty
            ? Image.asset(
                artwork.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.white60,
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(Icons.image, size: 80, color: Colors.white60),
                ),
              ),
      ),
    );

    // تطبيق تأثيرات حسب الوضع
    if (widget.vrProvider.is3DMode) {
      // تأثير 3D مع دوران
      return TweenAnimationBuilder(
        duration: const Duration(seconds: 3),
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, double value, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((value * 0.5) * 3.14159)
              ..rotateX((value * 0.2) * 3.14159),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: widget.vrProvider.zoomLevel,
              child: child,
            ),
          );
        },
        child: imageWidget,
      );
    } else if (widget.vrProvider.is360Mode) {
      // تأثير دوران 360 درجة
      return TweenAnimationBuilder(
        duration: const Duration(seconds: 8),
        tween: Tween(begin: 0.0, end: 2 * 3.14159),
        builder: (context, double value, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: widget.vrProvider.zoomLevel,
              child: child,
            ),
          );
        },
        onEnd: () {
          // إعادة التشغيل
          setState(() {});
        },
        child: imageWidget,
      );
    } else {
      // عرض عادي مع تكبير
      return Transform.scale(
        scale: widget.vrProvider.zoomLevel,
        child: imageWidget,
      );
    }
  }

  Widget _buildArtworkDetails(Artwork artwork, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            artwork.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 8),

          // الفنان والسنة
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                artwork.artist,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                '${artwork.year}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // التقنية والأبعاد
          if (artwork.technique.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.brush, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      artwork.technique,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (artwork.dimensions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.straighten, color: Colors.white70, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    artwork.dimensions,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),

          // الوصف
          if (artwork.description.isNotEmpty)
            Text(
              artwork.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Tajawal',
                height: 1.5,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 12),

          // السعر والتقييم
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (artwork.isForSale && artwork.price > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    '${artwork.price} ${artwork.currency}',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),

              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${artwork.rating.toStringAsFixed(1)} (${artwork.ratingCount})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVRGrid() {
    return TweenAnimationBuilder(
      duration: const Duration(seconds: 20),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-10 * value, -10 * value),
          child: CustomPaint(
            size: Size.infinite,
            painter: _VRGridPainter(color: Colors.white.withValues(alpha: 0.1)),
          ),
        );
      },
    );
  }

  Widget _buildBasicControls(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildControlButton(
          icon: Icons.sync_alt,
          label: 'عرض 360°',
          isActive: widget.vrProvider.is360Mode,
          onTap: widget.vrProvider.toggle360Mode,
          context: context,
        ),
        _buildControlButton(
          icon: Icons.cable,
          label: 'عرض 3D',
          isActive: widget.vrProvider.is3DMode,
          onTap: widget.vrProvider.toggle3DMode,
          context: context,
        ),
        _buildControlButton(
          icon: widget.vrProvider.isAudioGuideOn
              ? Icons.volume_up
              : Icons.volume_off,
          label: 'الدليل الصوتي',
          isActive: widget.vrProvider.isAudioGuideOn,
          onTap: widget.vrProvider.toggleAudioGuide,
          context: context,
        ),
      ],
    );
  }

  Widget _buildAdvancedControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          _buildSmallControlButton(
            icon: Icons.play_arrow,
            label: 'جولة تلقائية',
            isActive: widget.vrProvider.isAutoTourOn,
            onTap: widget.vrProvider.toggleAutoTour,
            context: context,
          ),
          _buildSmallControlButton(
            icon: Icons.refresh,
            label: 'إعادة تعيين',
            isActive: false,
            onTap: widget.vrProvider.resetView,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.getCardColor(isDark).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Wrap(
              children: [
                _buildNavButton(
                  icon: Icons.chevron_right,
                  label: 'السابق',
                  onTap: () => widget.vrProvider.navigateToPreviousArtwork(),
                  context: context,
                ),
                _buildZoomButton(
                  icon: Icons.zoom_out,
                  onTap: widget.vrProvider.zoomOut,
                  context: context,
                ),
                const SizedBox(width: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.getCardColor(
                      isDark,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(widget.vrProvider.zoomLevel * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                _buildZoomButton(
                  icon: Icons.zoom_in,
                  onTap: widget.vrProvider.zoomIn,
                  context: context,
                ),
                _buildNavButton(
                  icon: Icons.chevron_left,
                  label: 'التالي',
                  onTap: () => widget.vrProvider.navigateToNextArtwork(),
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label == 'التالي') ...[
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(width: 3),
              ],
              Icon(icon, color: Colors.white, size: 20),
              if (label == 'السابق') ...[
                const SizedBox(width: 3),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _VRGridPainter extends CustomPainter {
  final Color color;

  _VRGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // رسم شبكة VR
    for (double x = 0; x < size.width; x += 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += 10) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _VRGridPainter oldDelegate) =>
      color != oldDelegate.color;
}
