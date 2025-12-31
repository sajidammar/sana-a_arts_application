import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class RequestsManagementView extends StatefulWidget {
  final bool isDark;
  const RequestsManagementView({super.key, required this.isDark});

  @override
  State<RequestsManagementView> createState() => _RequestsManagementViewState();
}

class _RequestsManagementViewState extends State<RequestsManagementView> {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final requests = adminProvider.adminRequests;

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
                    'إدارة الطلبات',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'مراجعة طلبات الانضمام للمعارض والورش والدورات التدريبية',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.getSubtextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: requests.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد طلبات معلقة حالياً',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: AppColors.getSubtextColor(isDark),
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: requests.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final request = requests[index];
                              return _buildRequestCard(
                                request,
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

  Widget _buildRequestCard(
    Map<String, dynamic> request,
    bool isDark,
    AdminProvider provider,
  ) {
    final status = request['status'] ?? 'pending';
    final type = request['request_type'] ?? 'unknown';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getRequestIcon(type),
            color: AppColors.getPrimaryColor(isDark),
            size: 24,
          ),
        ),
        title: Text(
          _getRequestTitleAr(type),
          style: TextStyle(
            color: AppColors.getTextColor(isDark),
            fontWeight: FontWeight.bold,
            fontFamily: 'Tajawal',
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'من المستخدم: ${request['requester_id']}',
              style: TextStyle(
                color: AppColors.getSubtextColor(isDark),
                fontFamily: 'Tajawal',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getStatusTextAr(status),
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ],
        ),
        trailing: status == 'pending'
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.green),
                    onPressed: () =>
                        provider.updateRequestStatus(request['id'], 'approved'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () =>
                        provider.updateRequestStatus(request['id'], 'rejected'),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  IconData _getRequestIcon(String type) {
    switch (type) {
      case 'exhibition':
        return Icons.photo_library;
      case 'workshop':
        return Icons.architecture;
      case 'course':
        return Icons.school;
      default:
        return Icons.assignment;
    }
  }

  String _getRequestTitleAr(String type) {
    switch (type) {
      case 'exhibition':
        return 'طلب اعتماد معرض';
      case 'workshop':
        return 'طلب إنشاء ورشة عمل';
      case 'course':
        return 'طلب تقديم دورة';
      default:
        return 'طلب إداري';
    }
  }

  String _getStatusTextAr(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'تمت الموافقة';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
