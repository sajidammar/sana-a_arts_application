import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'dart:ui';
import 'package:sanaa_artl/views/exhibitions/requests/request_virtual_page.dart';
import 'package:sanaa_artl/views/exhibitions/requests/request_personal_page.dart';
import 'package:sanaa_artl/views/exhibitions/requests/request_group_page.dart';
import 'package:sanaa_artl/views/exhibitions/requests/request_open_page.dart';
import 'package:sanaa_artl/views/exhibitions/exhibitiontype/vr_exhibition_page.dart';

class ExhibitionFabMenu extends StatefulWidget {
  const ExhibitionFabMenu({super.key});

  @override
  State<ExhibitionFabMenu> createState() => _ExhibitionFabMenuState();
}

class _ExhibitionFabMenuState extends State<ExhibitionFabMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _controller.reverse();
      Navigator.of(context).pop(); // Perform pop to close overlay route
    } else {
      _controller.forward();
      Navigator.of(context).push(
        _ExhibitionMenuRoute(
          onClose: () {
            _controller.reverse();
            setState(() {
              _isOpen = false;
            });
          },
        ),
      );
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // We only render the main FAB here. The menu is an overlay route.
    return FloatingActionButton(
      onPressed: _toggleMenu,
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.museum_outlined, color: Colors.white),
    );
  }
}

class _ExhibitionMenuRoute extends ModalRoute<void> {
  final VoidCallback onClose;

  _ExhibitionMenuRoute({required this.onClose});

  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Close Menu';

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _ExhibitionMenuContent(onClose: onClose, animation: animation);
  }
}

class _ExhibitionMenuContent extends StatelessWidget {
  final VoidCallback onClose;
  final Animation<double> animation;

  const _ExhibitionMenuContent({
    required this.onClose,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    // Access provider to check ownership
    final provider = Provider.of<ExhibitionProvider>(context);

    return Stack(
      children: [
        // Backdrop tap handler
        GestureDetector(
          onTap: () {
            onClose();
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(color: Colors.transparent),
        ),

        // Menu Items
        Positioned(
          bottom: 80,
          right: 16,
          child: ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDynamicMenuItem(
                  context,
                  ExhibitionType.virtual,
                  Icons.card_membership_sharp,
                  'معرضي الافتراضي',
                  'طلب معرض افتراضي',
                  provider.hasExhibitionType(ExhibitionType.virtual),
                ),
                const SizedBox(height: 12),
                _buildDynamicMenuItem(
                  context,
                  ExhibitionType.personal,
                  Icons.person,
                  'معرضي الشخصي',
                  'طلب معرض شخصي',
                  provider.hasExhibitionType(ExhibitionType.personal),
                ),
                const SizedBox(height: 12),
                _buildDynamicMenuItem(
                  context,
                  ExhibitionType.open,
                  Icons.upload,
                  'مشاركتي المفتوحة',
                  'طلب مشاركة مفتوحة',
                  provider.hasExhibitionType(ExhibitionType.open),
                ),
                const SizedBox(height: 12),
                _buildDynamicMenuItem(
                  context,
                  ExhibitionType.group,
                  Icons.groups,
                  'مجموعتي',
                  'طلب انضمام لمجموعة',
                  provider.hasExhibitionType(ExhibitionType.group),
                ),
              ],
            ),
          ),
        ),

        // Close Button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              onClose();
              Navigator.of(context).pop();
            },
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 4,
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildDynamicMenuItem(
    BuildContext context,
    ExhibitionType type,
    IconData icon,
    String ownedLabel,
    String requestLabel,
    bool isOwned,
  ) {
    final String tooltipMessage = isOwned ? ownedLabel : requestLabel;

    return GestureDetector(
      onTap: () {
        onClose();
        Navigator.of(context).pop(); // Close menu
        _handleNavigation(context, type, isOwned);
      },
      child: Tooltip(
        message: tooltipMessage,
        preferBelow: false,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        textStyle: TextStyle(
          fontFamily: 'Tajawal',
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 12,
        ),
        child: Container(
          width: 56, // Standard FAB size
          height: 56,
          decoration: BoxDecoration(
            gradient: type.gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: type.color.withOpacity(0.4),
                offset: const Offset(0, 4),
              ),
            ],
            border: isOwned ? Border.all(color: Colors.white, width: 2) : null,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }

  void _handleNavigation(
    BuildContext context,
    ExhibitionType type,
    bool isOwned,
  ) {
    if (isOwned) {
      if (type == ExhibitionType.virtual) {
        // Navigate to VR viewing or simple detail page
        // For now, let's say VR page
        // We might need to load specific data first.
        // Simplified: Show snackbar or go to listing filtered by "My Exhibitions"?
        // User "Exhibitions itself appears".
        _showOwnedExhibition(context, type);
      } else {
        _showOwnedExhibition(context, type);
      }
    } else {
      // Navigate to Request Page
      Widget page;
      switch (type) {
        case ExhibitionType.virtual:
          page = const RequestVirtualPage();
          break;
        case ExhibitionType.personal:
          page = const RequestPersonalPage();
          break;
        case ExhibitionType.group:
          page = const RequestGroupPage();
          break;
        case ExhibitionType.open:
          page = const RequestOpenPage();
          break;
      }
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    }
  }

  void _showOwnedExhibition(BuildContext context, ExhibitionType type) {
    if (type == ExhibitionType.virtual) {
      // Provider logic to get works needed? VRExhibitionPage handles it?
      // ExhibitionsPage logic:
      // final exhibitionProvider = Provider.of<ExhibitionProvider>(context, listen: false);
      // final vrProvider = Provider.of<VRProvider>(context, listen: false);
      // vrProvider.loadArtworks(exhibitionProvider.artworks);
      // Navigator.push...

      // We need to import VRProvider if we use it, but for now let's just push the page
      // assuming the page handles its data or we just show it.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VRExhibitionPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("جاري فتح معرضك: ${type.displayName}")),
      );
    }
  }
}
