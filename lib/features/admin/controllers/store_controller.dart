import '../models/management_models.dart';
import 'package:sanaa_artl/features/admin/utils/database_helper.dart';

class StoreController {
  final ManagementDatabaseHelper _dbHelper = ManagementDatabaseHelper();

  Future<List<ManagementProduct>> fetchData() async {
    return await _dbHelper.getAllStoreProducts();
  }

  Future<void> addProduct(
    String name,
    double price,
    int stock,
    String category,
  ) async {
    final newProduct = ManagementProduct(
      productName: name,
      price: price,
      stock: stock,
      category: category,
    );
    await _dbHelper.insertStoreProduct(newProduct);
  }

  Future<void> removeProduct(int id) async {
    await _dbHelper.deleteProduct(id);
  }
}



