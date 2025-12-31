import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/core/utils/exhibition/animations.dart';

class HeroSection extends StatefulWidget {
  final AnimationController animationController;
  final BuildContext? context;

  const HeroSection({
    super.key,
    required this.animationController,
    required this.context,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _heroImages = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpg',
    'assets/images/image3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        int nextPage = _currentPage + 1;
        if (nextPage >= _heroImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      height: screenHeight * 0.6, // Adjusted height
      decoration: BoxDecoration(color: AppColors.getPrimaryColor(isDark)),
      child: Stack(
        children: [
          // Slideshow
          PageView.builder(
            controller: _pageController,
            itemCount: _heroImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _heroImages[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryDark,
                              AppColors.getPrimaryColor(isDark),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: _buildBackgroundPattern(),
                      );
                    },
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Content
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
                        fontSize: _getResponsiveFontSize(context, 50, 36),
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // العنوان الفرعي
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      'استكشف عالم الفن التشكيلي اليمني',
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context, 24, 18),
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.95)
                            : Colors.white,
                        fontFamily: 'Tajawal',
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // زر الاستكشاف
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 700),
                    child: _buildExploreButton(context),
                  ),
                ],
              ),
            ),
          ),

          // Indicators
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _heroImages.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: _currentPage == entry.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return CustomPaint(
      size: Size.infinite,
      painter: _ExhibitionPatternPainter(),
    );
  }

  Widget _buildExploreButton(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;
    return ElevatedButton(
      onPressed: () {
        // Scroll down or open dropdown
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('استكشف المعارض في الأسفل!')),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.getPrimaryColor(isDark),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.explore, size: 24),
          SizedBox(width: 8),
          Text(
            'تصفح المعارض',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
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
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (double x = 20; x < size.width; x += 100) {
      for (double y = 20; y < size.height; y += 100) {
        canvas.drawRect(Rect.fromLTWH(x, y, 60, 40), paint);
        canvas.drawCircle(Offset(x + 50, y + 40), 15, paint);
        canvas.drawLine(Offset(x + 30, y + 70), Offset(x + 70, y + 70), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}



