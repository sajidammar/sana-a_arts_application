import 'package:flutter/material.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class NotificationUtils {
  static void showSuccessNotification(BuildContext context, String message) {
    _showNotification(context, message, Icons.check_circle, AppColors.success);
  }

  static void showErrorNotification(BuildContext context, String message) {
    _showNotification(context, message, Icons.error, AppColors.error);
  }

  static void showInfoNotification(BuildContext context, String message) {
    _showNotification(context, message, Icons.info, AppColors.info);
  }

  static void showWarningNotification(BuildContext context, String message) {
    _showNotification(context, message, Icons.warning, AppColors.warning);
  }

  static void _showNotification(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: Material(
              color: Theme.of(context).cardColor,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: Theme.of(context).iconTheme as Color),
                    const SizedBox(width: 12),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodySmall,
                      // style: const TextStyle(
                      //   color: Colors.white,
                      //   fontWeight: FontWeight.w500,
                      //   fontFamily: 'Tajawal',
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  static void showSnackBarNotification(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}


