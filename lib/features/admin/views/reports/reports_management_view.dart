import 'package:flutter/material.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:provider/provider.dart';

class ReportsManagementView extends StatefulWidget {
  final bool isDark;
  const ReportsManagementView({super.key, required this.isDark});

  @override
  State<ReportsManagementView> createState() => _ReportsManagementViewState();
}

class _ReportsManagementViewState extends State<ReportsManagementView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    // Filter reports based on search query
    final reports = adminProvider.adminReports.where((report) {
      final reason = (report['reason'] as String? ?? '').toLowerCase();
      final targetType = (report['target_type'] as String? ?? '').toLowerCase();
      return reason.contains(_searchQuery.toLowerCase()) ||
          targetType.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: adminProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.getPrimaryColor(isDark),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مركز الرقابة والتحري',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'التحري عن البلاغات واتخاذ إجراءات حيال المحتوى المسيء',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getSubtextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSearchBar(isDark),
                  const SizedBox(height: 25),
                  Expanded(
                    child: reports.isEmpty
                        ? Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? 'لا توجد بلاغات حالياً'
                                  : 'لا توجد نتائج تطابق بحثك',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: AppColors.getSubtextColor(isDark),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: reports.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final report = reports[index];
                              return _buildReportCard(
                                report,
                                isDark,
                                adminProvider,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _searchQuery = value),
      style: TextStyle(
        color: AppColors.getTextColor(isDark),
        fontFamily: 'Tajawal',
      ),
      decoration: InputDecoration(
        hintText: 'البحث في البلاغات أو أنواع المحتوى...',
        hintStyle: TextStyle(
          color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.6),
          fontSize: 13,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.getPrimaryColor(isDark),
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.getCardColor(isDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }

  Widget _buildReportCard(
    Map<String, dynamic> report,
    bool isDark,
    AdminProvider provider,
  ) {
    final status = report['status'] ?? 'pending';
    final targetType = report['target_type'] ?? 'unknown';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: status == 'pending'
              ? Colors.red.withValues(alpha: 0.2)
              : AppColors.getPrimaryColor(isDark).withValues(alpha: 0.05),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getReportTypeColor(targetType).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getReportTypeIcon(targetType),
            color: _getReportTypeColor(targetType),
            size: 22,
          ),
        ),
        title: Text(
          report['reason'] ?? 'سبب غير محدد',
          style: TextStyle(
            color: AppColors.getTextColor(isDark),
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'النوع: ${_getTargetTypeTextAr(targetType)} | الحالة: ${_getStatusTextAr(status)}',
          style: TextStyle(
            color: AppColors.getSubtextColor(isDark),
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Text(
                  'تفاصيل التحري:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: AppColors.getTextColor(isDark),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'معرف المحتوى المستهدف: ${report['target_id']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getSubtextColor(isDark),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (status == 'pending') ...[
                      TextButton.icon(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text(
                          'حذف المحتوى وتصفية البلاغ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        onPressed: () => _confirmAction(
                          context,
                          'هل أنت متأكد من حذف هذا المحتوى نهائياً؟',
                          () {
                            provider.deleteReportedContent(
                              report['id'],
                              report['target_id'],
                              targetType,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(
                          Icons.done_all,
                          color: Colors.green,
                          size: 18,
                        ),
                        label: const Text(
                          'تجاهل البلاغ',
                          style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        onPressed: () => provider.updateReportStatus(
                          report['id'],
                          'dismissed',
                        ),
                      ),
                    ] else
                      Text(
                        'تمت المعالجة: ${_getStatusTextAr(status)}',
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAction(
    BuildContext context,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'تأكيد الإجراء',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text(
              'تأكيد',
              style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getReportTypeIcon(String type) {
    switch (type) {
      case 'post':
        return Icons.article;
      case 'comment':
        return Icons.comment;
      case 'reel':
        return Icons.video_library;
      default:
        return Icons.report;
    }
  }

  Color _getReportTypeColor(String type) {
    switch (type) {
      case 'post':
        return Colors.blue;
      case 'comment':
        return Colors.orange;
      case 'reel':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getTargetTypeTextAr(String type) {
    switch (type) {
      case 'post':
        return 'منشور مجتمعي';
      case 'comment':
        return 'تعليق';
      case 'reel':
        return 'فيديو (ريلز)';
      default:
        return 'محتوى غير معروف';
    }
  }

  String _getStatusTextAr(String status) {
    switch (status) {
      case 'pending':
        return 'قيد المراجعة';
      case 'resolved':
        return 'تم الحذف';
      case 'dismissed':
        return 'تم التجاهل';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.red;
      case 'resolved':
        return Colors.green;
      case 'dismissed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
