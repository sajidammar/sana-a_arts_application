import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';

import 'widgets/hero_section.dart';
import 'widgets/current_exhibitions_section.dart';
import 'widgets/exhibition_fab_menu.dart';
import 'package:sanaa_artl/providers/user_provider.dart';

class ExhibitionHomePage extends StatefulWidget {
  const ExhibitionHomePage({super.key});

  @override
  State<ExhibitionHomePage> createState() => _ExhibitionHomePageState();
}

class _ExhibitionHomePageState extends State<ExhibitionHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      final userProvider = context.read<UserProvider>();
      final exhibitionProvider = context.read<ExhibitionProvider>();

      exhibitionProvider.loadExhibitions();
      if (userProvider.currentUser != null) {
        exhibitionProvider.checkUserExhibitions(userProvider.currentUser!.id);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: const ExhibitionFabMenu(),
      body: CustomScrollView(
        slivers: [
          // استبدال SliverPersistentHeader بـ SliverAppBar العادي
          // Header removed as per global layout update

          // قسم البطل (Hero)
          SliverToBoxAdapter(
            child: HeroSection(
              animationController: _animationController,
              context: context,
            ),
          ),

          // Exhibition Types Section Removed as per request (moved to FAB)

          // المعارض الحالية
          SliverToBoxAdapter(
            child: CurrentExhibitionsSection(
              animationController: _animationController,
            ),
          ),

          // الفوتر
          // const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}
