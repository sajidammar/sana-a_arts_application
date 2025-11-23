// controllers/workshop_controller.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/academy/instructor.dart';
import 'package:sanaa_artl/models/academy/workshop.dart';

class WorkshopController with ChangeNotifier {
  List<Workshop> _workshops = [];
  List<Instructor> _instructors = [];
  String _currentFilter = 'all';
  String _searchQuery = '';

  List<Workshop> get workshops => _workshops;
  List<Instructor> get instructors => _instructors;
  String get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;

  List<Workshop> get filteredWorkshops {
    List<Workshop> filtered = _workshops;

    // Apply category filter
    if (_currentFilter != 'all') {
      filtered = filtered.where((workshop) => workshop.category == _currentFilter).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((workshop) =>
          workshop.title.toLowerCase().contains(query) ||
          workshop.description.toLowerCase().contains(query) ||
          workshop.instructor.toLowerCase().contains(query) ||
          workshop.tags.any((tag) => tag.toLowerCase().contains(query))).toList();
    }

    return filtered;
  }

  Workshop? getWorkshopById(int id) {
    try {
      return _workshops.firstWhere((workshop) => workshop.id == id);
    } catch (e) {
      return null;
    }
  }

  Instructor? getInstructorById(String id) {
    try {
      return _instructors.firstWhere((instructor) => instructor.id == id);
    } catch (e) {
      return null;
    }
  }

  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void loadSampleData() {
    // Load workshops
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
        requirements: [
          "لا يتطلب خبرة سابقة",
          "الرغبة في التعلم والممارسة",
          "الالتزام بحضور الجلسات"
        ],
        learningOutcomes: [
          "إتقان أساسيات الرسم والخطوط",
          "فهم قواعد الضوء والظل",
          "رسم الأشكال الهندسية البسيطة",
          "رسم الطبيعة الصامتة"
        ],
      ),
      // Add other workshops similarly...
    ];

    // Load instructors
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
        bio: "فنان تشكيلي محترف بخبرة تزيد عن 15 عاماً في مجال الفنون التشكيلية. متخصص في تدريس أساسيات الرسم والألوان المائية والزيتية.",
        education: [
          "دبلوم الفنون الجميلة - جامعة صنعاء",
          "دورات تخصصية في الرسم الأكاديمي"
        ],
        achievements: [
          "مشارك في 20+ معرض محلي وإقليمي",
          "حائز على جائزة أفضل مدرب فنون 2023",
          "مدرب معتمد من اتحاد الفنانين العرب"
        ], imageUrl: '',
      ),
      // Add other instructors similarly...
    ];

    notifyListeners();
  }
}