import 'package:flutter/material.dart';
import '../controllers/academy_controller.dart';
import '../controllers/store_controller.dart';
import '../models/management_models.dart';

class ManagementProvider with ChangeNotifier {
  final AcademyController _academyController = AcademyController();
  final StoreController _storeController = StoreController();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  int _currentDashboardIndex = 0;
  int get currentDashboardIndex => _currentDashboardIndex;

  // Data Lists
  List<AcademyItem> _academyItems = [];
  List<AcademyItem> get academyItems => _academyItems;

  List<ManagementProduct> _storeProducts = [];
  List<ManagementProduct> get storeProducts => _storeProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDashboardIndex(int index) {
    _currentDashboardIndex = index;
    _refreshData();
    notifyListeners();
  }

  Future<void> _refreshData() async {
    _isLoading = true;
    notifyListeners();

    if (_currentDashboardIndex == 1) {
      _academyItems = await _academyController.fetchData();
    } else if (_currentDashboardIndex == 3) {
      _storeProducts = await _storeController.fetchData();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Actions
  Future<void> addAcademyItem(String title, String instructor) async {
    await _academyController.addItem(title, instructor);
    await _refreshData();
  }

  Future<void> addStoreProduct(
    String name,
    double price,
    int stock,
    String category,
  ) async {
    await _storeController.addProduct(name, price, stock, category);
    await _refreshData();
  }

  Future<void> deleteProduct(int id) async {
    await _storeController.removeProduct(id);
    await _refreshData();
  }
}

