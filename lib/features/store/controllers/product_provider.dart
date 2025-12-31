import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/store/models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  int _selectedFilter = 0;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  int get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  final List<String> _filters = [
    'جميع الأعمال',
    'لوحات',
    'منحوتات',
    'فن رقمي',
    'تخفيضات',
    'جديد',
  ];

  List<String> get filters => _filters;

  void loadProducts() {
    _products = [
      Product(
        id: 1,
        title: "صنعاء العتيقة",
        artist: "أحمد المقطري",
        category: "لوحة زيتية",
        price: 680,
        originalPrice: 850,
        discount: 20,
        rating: 4.8,
        reviews: 24,
        description: "لوحة زيتية تجسد جمال العمارة التراثية في صنعاء القديمة",
        size: "70x100 سم",
        year: "2024",
        medium: "ألوان زيتية على كانفاس",
        isNew: true,
        inStock: true,
        image: 'assets/images/image1.jpg',
      ),
      Product(
        id: 2,
        title: "وجه يمني تراثي",
        artist: "فاطمة الحضرمي",
        category: "بورتريه",
        price: 620,
        originalPrice: 620,
        discount: 0,
        rating: 4.9,
        reviews: 18,
        description:
            "بورتريه لامرأة يمنية بالزي التراثي مرسوم بالألوان المائية",
        size: "50x70 سم",
        year: "2024",
        medium: "ألوان مائية",
        isNew: false,
        inStock: true,
        image: 'assets/images/image2.jpg',
      ),
      Product(
        id: 3,
        title: "منحوتة جبال اليمن",
        artist: "سالم المقطري",
        category: "منحوتة",
        price: 960,
        originalPrice: 1200,
        discount: 20,
        rating: 4.7,
        reviews: 12,
        description: "منحوتة من الحجر الطبيعي تمثل قمم الجبال اليمنية",
        size: "40x30x25 سم",
        year: "2023",
        medium: "حجر طبيعي",
        isNew: false,
        inStock: true,
        image: 'assets/images/image3.jpg',
      ),
    ];
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterProducts(int index) {
    _selectedFilter = index;
    _applyFilters();
  }

  void _applyFilters() {
    List<Product> temp = [];
    if (_selectedFilter == 0) {
      temp = _products;
    } else {
      temp = _products.where((product) {
        switch (_selectedFilter) {
          case 1:
            return product.category.contains('لوحة');
          case 2:
            return product.category.contains('منحوتة');
          case 3:
            return product.category.contains('رقمي');
          case 4:
            return product.discount > 0;
          case 5:
            return product.isNew;
          default:
            return true;
        }
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      temp = temp
          .where(
            (p) =>
                p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.artist.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    _filteredProducts = temp;
    notifyListeners();
  }
}


