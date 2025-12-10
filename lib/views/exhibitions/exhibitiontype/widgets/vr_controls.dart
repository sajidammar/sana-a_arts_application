import 'package:flutter/material.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';
import 'package:sanaa_artl/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class VRControls extends StatefulWidget {
  final AnimationController animationController;
  final VRProvider vrProvider;
  final Function(int)? onPageChanged;

  const VRControls({
    super.key,
    required this.animationController,
    required this.vrProvider,
    this.onPageChanged,
  });

  @override
  State<VRControls> createState() => _VRControlsState();
}

class _VRControlsState extends State<VRControls>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2; // الزر الأوسط (VR) هو الافتراضي
  late AnimationController _circleAnimationController;
  late Animation<Offset> _circleAnimation;

  @override
  void initState() {
    super.initState();
    _circleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _circleAnimation =
        Tween<Offset>(
          begin: const Offset(0.5, 0), // المنتصف
          end: const Offset(0.5, 0),
        ).animate(
          CurvedAnimation(
            parent: _circleAnimationController,
            curve: Curves.easeInOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _circleAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      // عكس الاتجاه: 4-index بدلاً من index مباشرة
      double currentPosition = (4 - _selectedIndex) / 4;
      double targetPosition = (4 - index) / 4;

      _circleAnimation =
          Tween<Offset>(
            begin: Offset(currentPosition, 0),
            end: Offset(targetPosition, 0),
          ).animate(
            CurvedAnimation(
              parent: _circleAnimationController,
              curve: Curves.easeInOutCubic,
            ),
          );

      _selectedIndex = index;
      _circleAnimationController.forward(from: 0);
    });

    if (widget.onPageChanged != null) {
      widget.onPageChanged!(index);
    }
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                // الأزرار
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildControlButton(
                      context,
                      Icons.favorite_border,
                      Icons.favorite,
                      'المفضلة',
                      0,
                      () {
                        _onItemTapped(0);
                        widget.vrProvider.addToFavorites();

                        // إضافة المعرض للمفضلة
                        final wishlistProvider = context
                            .read<WishlistProvider>();
                        final exhibition =
                            widget.vrProvider.lastExhibitionToAdd;
                        if (exhibition != null) {
                          wishlistProvider.addToWishlist(exhibition);
                          widget.vrProvider.clearLastExhibitionToAdd();
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إضافة المعرض إلى المفضلة'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    _buildControlButton(
                      context,
                      Icons.shopping_bag_outlined,
                      Icons.shopping_bag,
                      'السلة',
                      1,
                      () {
                        _onItemTapped(1);
                      },
                    ),
                    _buildControlButton(
                      context,
                      Icons.vrpano_rounded,
                      Icons.vrpano_rounded,
                      'VR',
                      2,
                      () {
                        _onItemTapped(2);
                      },
                    ),
                    _buildControlButton(
                      context,
                      Icons.person_outline_rounded,
                      Icons.person,
                      'الفنان',
                      3,
                      () {
                        _onItemTapped(3);
                      },
                    ),
                    _buildControlButton(
                      context,
                      Icons.share_outlined,
                      Icons.share,
                      'مشاركة',
                      4,
                      () {
                        _onItemTapped(4);
                        _shareArtwork(context);
                      },
                    ),
                  ],
                ),

                // الدائرة المتحركة
                AnimatedBuilder(
                  animation: _circleAnimation,
                  builder: (context, child) {
                    // حساب الموضع باستخدام عرض الشاشة
                    final buttonWidth = constraints.maxWidth / 5;
                    final circlePosition =
                        (_circleAnimation.value.dx * 4 * buttonWidth) +
                        (buttonWidth / 2) -
                        30;

                    return Positioned(
                      left: circlePosition,
                      top: -30,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getSelectedIconForIndex(_selectedIndex),
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _getLabelForIndex(_selectedIndex),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontFamily: 'Tajawal',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _getSelectedIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.favorite;
      case 1:
        return Icons.shopping_bag;
      case 2:
        return Icons.vrpano_rounded;
      case 3:
        return Icons.person;
      case 4:
        return Icons.share;
      default:
        return Icons.vrpano_rounded;
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'المفضلة';
      case 1:
        return 'السلة';
      case 2:
        return 'VR';
      case 3:
        return 'الفنان';
      case 4:
        return 'مشاركة';
      default:
        return 'VR';
    }
  }

  Widget _buildControlButton(
    BuildContext context,
    IconData icon,
    IconData selectedIcon,
    String label,
    int index,
    VoidCallback onTap,
  ) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مساحة للدائرة
              SizedBox(height: isSelected ? 35 : 0),
              // الأيقونة (مخفية عند التحديد)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 0.0 : 1.0,
                child: Icon(
                  icon,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              // النص (مخفي عند التحديد)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 0.0 : 1.0,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 12,
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareArtwork(BuildContext context) {
    widget.vrProvider.shareArtwork();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم مشاركة العمل الفني: ${widget.vrProvider.currentArtwork.title}',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: 'موافق', onPressed: () {}),
      ),
    );
  }
}
