// views/components/horizontal_instructors_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/views/academies/category_view.dart';
import 'package:sanaa_artl/views/academies/components/instructor_card.dart';

class HorizontalInstructorsSection extends StatelessWidget {
  const HorizontalInstructorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
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

          if (workshopProvider.instructors.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد بيانات للمدربين حالياً',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SectionTitle(
                title: 'المدربون المتخصصون',
                description: 'تعرف على فريق المدربين الخبراء في مختلف مجالات الفنون',
              ),
              const SizedBox(height: 32),
              
              // ✅ القائمة الأفقية للمدربين
              SizedBox(
                height: 280, // ارتفاع ثابت للقائمة الأفقية
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: workshopProvider.instructors.length,
                  itemBuilder: (context, index) {
                    final instructor = workshopProvider.instructors[index];
                    return Container(
                      width: 220, // عرض ثابت لكل عنصر
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 16,
                        right: index == workshopProvider.instructors.length - 1 ? 16 : 0,
                      ),
                      child: InstructorCard(
                        instructor: instructor,
                        isHorizontal: true, // ✅ إشارة للعرض الأفقي
                      ),
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