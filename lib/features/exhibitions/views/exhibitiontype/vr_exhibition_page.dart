import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/vr_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/core/utils/exhibition/constants.dart';
import 'widgets/vr_viewer.dart';
import 'widgets/vr_controls.dart';
import 'pages/cart_page.dart';
import 'pages/artist_profile_page.dart';

class VRExhibitionPage extends StatefulWidget {
  const VRExhibitionPage({super.key});

  @override
  State<VRExhibitionPage> createState() => _VRExhibitionPageState();
}

class _VRExhibitionPageState extends State<VRExhibitionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _currentPageIndex = 2; // VR Viewer هو الصفحة الافتراضية

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.longAnimationDuration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _getCurrentPage(VRProvider vrProvider) {
    switch (_currentPageIndex) {
      case 0: // المفضلة - نعرض VR Viewer لأن المفضلة هي إجراء وليس صفحة
        return _buildVRViewerPage(vrProvider);
      case 1: // السلة
        return const ExhibitionCartPage();
      case 2: // VR Viewer (الافتراضي)
        return _buildVRViewerPage(vrProvider);
      case 3: // الفنان
        return const ArtistProfilePage();
      case 4: // مشاركة - نعرض VR Viewer
        return _buildVRViewerPage(vrProvider);
      default:
        return _buildVRViewerPage(vrProvider);
    }
  }

  Widget _buildVRViewerPage(VRProvider vrProvider) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: true,
          backgroundColor: AppColors.getBackgroundColor(isDark),
          elevation: 1,
          toolbarHeight: 70,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87,
              size: 20,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المعرض الافتراضي',
                style: TextStyle(
                  color: AppColors.getSubtextColor(isDark),
                  fontSize: 12,
                ),
              ),
              Text(
                'تراث صنعاء الخالد',
                style: TextStyle(
                  color: AppColors.getTextColor(isDark),
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.getPrimaryColor(
                    isDark,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.getPrimaryColor(
                      isDark,
                    ).withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 14,
                      color: AppColors.getPrimaryColor(isDark),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${vrProvider.currentArtworkIndex + 1} / ${vrProvider.artworks.length}',
                      style: TextStyle(
                        color: AppColors.getPrimaryColor(isDark),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VRViewer(
              animationController: _animationController,
              vrProvider: vrProvider,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Consumer<VRProvider>(
      builder: (context, vrProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.getBackgroundColor(isDark),
          body: SafeArea(
            child: Column(
              children: [
                // المحتوى الحالي
                Expanded(child: _getCurrentPage(vrProvider)),

                // الشريط السفلي الثابت
                VRControls(
                  animationController: _animationController,
                  vrProvider: vrProvider,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


