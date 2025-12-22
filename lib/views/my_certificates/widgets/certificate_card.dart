import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/academy/colors.dart';
import '../certificate_enums.dart';

class CertificateCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const CertificateCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final surfaceColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final secondaryTextColor = AppColors.getSubtextColor(isDark);
    final primaryColor = AppColors.getPrimaryColor(isDark);
    final status = data['status'] as CertificateStatus;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header (Gradient)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: AppColors.learningGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data['isVerified'] == true)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF28a745),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 18,
                        ),
                      )
                    else
                      const SizedBox(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        data['type'] ?? 'شهادة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  data['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.white.withValues(alpha: 0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['institution'],
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Details
                _buildDetailRow(
                  'تاريخ الإنجاز:',
                  data['date'] ?? data['endDate'] ?? data['startDate'] ?? '-',
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  status == CertificateStatus.inProgress
                      ? 'التقدم:'
                      : 'المـدة:',
                  status == CertificateStatus.inProgress
                      ? '${(data['progress'] * 100).toInt()}%'
                      : data['duration'],
                  textColor,
                  secondaryTextColor,
                ),
                _buildDetailRow(
                  'المدرب:',
                  data['instructor'],
                  textColor,
                  secondaryTextColor,
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الحالة:',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                    _buildStatusBadge(status),
                  ],
                ),

                if (data['grade'] != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'الدرجة: ${data['grade']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],

                if (status == CertificateStatus.inProgress) ...[
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: data['progress'],
                      backgroundColor: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'التقدم الحالي: ${(data['progress'] * 100).toInt()}%',
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Actions
                Row(
                  children: _buildActions(
                    context,
                    status,
                    isDark,
                    primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: secondaryTextColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(CertificateStatus status) {
    Color color;
    String text;

    switch (status) {
      case CertificateStatus.completed:
        color = const Color(0xFF28a745);
        text = 'مكتملة';
        break;
      case CertificateStatus.inProgress:
        color = const Color(0xFFffc107);
        text = 'قيد التقدم';
        break;
      case CertificateStatus.pending:
        color = const Color(0xFF17a2b8);
        text = 'في الانتظار';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontFamily: 'Tajawal',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    CertificateStatus status,
    bool isDark,
    Color primaryColor,
  ) {
    List<Widget> actions = [];

    // Helper for buttons
    Widget buildBtn({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      bool isPrimary = false,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrimary
                  ? Colors.transparent
                  : (isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : const Color(0xFFF5E6D3).withValues(alpha: 0.5)),
              foregroundColor: isPrimary
                  ? Colors.white
                  : (isDark ? Colors.white : AppColors.textPrimary),
              elevation: isPrimary ? 2 : 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: isPrimary
                  ? primaryColor.withValues(alpha: 0.4)
                  : Colors.transparent,
            ),
            child: Ink(
              decoration: isPrimary
                  ? BoxDecoration(
                      gradient: AppColors.learningGradient,
                      borderRadius: BorderRadius.circular(12),
                    )
                  : null,
              child: Container(
                constraints: const BoxConstraints(minHeight: 45),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (status == CertificateStatus.completed) {
      actions.add(
        buildBtn(
          icon: Icons.download,
          label: 'تحميل',
          onTap: () => _handleDownload(context),
          isPrimary: true,
        ),
      );
      actions.add(
        buildBtn(
          icon: Icons.verified_user,
          label: 'التحقق',
          onTap: () => _showVerificationDialog(context, isDark),
        ),
      );
    } else if (status == CertificateStatus.inProgress) {
      actions.add(
        buildBtn(
          icon: Icons.play_arrow,
          label: 'متابعة',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('جاري الانتقال لصفحة الدورة...')),
            );
          },
          isPrimary: true,
        ),
      );
      actions.add(
        buildBtn(
          icon: Icons.bar_chart,
          label: 'التقدم',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('عرض تفاصيل التقدم...')),
            );
          },
        ),
      );
    } else {
      // Pending
      actions.add(
        buildBtn(
          icon: Icons.access_time,
          label: 'الحالة',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('الشهادة قيد المراجعة من قبل الإدارة'),
              ),
            );
          },
        ),
      );
      actions.add(
        buildBtn(
          icon: Icons.contact_support,
          label: 'الدعم',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('فتح تذكرة دعم فني...')),
            );
          },
        ),
      );
    }

    return actions;
  }

  void _handleDownload(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 15),
            Text('جاري تحميل الشهادة...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
    // Simulate completion
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF28a745),
            content: Text('تم تحميل الشهادة بنجاح!'),
          ),
        );
      }
    });
  }

  void _showVerificationDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.getCardColor(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF28a745),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'شهادة موثقة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextColor(isDark),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'هذه الشهادة معتمدة وموثقة من قبل منصة فنون صنعاء.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.getSubtextColor(isDark),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : AppColors.backgroundSecondary.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.getPrimaryColor(
                      isDark,
                    ).withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'رقم التحقق',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: AppColors.getSubtextColor(isDark),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'CERT-2024-FSA-001234',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB8860B),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getPrimaryColor(isDark),
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
