// views/exhibitions/home/widgets/current_exhibitions_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/exhibition/exhibition.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';

class CurrentExhibitionsSection extends StatefulWidget {
  const CurrentExhibitionsSection({super.key, required AnimationController animationController});

  @override
  State<CurrentExhibitionsSection> createState() => _CurrentExhibitionsSectionState();
}

class _CurrentExhibitionsSectionState extends State<CurrentExhibitionsSection> {
  @override
  void initState() {
    super.initState();
    // ✅ تحميل البيانات بعد delay بسيط للتأكد من وجود الـ Provider
    Future.delayed(const Duration(milliseconds: 100), () {
      final provider = Provider.of<ExhibitionProvider>(context, listen: false);
      provider.loadExhibitions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExhibitionProvider>(
      builder: (context, exhibitionProvider, child) {
        if (exhibitionProvider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final currentExhibitions = exhibitionProvider.currentExhibitions;

        if (!currentExhibitions.isEmpty) {
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
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'المعارض الحالية',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentExhibitions.length,
                  itemBuilder: (context, index) {
                    final exhibition = currentExhibitions[index];
                    return Container(
                      width: 280,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 16,
                        right: index == currentExhibitions.length - 1 ? 0 : 16,
                      ),
                      child: ExhibitionCard(exhibition: exhibition),
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

class ExhibitionCard extends StatelessWidget {
  final Exhibition exhibition;

  const ExhibitionCard({super.key, required this.exhibition});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المعرض
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(exhibition.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // معلومات المعرض
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exhibition.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  exhibition.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        exhibition.location,
                        style: const TextStyle(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      exhibition.dateRange,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}