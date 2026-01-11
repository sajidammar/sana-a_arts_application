import 'package:sanaa_artl/core/errors/failures.dart';
import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/admin/data/admin_repository.dart';
import 'package:sanaa_artl/features/admin/models/admin_models.dart';
import 'package:sanaa_artl/features/admin/models/management_models.dart';
import 'package:sanaa_artl/features/admin/controllers/global_management_controller.dart';
import 'package:sanaa_artl/features/admin/controllers/academy_controller.dart';
import 'package:sanaa_artl/features/admin/controllers/store_controller.dart';

class AdminRepositoryImpl implements AdminRepository {
  final GlobalManagementController _globalController;
  final AcademyController _academyController;
  final StoreController _storeController;

  AdminRepositoryImpl({
    GlobalManagementController? globalController,
    AcademyController? academyController,
    StoreController? storeController,
  }) : _globalController = globalController ?? GlobalManagementController(),
       _academyController = academyController ?? AcademyController(),
       _storeController = storeController ?? StoreController();

  @override
  Future<Result<List<AdminRequest>>> getAllRequests() async {
    try {
      final data = await _globalController.getAllRequests();
      return Result.success(data.map((e) => AdminRequest.fromMap(e)).toList());
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch requests: $e'));
    }
  }

  @override
  Future<Result<void>> updateRequestStatus(String id, String status) async {
    try {
      await _globalController.updateRequestStatus(id, status);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        DatabaseFailure('Failed to update request status: $e'),
      );
    }
  }

  @override
  Future<Result<List<AdminReport>>> getAllReports() async {
    try {
      final data = await _globalController.getAllReports();
      return Result.success(data.map((e) => AdminReport.fromMap(e)).toList());
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch reports: $e'));
    }
  }

  @override
  Future<Result<void>> updateReportStatus(String id, String status) async {
    try {
      await _globalController.updateReportStatus(id, status);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        DatabaseFailure('Failed to update report status: $e'),
      );
    }
  }

  @override
  Future<Result<void>> deleteReportedContent(
    String targetId,
    String targetType,
  ) async {
    try {
      await _globalController.deleteTargetContent(targetId, targetType);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to delete content: $e'));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllUsers() async {
    try {
      final data = await _globalController.getAllUsers();
      return Result.success(data);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch users: $e'));
    }
  }

  @override
  Future<Result<void>> updateUserRole(String userId, String role) async {
    try {
      await _globalController.updateUserRole(userId, role);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to update user role: $e'));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllPosts() async {
    try {
      final data = await _globalController.getAllPosts();
      return Result.success(data);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch posts: $e'));
    }
  }

  @override
  Future<Result<void>> deletePost(String id) async {
    try {
      await _globalController.deletePost(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to delete post: $e'));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getAllExhibitions() async {
    try {
      final data = await _globalController.getAllExhibitions();
      return Result.success(data);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to fetch exhibitions: $e'));
    }
  }

  @override
  Future<Result<void>> toggleExhibitionStatus(String id, bool isActive) async {
    try {
      await _globalController.toggleExhibitionStatus(id, isActive);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        DatabaseFailure('Failed to update exhibition status: $e'),
      );
    }
  }

  // Academy & Store Proxies
  @override
  Future<Result<List<AcademyItem>>> getAcademyItems() async {
    try {
      final data = await _academyController.fetchData();
      return Result.success(data);
    } catch (e) {
      return Result.failure(
        DatabaseFailure('Failed to fetch academy items: $e'),
      );
    }
  }

  @override
  Future<Result<void>> addAcademyItem(String title, String instructor) async {
    try {
      await _academyController.addItem(title, instructor);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to add academy item: $e'));
    }
  }

  @override
  Future<Result<List<ManagementProduct>>> getStoreProducts() async {
    try {
      final data = await _storeController.fetchData();
      return Result.success(data);
    } catch (e) {
      return Result.failure(
        DatabaseFailure('Failed to fetch store products: $e'),
      );
    }
  }

  @override
  Future<Result<void>> addStoreProduct(
    String name,
    double price,
    int stock,
    String category,
  ) async {
    try {
      await _storeController.addProduct(name, price, stock, category);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to add store product: $e'));
    }
  }

  @override
  Future<Result<void>> deleteStoreProduct(int id) async {
    try {
      await _storeController.removeProduct(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        DatabaseFailure('Failed to delete store product: $e'),
      );
    }
  }
}
