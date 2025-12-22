import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';

import 'package:sanaa_artl/themes/exhibition/colors.dart';
import 'package:sanaa_artl/utils/exhibition/constants.dart';
import 'vr_exhibition_page.dart';
import 'widgets/exhibition_card.dart';
import 'widgets/exhibition_filters.dart';
import '../home/widgets/hero_section.dart';
import '../home/widgets/exhibition_types_section.dart';
import '../home/widgets/current_exhibitions_section.dart';

class ExhibitionsPage extends StatefulWidget {
  const ExhibitionsPage({super.key});

  @override
  State<ExhibitionsPage> createState() => _ExhibitionsPageState();
}

class _ExhibitionsPageState extends State<ExhibitionsPage>
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
      context.read<ExhibitionProvider>().loadExhibitions();
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // الهيدر
          _buildAppBar(),

          // Hero Section
          SliverToBoxAdapter(
            child: HeroSection(
              animationController: _animationController,
              context: context,
            ),
          ),

          // Types Section
          SliverToBoxAdapter(
            child: ExhibitionTypesSection(
              animationController: _animationController,
            ),
          ),

          // Current Exhibitions
          SliverToBoxAdapter(
            child: CurrentExhibitionsSection(
              animationController: _animationController,
            ),
          ),

          // محتوى الصفحة (شبكة المعارض الكاملة مع الفلتر)
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.95),
      elevation: 2,
      pinned: true,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        title: Row(
          children: [
            Icon(Icons.art_track, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              'المعارض الفنية',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        centerTitle: false,
        background: Container(
          decoration: BoxDecoration(gradient: AppColors.goldGradient),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<ExhibitionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // أزرار التصفية
              ExhibitionFilters(animationController: _animationController),

              const SizedBox(height: 24),

              // شبكة المعارض
              _buildExhibitionsGrid(provider),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildExhibitionsGrid(ExhibitionProvider provider) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: provider.filteredExhibitions.length,
      itemBuilder: (context, index) {
        final exhibition = provider.filteredExhibitions[index];
        return ExhibitionCard(
          exhibition: exhibition,
          animationController: _animationController,
          animationDelay: Duration(milliseconds: 100 * index),
          onTap: () => _handleExhibitionTap(context, exhibition),
        );
      },
    );
  }

  void _handleExhibitionTap(BuildContext context, Exhibition exhibition) {
    if (exhibition.type == ExhibitionType.virtual) {
      _openVirtualExhibition(context);
    } else {
      _viewOpenExhibition(context, exhibition);
    }
  }

  void _openVirtualExhibition(BuildContext context) {
    final exhibitionProvider = Provider.of<ExhibitionProvider>(
      context,
      listen: false,
    );
    final vrProvider = Provider.of<VRProvider>(context, listen: false);

    vrProvider.loadArtworks(exhibitionProvider.artworks);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VRExhibitionPage()),
    );
  }

  void _viewOpenExhibition(BuildContext context, Exhibition exhibition) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'عرض ${exhibition.artworksCount} عمل فني في المعرض',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
      ),
    );
  }

  int _getCrossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
