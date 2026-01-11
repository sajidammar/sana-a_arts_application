import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/admin/models/admin_models.dart';
import 'package:sanaa_artl/features/admin/models/management_models.dart';

abstract class AdminRepository {
  // Requests
  Future<Result<List<AdminRequest>>> getAllRequests();
  Future<Result<void>> updateRequestStatus(String id, String status);

  // Reports
  Future<Result<List<AdminReport>>> getAllReports();
  Future<Result<void>> updateReportStatus(String id, String status);
  Future<Result<void>> deleteReportedContent(
    String targetId,
    String targetType,
  );

  // Users
  Future<Result<List<Map<String, dynamic>>>>
  getAllUsers(); // Ideally return User model
  Future<Result<void>> updateUserRole(String userId, String role);

  // Content (Posts, Exhibitions)
  Future<Result<List<Map<String, dynamic>>>>
  getAllPosts(); // Ideally return Post model
  Future<Result<void>> deletePost(String id);
  Future<Result<List<Map<String, dynamic>>>>
  getAllExhibitions(); // Ideally return Exhibition model
  Future<Result<void>> toggleExhibitionStatus(String id, bool isActive);

  // Academy & Store (Proxying for now)
  Future<Result<List<AcademyItem>>> getAcademyItems();
  Future<Result<void>> addAcademyItem(String title, String instructor);

  Future<Result<List<ManagementProduct>>> getStoreProducts();
  Future<Result<void>> addStoreProduct(
    String name,
    double price,
    int stock,
    String category,
  );
  Future<Result<void>> deleteStoreProduct(int id);
}
