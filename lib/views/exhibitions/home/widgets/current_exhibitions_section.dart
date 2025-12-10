import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/views/exhibitions/exhibitiontype/widgets/exhibition_card.dart';

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
                const Text('لا توجد معارض حالية'),
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
                    color: Theme.of(context).textTheme.titleLarge?.color,
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
