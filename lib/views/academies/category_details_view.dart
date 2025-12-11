import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/views/academies/components/workshop_card.dart';

class CategoryDetailsView extends StatelessWidget {
  final String categoryName;
  final String
  categoryId; // You might want to map names to IDs or use IDs directly

  const CategoryDetailsView({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(categoryName),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            pinned: true,
            floating: true,
          ),
          Consumer<WorkshopProvider>(
            builder: (context, provider, child) {
              final workshops = provider.workshops;

              if (workshops.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'لا توجد ورش متاحة في هذه الفئة حالياً',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: WorkshopCard(
                        workshop: workshops[index],
                        isHorizontal: false, // Vertical layout
                      ),
                    );
                  }, childCount: workshops.length),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
