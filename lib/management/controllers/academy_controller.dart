import '../models/management_models.dart';
import 'package:sanaa_artl/management/utils/database_helper.dart';

class AcademyController {
  final ManagementDatabaseHelper _dbHelper = ManagementDatabaseHelper();

  Future<List<AcademyItem>> fetchData() async {
    return await _dbHelper.getAllAcademyItems();
  }

  Future<void> addItem(String title, String instructor) async {
    final newItem = AcademyItem(
      title: title,
      instructor: instructor,
      status: 'قيد الانتظار',
      dateAdded: DateTime.now().toString().split(' ')[0],
    );
    await _dbHelper.insertAcademyItem(newItem);
  }
}



