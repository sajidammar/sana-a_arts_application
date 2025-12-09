// providers/workshop_provider.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/academy/instructor.dart';
import 'package:sanaa_artl/models/academy/workshop.dart';

class WorkshopProvider with ChangeNotifier {
  List<Workshop> _workshops = [];
  List<Instructor> _instructors = [];
  String _currentFilter = 'all';
  bool _isLoading = false;

  List<Workshop> get workshops => _workshops;
  List<Instructor> get instructors => _instructors;
  String get currentFilter => _currentFilter;
  bool get isLoading => _isLoading;

  get filteredWorkshops => null;

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  Future<void> loadSampleData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _workshops = [
      Workshop(
        id: 1,
        title: "أساسيات الرسم التشكيلي",
        category: "painting",
        instructor: "أحمد السباعي",
        instructorId: "ahmed_sabbai",
        description: "تعلم الأساسيات الصحيحة للرسم التشكيلي من الصفر",
        duration: 20,
        price: 15000,
        originalPrice: 20000,
        seats: 20,
        enrolled: 15,
        startDate: "2025-09-01",
        endDate: "2025-09-30",
        schedule: "الأحد والثلاثاء - 4:00-6:00 مساءً",
        location: "قاعة الفنون الرئيسية",
        level: "مبتدئ",
        language: "العربية",
        materials: "متوفرة",
        certificate: true,
        rating: 4.9,
        reviews: 124,
        featured: true,
        tags: ["رسم", "أساسيات", "فن تشكيلي"],
        requirements: ["لا يتطلب خبرة سابقة"],
        learningOutcomes: ["إتقان أساسيات الرسم والخطوط"],
        image: 'assets/images/image4.jpg',
      ),
    ];

    _instructors = [
      Instructor(
        id: "ahmed_sabbai",
        name: "أحمد محمد السباعي",
        title: "مدرب فنون تشكيلية معتمد",
        avatar: "👨‍🎨",
        experience: 15,
        specialties: ["الرسم التشكيلي", "الألوان المائية", "البورتريه"],
        rating: 4.9,
        reviews: 124,
        students: 250,
        workshops: 15,
        status: "available",
        bio: "فنان تشكيلي محترف بخبرة تزيد عن 15 عاماً",
        education: ["دبلوم الفنون الجميلة - جامعة صنعاء"],
        achievements: ["مشارك في 20+ معرض محلي وإقليمي"],
        imageUrl:
            'https://images.unsplash.com/photo-1541961017774-22349e4a1262?ixlib=rb-4.0.3&w=400',
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registerForWorkshop(int i, Map<String, String> map) async {}
}
