import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/exhibitions/views/exhibitiontype/widgets/exhibition_card.dart';

class CurrentExhibitionsSection extends StatefulWidget {
  final AnimationController animationController;

  const CurrentExhibitionsSection({
    super.key,
    required this.animationController,
  });

  @override
  State<CurrentExhibitionsSection> createState() =>
      _CurrentExhibitionsSectionState();
}

class _CurrentExhibitionsSectionState extends State<CurrentExhibitionsSection> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        final provider = Provider.of<ExhibitionProvider>(
          context,
          listen: false,
        );
        provider.loadExhibitions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExhibitionProvider>(
      builder: (context, exhibitionProvider, child) {
        if (exhibitionProvider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final currentExhibitions = exhibitionProvider.currentExhibitions;
        final allExhibitions = exhibitionProvider.exhibitions;

        // // Debug logging
        // debugPrint(
        //   '🎨 CurrentExhibitionsSection - Total: ${allExhibitions.length}, Current: ${currentExhibitions.length}',
        // );

        if (currentExhibitions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Text(
                  'المعارض الحالية',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text('لا توجد معارض نشطة حاليًا'),
                const SizedBox(height: 8),
                Text(
                  'إجمالي المعارض: ${allExhibitions.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await exhibitionProvider.forceRegenerateExhibitions();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('تحديث البيانات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getPrimaryColor(
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).isDarkMode,
                    ),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'المعارض الحالية',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.getTextColor(
                      Provider.of<ThemeProvider>(context).isDarkMode,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height:
                    440, // Increased height further to prevent pixel overflow
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentExhibitions.length,
                  itemBuilder: (context, index) {
                    final exhibition = currentExhibitions[index];
                    return Container(
                      width: 300,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 16 : 8,
                        right: index == currentExhibitions.length - 1 ? 16 : 8,
                        bottom: 8,
                      ),
                      child: ExhibitionCard(
                        exhibition: exhibition,
                        // Can pass regular onTap here if needed
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
