// views/components/featured_workshop.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/academies/controllers/workshop_provider.dart';
import 'package:sanaa_artl/features/academies/views/components/section_title.dart';
import 'workshop_card.dart';

class FeaturedWorkshopSection extends StatelessWidget {
  const FeaturedWorkshopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: const Color(0xFFF5E6D3),
      child: Consumer<WorkshopProvider>(
        builder: (context, workshopProvider, child) {
          if (workshopProvider.isLoading) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB8860B)),
                ),
              ),
            );
          }

          if (workshopProvider.workshops.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد ورش متاحة حالياً',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          // الحصول على الورشة المميزة (أول ورشة في القائمة)
          final featuredWorkshops = workshopProvider.workshops.take(3).toList();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SectionTitle(
                title: 'الورشة المميزة',
                description: 'اكتشف الورشة الأكثر تميزاً هذا الأسبوع',
              ),
              const SizedBox(height: 32),
              // ✅ الحل: ListView أفقي مع ارتفاع محدد
              SizedBox(
                height: 240, // ارتفاع محدد
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: featuredWorkshops.length,
                  itemBuilder: (context, index) {
                    final workshop = featuredWorkshops[index];
                    return Container(
                      width: 300, // عرض كل عنصر
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 16,
                        right: index == featuredWorkshops.length - 1 ? 0 : 16,
                      ),
                      child: WorkshopCard(workshop: workshop),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


