import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/exhibitions/views/exhibitiontype/widgets/exhibition_card.dart';

class PopularExhibitionsSection extends StatelessWidget {
  final AnimationController animationController;

  const PopularExhibitionsSection({
    super.key,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ExhibitionProvider>(
      builder: (context, exhibitionProvider, child) {
        if (exhibitionProvider.isLoading) {
          return const SizedBox.shrink();
        }

        final popularExhibitions = exhibitionProvider.featuredExhibitions;

        if (popularExhibitions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'المعارض المشهورة',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: AppColors.getTextColor(
                          Provider.of<ThemeProvider>(context).isDarkMode,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 440,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularExhibitions.length,
                  itemBuilder: (context, index) {
                    final exhibition = popularExhibitions[index];
                    return Container(
                      width: 300,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 8,
                        right: index == popularExhibitions.length - 1 ? 16 : 8,
                        bottom: 8,
                      ),
                      child: ExhibitionCard(
                        exhibition: exhibition,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم اختيار: ${exhibition.title}'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


