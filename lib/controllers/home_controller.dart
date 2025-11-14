import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {
  List<Map<String, dynamic>> _featuredExhibitions = [
    {
      'title': 'معرض التراث اليمني',
      'description': 'أجمل اللوحات المستوحاة من التراث اليمني الأصيل',
      'imageUrl': '',
    },
    {
      'title': 'فنون معاصرة',
      'description': 'أعمال فنية معاصرة تجمع بين الأصالة والحداثة',
      'imageUrl': '',
    },
    {
      'title': 'مناظر طبيعية',
      'description': 'استكشف جمال الطبيعة اليمنية عبر ريشة الفنانين',
      'imageUrl': '',
    },
    {
      'title': 'بورتريهات',
      'description': 'صور شخصية تعبر عن هوية المجتمع اليمني',
      'imageUrl': '',
    },
  ];

  bool _isLoading = false;

  List<Map<String, dynamic>> get featuredExhibitions => _featuredExhibitions;
  bool get isLoading => _isLoading;

  Future<void> loadFeaturedData() async {
    _isLoading = true;
    notifyListeners();

    // محاكاة جلب البيانات
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }
}