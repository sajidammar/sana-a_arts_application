import 'package:flutter/material.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';

class VRControls extends StatelessWidget {
  final AnimationController animationController;
  final VRProvider vrProvider;

  const VRControls({
    super.key,
    required this.animationController,
    required this.vrProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildControlButton(
              context,
              Icons.chat_bubble_outline_rounded,
              'دردشة',
              vrProvider.addToFavorites,
            ),
            _buildControlButton(
              context,
              Icons.shopping_bag_outlined,
              'السلة',
              vrProvider.addToCart,
            ),
            _buildCenterButton(context),
            _buildControlButton(
              context,
              Icons.person_outline_rounded,
              'الفنان',
              vrProvider.viewArtistProfile,
            ),
            _buildControlButton(
              context,
              Icons.share_outlined,
              'مشاركة',
              vrProvider.shareArtwork,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.vrpano_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontSize: 12,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
