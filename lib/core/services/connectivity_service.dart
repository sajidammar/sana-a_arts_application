import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/core/controllers/app_status_provider.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(true);

  Future<void> initialize(AppStatusProvider statusProvider) async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateStatus(result, statusProvider);

      _connectivity.onConnectivityChanged.listen((
        List<ConnectivityResult> results,
      ) {
        _updateStatus(results, statusProvider);
      });
    } catch (e) {
      // إذا فشل الـ Plugin (مثلاً MissingPluginException)
      isConnected.value = true;
      statusProvider.addAlert(
        SystemAlert(
          id: 'connectivity_plugin_error',
          message: 'عذراً، نظام فحص الاتصال غير متاح حالياً.',
          type: AlertType.warning,
          icon: Icons.sync_problem,
        ),
      );
    }
  }

  void _updateStatus(dynamic result, AppStatusProvider statusProvider) {
    bool connected = true;
    if (result is List<ConnectivityResult>) {
      connected = !result.contains(ConnectivityResult.none);
    } else if (result is ConnectivityResult) {
      connected = result != ConnectivityResult.none;
    }

    isConnected.value = connected;

    if (!connected) {
      statusProvider.addAlert(
        SystemAlert(
          id: 'no_internet',
          message: 'لا يوجد اتصال بالانترنت - تصفح المحتوى المخزن',
          type: AlertType.warning,
          icon: Icons.wifi_off,
        ),
      );
    } else {
      statusProvider.removeAlert('no_internet');
    }
  }

  Future<bool> checkCurrentStatus() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result is List<ConnectivityResult>) {
        return !result.contains(ConnectivityResult.none);
      }
      return result != ConnectivityResult.none;
    } catch (e) {
      return true; // الفشل يعني متصل افتراضياً للتجاوز
    }
  }
}
