import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/utils/exhibition/animations.dart';

class ExhibitionFilters extends StatelessWidget {
  final AnimationController animationController;

  const ExhibitionFilters({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExhibitionProvider>(
      builder: (context, provider, child) {
        return SlideInAnimation(
          delay: const Duration(milliseconds: 400),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تصفية المعارض',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildFilterChip(
                      'جميع المعارض',
                      ExhibitionType.virtual,
                      provider,
                      context,
                    ),
                    _buildFilterChip(
                      'افتراضي',
                      ExhibitionType.virtual,
                      provider,
                      context,
                    ),
                    _buildFilterChip(
                      'مفتوح',
                      ExhibitionType.open,
                      provider,
                      context,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    String label,
    ExhibitionType type,
    ExhibitionProvider provider,
    BuildContext context,
  ) {
    final isSelected =
        provider.currentFilter == type ||
        (label == 'جميع المعارض' &&
            provider.currentFilter == ExhibitionType.virtual);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w500,
          fontFamily: 'Tajawal',
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (label == 'جميع المعارض') {
          provider.setFilter(ExhibitionType.virtual);
        } else {
          provider.setFilter(type);
        }
      },
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      selectedColor: Theme.of(context).primaryColor,
      checkmarkColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color:
              isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
