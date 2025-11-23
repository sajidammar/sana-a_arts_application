// views/components/horizontal_workshops_grid.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'workshop_card.dart';

class HorizontalWorkshopsGrid extends StatelessWidget {
  const HorizontalWorkshopsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkshopProvider>(
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

        return SizedBox(
          height: 320, // ارتفاع ثابت للقائمة الأفقية
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: workshopProvider.workshops.length,
            itemBuilder: (context, index) {
              final workshop = workshopProvider.workshops[index];
              return Container(
                width: 280, // عرض ثابت لكل عنصر
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 16,
                  right: index == workshopProvider.workshops.length - 1 ? 16 : 0,
                ),
                child: WorkshopCard(
                  workshop: workshop,
                  isHorizontal: true, // ✅ إشارة للعرض الأفقي
                ),
              );
            },
          ),
        );
      },
    );
  }
}