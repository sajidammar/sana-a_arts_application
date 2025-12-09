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
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Consumer<WorkshopProvider>(
        builder: (context, provider, child) {
          // In a real app, you might filter by categoryId here
          // For now, we'll just show all workshops or filter if the logic exists
          final workshops = provider.workshops;

          if (workshops.isEmpty) {
            return const Center(
              child: Text('لا توجد ورش متاحة في هذه الفئة حالياً'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workshops.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: WorkshopCard(
                  workshop: workshops[index],
                  isHorizontal: false, // Vertical layout
                ),
              );
            },
          );
        },
      ),
    );
  }
}
