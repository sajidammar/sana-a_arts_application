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
