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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // شريط التقدم
          // _buildProgressBar(),
          const SizedBox(height: 16),

          // أزرار التحكم السريع
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickActionButton(
          icon: Icons.chat_rounded,
          label: 'دردشة',
          onTap:vrProvider.addToFavorites,
          context: context,
        ),
        _buildQuickActionButton(
          icon: Icons.shopping_cart,
          label: 'السلة',
          onTap: vrProvider.addToCart,
          context: context,
        ),

        _buildQuickActionButton(
          icon: Icons.person,
          label: 'الفنان',
          onTap: vrProvider.viewArtistProfile,
          context: context,
        ),
        _buildQuickActionButton(
          icon: Icons.share,
          label: 'المعرض الافتراضي',
          onTap: vrProvider.shareArtwork,
          context: context,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.onSurface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.surface,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
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
}
