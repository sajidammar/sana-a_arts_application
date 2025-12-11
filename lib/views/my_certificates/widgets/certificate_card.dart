import 'package:flutter/material.dart';
import '../certificate_enums.dart'; // For CertificateStatus enum

class CertificateCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const CertificateCard({super.key, required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);
    final secondaryTextColor = isDark
        ? Colors.grey[400]!
        : const Color(0xFF5D4E37);
    final primaryColor = const Color(0xFFB8860B);
    final status = data['status'] as CertificateStatus;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(0.1),
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
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (data['isVerified'] == true)
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFF28a745),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    else
                      const SizedBox(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data['type'] ?? 'شهادة',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  data['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Tajawal',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data['institution'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                  ),
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

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الحالة:',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: Color(0xFF5D4E37),
                      ),
                    ),
                    _buildStatusBadge(status),
                  ],
                ),

                if (data['grade'] != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB8860B), Color(0xFFDAA520)],
                      ),
                      borderRadius: BorderRadius.circular(20),
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
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFFB8860B),
                      ),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'التقدم الحالي: ${(data['progress'] * 100).toInt()}%',
                    style: TextStyle(
                      color: primaryColor,
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Actions
                Row(children: _buildActions(context, status, isDark)),
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: secondaryTextColor,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: textColor,
              fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Tajawal',
          fontSize: 12,
        ),
      ),
    );
  }

  List<Widget> _buildActions(
    BuildContext context,
    CertificateStatus status,
    bool isDark,
  ) {
    List<Widget> actions = [];

    // Helper for buttons
    Widget buildBtn({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      bool isPrimary = false,
    }) {
      Color bg;
      Color fg;
      if (isPrimary) {
        bg = const Color(0xFF667eea);
        fg = Colors.white;
      } else {
        bg = isDark ? Colors.grey[800]! : const Color(0xFFF5E6D3);
        fg = isDark ? Colors.white : const Color(0xFF2C1810);
      }

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 14),
            label: Text(
              label,
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              elevation: isPrimary ? 2 : 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
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
          icon: Icons.verified,
          label: 'التحقق',
          onTap: () => _showVerificationDialog(context, isDark),
        ),
      );
      actions.add(
        buildBtn(
          icon: Icons.share,
          label: 'مشاركة',
          onTap: () => _showShareDialog(context, isDark),
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
          icon: Icons.email,
          label: 'المدرب',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('فتح نافذة المحادثة مع المدرب...')),
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
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                child: const Icon(Icons.shield, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 15),
              Text(
                'شهادة موثقة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2C1810),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'هذه الشهادة معتمدة وموثقة من قبل منصة فنون صنعاء.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: isDark ? Colors.grey[400] : const Color(0xFF5D4E37),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2C2C)
                      : const Color(0xFFF5E6D3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'رقم التحقق',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: isDark
                            ? Colors.grey[400]
                            : const Color(0xFF5D4E37),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'CERT-2024-FSA-001234',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB8860B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB8860B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'مشاركة الشهادة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2C1810),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ShareIconBtn(
                    Icons.facebook,
                    Colors.blue,
                    'Facebook',
                    () => _shareMock(context, 'Facebook'),
                  ),
                  _ShareIconBtn(
                    Icons.alternate_email,
                    Colors.lightBlue,
                    'Twitter',
                    () => _shareMock(context, 'Twitter'),
                  ),
                  _ShareIconBtn(
                    Icons.business_center,
                    Colors.blue[800]!,
                    'LinkedIn',
                    () => _shareMock(context, 'LinkedIn'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الرابط!')),
                  );
                },
                icon: const Icon(Icons.link),
                label: const Text(
                  'نسخ الرابط',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? Colors.white
                      : const Color(0xFFB8860B),
                  side: BorderSide(
                    color: isDark ? Colors.grey : const Color(0xFFB8860B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareMock(BuildContext context, String platform) {
    Navigator.pop(context); // Close dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت المشاركة عبر $platform بنجاح!')),
    );
  }
}

class _ShareIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ShareIconBtn(this.icon, this.color, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 25,
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
            ),
          ],
        ),
      ),
    );
  }
}
