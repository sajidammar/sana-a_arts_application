// utils/config.dart
import 'package:flutter/material.dart';

class WorkshopConfig {
  static const Map<String, dynamic> categories = {
    'painting': {
      'name': 'الرسم والتصوير',
      'icon': '🎨',
      'color': '#FF6B35',
    },
    'sculpture': {
      'name': 'النحت والتشكيل',
      'icon': '🗿',
      'color': '#8B4513',
    },
    'calligraphy': {
      'name': 'الخط العربي',
      'icon': '✍️',
      'color': '#B8860B',
    },
    'digital': {
      'name': 'الفن الرقمي',
      'icon': '💻',
      'color': '#667eea',
    },
    'photography': {
      'name': 'التصوير الفوتوغرافي',
      'icon': '📸',
      'color': '#2C3E50',
    },
    'crafts': {
      'name': 'الحرف اليدوية',
      'icon': '🧵',
      'color': '#E74C3C',
    },
  };

  static const Map<String, dynamic> validation = {
    'registration': {
      'minAge': 16,
      'maxAge': 65,
      'requiredFields': ['name', 'email', 'phone', 'workshop_id'],
    },
  };
}

class WorkshopUtils {
  static String formatCurrency(int amount) {
    return '${amount.toStringAsFixed(0)} ريال';
  }

  static String formatDate(String date) {
    // Simple date formatting - in a real app, use intl package
    return date;
  }

  static void showNotification(BuildContext context, String message, {String type = 'info'}) {
    final Color backgroundColor;
    final IconData icon;

    switch (type) {
      case 'success':
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'error':
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case 'warning':
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        backgroundColor = Colors.blue;
        icon = Icons.info;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}