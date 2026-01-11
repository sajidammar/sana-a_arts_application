import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sanaa_artl/core/controllers/app_status_provider.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(AppStatusProvider statusProvider) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: iosInitializationSettings,
        );

    try {
      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) {
          // Handle click
        },
      );
      statusProvider.removeAlert('notifications_plugin_error');
    } catch (e) {
      // فشل تهيئة الإشعارات (MissingPluginException)
      statusProvider.addAlert(
        SystemAlert(
          id: 'notifications_plugin_error',
          message: 'عذراً، نظام الإشعارات غير متاح حالياً.',
          type: AlertType.warning,
          icon: Icons.notifications_off,
        ),
      );
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isPersistent = false,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'sanaa_art_main_channel',
      'إشعارات سناء للفنون',
      channelDescription:
          'قناة الإشعارات لتطبيق سناء لرسائل المزامنة وحالات النشر',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: isPersistent,
      autoCancel: !isPersistent,
      showWhen: true,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      // فشل عرض الإشعار
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      // فشل إلغاء الإشعار
    }
  }
}
