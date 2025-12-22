// views/components/horizontal_instructors_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/themes/academy/colors.dart';
import 'package:sanaa_artl/views/academies/components/instructor_card.dart';
import 'package:sanaa_artl/views/academies/components/section_title.dart';
import '../../providers/theme_provider.dart';

class HorizontalInstructorsSection extends StatelessWidget {
  const HorizontalInstructorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(32),
      color: AppColors.getCardColor(isDark),
      child: Consumer<WorkshopProvider>(
        builder: (context, workshopProvider, child) {
          if (workshopProvider.isLoading) {
            return SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.getPrimaryColor(isDark),
                  ),
                ),
              ),
            );
          }

          if (workshopProvider.instructors.isEmpty) {
            return SizedBox(
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
              SectionTitle(
                title: 'المدربون المتخصصون',
                description:
                    'تعرف على فريق المدربين الخبراء في مختلف مجالات الفنون',
                isDark: isDark,
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
                        right: index == workshopProvider.instructors.length - 1
                            ? 16
                            : 0,
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
