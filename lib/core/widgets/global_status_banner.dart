import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/controllers/app_status_provider.dart';

class GlobalStatusBanner extends StatelessWidget {
  const GlobalStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStatusProvider>(
      builder: (context, statusProvider, child) {
        if (statusProvider.alerts.isEmpty) return const SizedBox.shrink();

        // عرض أحدث تنبيه في الأعلى
        final alert = statusProvider.alerts.last;

        Color bgColor;
        switch (alert.type) {
          case AlertType.error:
            bgColor = Colors.red[800]!;
            break;
          case AlertType.warning:
            bgColor = Colors.orange[800]!;
            break;
          case AlertType.info:
            bgColor = Colors.blue[800]!;
            break;
        }

        return Material(
          color: bgColor,
          child: InkWell(
            onTap: () {
              // يمكن إضافة منطق إغلاق أو تفاصيل هنا
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    alert.icon ?? Icons.info_outline,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      alert.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                    onPressed: () => statusProvider.removeAlert(alert.id),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
