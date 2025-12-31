import 'package:flutter/material.dart';
import '../controllers/academy_controller.dart';
import '../controllers/store_controller.dart';
import '../controllers/global_management_controller.dart';
import '../models/management_models.dart';

class AdminProvider with ChangeNotifier {
  final AcademyController _academyController = AcademyController();
  final StoreController _storeController = StoreController();
  final GlobalManagementController _globalController =
      GlobalManagementController();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  int _currentDashboardIndex = 0;
  int get currentDashboardIndex => _currentDashboardIndex;

  // Data Lists
  List<AcademyItem> _academyItems = [];
  List<AcademyItem> get academyItems => _academyItems;

  List<ManagementProduct> _storeProducts = [];
  List<ManagementProduct> get storeProducts => _storeProducts;

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> get users => _users;

  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> get posts => _posts;

  List<Map<String, dynamic>> _reports = [];
  List<Map<String, dynamic>> get reports => _reports;

  List<Map<String, dynamic>> _exhibitions = [];
  List<Map<String, dynamic>> get exhibitions => _exhibitions;

  List<Map<String, dynamic>> _adminRequests = [];
  List<Map<String, dynamic>> get adminRequests => _adminRequests;

  List<Map<String, dynamic>> _adminReports = [];
  List<Map<String, dynamic>> get adminReports => _adminReports;

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
    } else if (_currentDashboardIndex == 2) {
      _exhibitions = await _globalController.getAllExhibitions();
    } else if (_currentDashboardIndex == 3) {
      _storeProducts = await _storeController.fetchData();
    } else if (_currentDashboardIndex == 4) {
      _users = await _globalController.getAllUsers();
    } else if (_currentDashboardIndex == 6) {
      _posts = await _globalController.getAllPosts();
    } else if (_currentDashboardIndex == 7) {
      _adminReports = await _globalController.getAllReports();
    } else if (_currentDashboardIndex == 8) {
      _adminRequests = await _globalController.getAllRequests();
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

  Future<void> deletePost(String id) async {
    await _globalController.deletePost(id);
    await _refreshData();
  }

  Future<void> updateUserRole(String userId, String role) async {
    await _globalController.updateUserRole(userId, role);
    await _refreshData();
  }

  Future<void> toggleExhibitionStatus(String id, bool isActive) async {
    await _globalController.toggleExhibitionStatus(id, isActive);
    await _refreshData();
  }

  Future<void> sendNotification(String title, String message) async {
    await _globalController.sendGlobalNotification(title, message);
  }

  // Reports & Moderation Actions
  Future<void> updateReportStatus(String id, String status) async {
    await _globalController.updateReportStatus(id, status);
    await _refreshData();
  }

  Future<void> deleteReportedContent(
    String reportId,
    String targetId,
    String targetType,
  ) async {
    await _globalController.deleteTargetContent(targetId, targetType);
    await _globalController.updateReportStatus(reportId, 'resolved');
    await _refreshData();
  }

  // Requests Actions
  Future<void> updateRequestStatus(String id, String status) async {
    await _globalController.updateRequestStatus(id, status);
    await _refreshData();
  }
}
