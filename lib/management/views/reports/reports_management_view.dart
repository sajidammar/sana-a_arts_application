import 'package:flutter/material.dart';
import '../../controllers/global_management_controller.dart';
import '../../themes/management_colors.dart';

class ReportsManagementView extends StatefulWidget {
  final bool isDark;
  const ReportsManagementView({super.key, required this.isDark});

  @override
  State<ReportsManagementView> createState() => _ReportsManagementViewState();
}

class _ReportsManagementViewState extends State<ReportsManagementView> {
  final GlobalManagementController _controller = GlobalManagementController();
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    // For now, we use comments as a proxy for reports or we could fetch from a reports table if it existed.
    // Given the project structure, we might have a Flag/Report system soon.
    final data = await _controller.getAllComments();
    setState(() {
      _reports = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إدارة البلاغات والتعليقات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ManagementColors.getText(widget.isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _reports.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد بلاغات حالياً',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _reports.length,
                            itemBuilder: (context, index) {
                              final report = _reports[index];
                              return Card(
                                color: ManagementColors.getCard(widget.isDark),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.report_problem,
                                    color: Colors.orange,
                                  ),
                                  title: Text(
                                    report['comment'] ?? 'تعليق غير لائق',
                                    style: TextStyle(
                                      color: ManagementColors.getText(
                                        widget.isDark,
                                      ),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  subtitle: Text(
                                    'المستخدم: ${report['user_name'] ?? 'مجهول'}',
                                    style: const TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
