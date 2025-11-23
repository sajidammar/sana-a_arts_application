// views/components/categories_section.dart
import 'package:flutter/material.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SectionTitle(
            title: 'الفئات الفنية',
            description: 'استكشف مختلف المجالات الفنية واختر ما يناسب موهبتك',
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 120, // ✅ ارتفاع محدد
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return CategoryCard(category: _categories[index]);
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

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5E6D3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon, size: 40, color: const Color(0xFFB8860B)),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C1810),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
// في ملف مستقل أو في نفس الملف
class SectionTitle extends StatelessWidget {
  final String title;
  final String description;

  const SectionTitle({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFFB8860B),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF5D4E37),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
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