import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/themes/academy/colors.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';
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
    return Container(
      decoration: BoxDecoration(
        gradient: widget.vrProvider.isVRMode
            ? AppColors.goldGradient
            : AppColors.virtualGradient,
      ),
      child: Stack(
        children: [
          // نمط الشبكة الخلفية
          if (widget.vrProvider.isVRMode || widget.vrProvider.is360Mode)
            _buildVRGrid(),

          // الواجهة التفاعلية
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // الأيقونة الرئيسية
                    ScaleAnimation(
                      delay: const Duration(milliseconds: 300),
                      child: _buildVRIcon(context),
                    ),

                    const SizedBox(height: 24),

                    // النص الإرشادي
                    SlideInAnimation(
                      delay: const Duration(milliseconds: 500),
                      child: _buildGuideText(context),
                    ),

                    const SizedBox(height: 32),

                    // عناصر التحكم الأساسية
                    SlideInAnimation(
                      delay: const Duration(milliseconds: 700),
                      child: _buildBasicControls(context),
                    ),

                    // عناصر التحكم المتقدمة
                    if (widget.vrProvider.isVRMode ||
                        widget.vrProvider.is360Mode)
                      SlideInAnimation(
                        delay: const Duration(milliseconds: 900),
                        child: _buildAdvancedControls(context),
                      ),

                    // عناصر التكبير والتنقل
                    if (widget.vrProvider.is3DMode)
                      SlideInAnimation(
                        delay: const Duration(milliseconds: 1100),
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

          // زر التعليقات العائم (لفتح الشريط)
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
            right: _isCommentsVisible ? 0 : -320, // Slide in/out
            child: VRCommentsSidebar(
              artworkId: 'current_artwork_id', // Replace with actual ID
              onClose: _toggleComments,
            ),
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
            painter: _VRGridPainter(color: Colors.white.withOpacity(0.1)),
          ),
        );
      },
    );
  }

  Widget _buildVRIcon(BuildContext context) {
    IconData icon;
    double size;
    Animation<double>? animation;

    if (widget.vrProvider.is3DMode) {
      icon = CupertinoIcons.cube;
      size = 80;
    } else if (widget.vrProvider.isVRMode) {
      icon = CupertinoIcons.video_camera_solid;
      size = 70;
    } else if (widget.vrProvider.is360Mode) {
      icon = Icons.sync_alt;
      size = 70;
      animation = Tween(begin: 0.0, end: 2 * 3.14159).animate(
        CurvedAnimation(
          parent: widget.animationController,
          curve: Curves.linear,
        ),
      );
    } else {
      icon = CupertinoIcons.cube;
      size = 60;
    }

    Widget iconWidget = Icon(
      icon,
      size: size,
      color: Colors.white.withOpacity(0.9),
    );

    if (animation != null) {
      iconWidget = AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.rotate(angle: animation!.value, child: child);
        },
        child: iconWidget,
      );
    }

    if (widget.vrProvider.is3DMode) {
      iconWidget = TweenAnimationBuilder(
        duration: const Duration(seconds: 10),
        tween: Tween(begin: 0.0, end: 2 * 3.14159),
        builder: (context, value, child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateY(value)
              ..rotateX(value * 0.5),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: iconWidget,
    );
  }

  Widget _buildGuideText(BuildContext context) {
    return Column(
      children: [
        const Text(
          'تجربة الواقع الافتراضي',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'اضغط وحرك الماوس للتنقل في المعرض',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'استخدم العجلة للتكبير والتصغير',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            fontFamily: 'Tajawal',
          ),
        ),
      ],
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
            icon: Icons.fullscreen,
            label: 'شاشة كاملة',
            isActive: widget.vrProvider.isFullscreenMode,
            onTap: widget.vrProvider.toggleFullscreenMode,
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
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
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
            color: Colors.white.withOpacity(0.2),
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
            color: Colors.white.withOpacity(0.2),
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
