// views/components/categories_section.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/academies/views/category_details_view.dart';
import 'package:sanaa_artl/features/academies/views/components/section_title.dart';

import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(32),
      color: AppColors.getCardColor(isDark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionTitle(
            title: 'الفئات الفنية',
            description: 'استكشف مختلف المجالات الفنية واختر ما يناسب موهبتك',
            isDark: isDark,
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 120, // ✅ ارتفاع محدد
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(
                  category: _categories[index],
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isDark;

  const CategoryCard({super.key, required this.category, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsView(
              categoryName: category.name,
              categoryId: category.name, // Using name as ID for demo
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.getCardColor(isDark),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 40,
              color: AppColors.getPrimaryColor(isDark),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextColor(isDark),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// في ملف مستقل أو في نفس الملف
// SectionTitle class moved to components/section_title.dart

class Category {
  final String name;
  final IconData icon;

  const Category({required this.name, required this.icon});
}

final List<Category> _categories = [
  const Category(name: 'الرسم', icon: Icons.brush),
  const Category(name: 'النحت', icon: Icons.architecture),
  const Category(name: 'التصوير', icon: Icons.camera_alt),
  const Category(name: 'الفخار', icon: Icons.celebration),
  const Category(name: 'الخط', icon: Icons.text_fields),
  const Category(name: 'التصميم', icon: Icons.design_services),
];




