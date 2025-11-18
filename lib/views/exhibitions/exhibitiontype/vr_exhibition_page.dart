import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/themes/exhibition/colors.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';
import 'widgets/vr_viewer.dart';
import 'widgets/vr_controls.dart';

class VRExhibitionPage extends StatefulWidget {
  const VRExhibitionPage({super.key});

  @override
  State<VRExhibitionPage> createState() => _VRExhibitionPageState();
}

class _VRExhibitionPageState extends State<VRExhibitionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

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

  @override
  Widget build(BuildContext context) {
    return Consumer<VRProvider>(
      builder: (context, vrProvider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // الهيدر
                  _buildHeader(context, vrProvider),
                  SizedBox(height: 10),

                  // المحتوى الرئيسي
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: VRViewer(
                        animationController: _animationController,
                        vrProvider: vrProvider,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // الشريط الجانبي
                  // Expanded(
                  //   child: ArtworkDetails(
                  //     animationController: _animationController,
                  //     vrProvider: vrProvider,
                  //   ),
                  // ),

                  // عناصر التحكم
                  VRControls(
                    animationController: _animationController,
                    vrProvider: vrProvider,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, VRProvider vrProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.virtualGradient,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).hoverColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // زر العودة
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),

          const SizedBox(width: 16),

          // العنوان
          Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.card_membership_sharp,
                  color: Theme.of(context).colorScheme.surface,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'المعرض الافتراضي - تراث صنعاء الخالد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surface,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // عداد الأعمال الفنية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${vrProvider.currentArtworkIndex + 1} / ${vrProvider.artworks.length}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
