import 'package:flutter/foundation.dart';

class CheckboxProvider with ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  void setChecked(bool value) {
    _isChecked = value;
    notifyListeners(); // هذا سيحدث فقط الـ Widgets التي تستمع لهذا الـ Provider
  }

  void toggleChecked() {
    _isChecked = !_isChecked;
    notifyListeners();
  }
}
