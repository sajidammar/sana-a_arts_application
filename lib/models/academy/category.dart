// models/category.dart
class Category {
  final String id;
  final String name;
  final String icon;
  final String color;
  final int workshopCount;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.workshopCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      workshopCount: json['workshopCount'],
    );
  }
}