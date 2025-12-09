// views/home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/views/academies/category_view.dart';
import 'package:sanaa_artl/views/academies/components/workshops_grid.dart';
import 'package:sanaa_artl/views/academies/instructor_view.dart';
import 'components/hero_section.dart';
import 'components/quick_nav.dart';

class AcademyHomeView extends StatefulWidget {
  const AcademyHomeView({super.key});

  @override
  State<AcademyHomeView> createState() => _AcademyHomeViewState();
}

class _AcademyHomeViewState extends State<AcademyHomeView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      final workshopProvider = Provider.of<WorkshopProvider>(
        context,
        listen: false,
      );
      workshopProvider.loadSampleData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // Header
              // SliverAppBar(
              //   pinned: true,
              //   floating: false,
              //   snap: false,
              //   expandedHeight: 120,
              //   collapsedHeight: 120,
              //   toolbarHeight: 120,
              //   backgroundColor: Colors.white,
              //   elevation: 3,
              //   flexibleSpace: const AppHeader(),
              // ),

              // Hero Section
              const SliverToBoxAdapter(child: HeroSection()),

              // Quick Navigation
              const SliverToBoxAdapter(child: QuickNavigationSection()),

              // Categories Section
              const SliverToBoxAdapter(child: CategoriesSection()),

              // الورش المميزة (أفقية)
              const SliverToBoxAdapter(child: HorizontalWorkshopsGrid()),

              // ✅ جميع الورش التدريبية (أفقية جديدة)
              _buildAllWorkshopsSection(),

              // المدربون المتخصصون (أفقية)
              const SliverToBoxAdapter(child: HorizontalInstructorsSection()),

              // Footer
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ دالة جديدة للقائمة الأفقية لجميع الورش
  Widget _buildAllWorkshopsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(32),
        color: Theme.of(context).cardTheme.color,
        child: Consumer<WorkshopProvider>(
          builder: (context, workshopProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SectionTitle(
                  title: 'جميع الورش التدريبية',
                  description:
                      'اكتشف مجموعة متنوعة من الورش المصممة لتطوير مهاراتك الفنية',
                ),
                const SizedBox(height: 32),
                _buildFilterTabs(workshopProvider),
                const SizedBox(height: 32),
                const HorizontalWorkshopsGrid(), // ✅ استخدام المكون الجديد
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterTabs(WorkshopProvider workshopProvider) {
    final filters = [
      _FilterTab(label: 'الكل', value: 'all'),
      _FilterTab(label: 'مبتدئ', value: 'beginner'),
      _FilterTab(label: 'متوسط', value: 'intermediate'),
      _FilterTab(label: 'متقدم', value: 'advanced'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in filters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(filter.label),
                selected: workshopProvider.currentFilter == filter.value,
                onSelected: (selected) {
                  workshopProvider.setFilter(filter.value);
                },
                selectedColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  color: workshopProvider.currentFilter == filter.value
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterTab {
  final String label;
  final String value;

  const _FilterTab({required this.label, required this.value});
}
