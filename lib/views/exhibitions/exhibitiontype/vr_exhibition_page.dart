import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/themes/exhibition/colors.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';
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
    return Column(
      children: [
        // الهيدر
        _buildHeader(context, vrProvider),
        const SizedBox(height: 10),

        // المحتوى الرئيسي
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: VRViewer(
              animationController: _animationController,
              vrProvider: vrProvider,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VRProvider>(
      builder: (context, vrProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
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

  Widget _buildHeader(BuildContext context, VRProvider vrProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المعرض الافتراضي',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'تراث صنعاء الخالد',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.image_outlined,
                  size: 14,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '${vrProvider.currentArtworkIndex + 1} / ${vrProvider.artworks.length}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
