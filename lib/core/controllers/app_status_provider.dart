import 'package:flutter/material.dart';

enum AlertType { error, warning, info }

class SystemAlert {
  final String id;
  final String message;
  final AlertType type;
  final IconData? icon;

  SystemAlert({
    required this.id,
    required this.message,
    this.type = AlertType.error,
    this.icon,
  });
}

class AppStatusProvider with ChangeNotifier {
  final List<SystemAlert> _alerts = [];
  List<SystemAlert> get alerts => _alerts;

  void addAlert(SystemAlert alert) {
    // تجنب التكرار
    _alerts.removeWhere((a) => a.id == alert.id);
    _alerts.add(alert);
    notifyListeners();
  }

  void removeAlert(String id) {
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    notifyListeners();
  }
}
