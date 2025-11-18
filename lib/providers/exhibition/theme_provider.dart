import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _themeColor = 'gold';

  ThemeMode get themeMode => _themeMode;
  String get themeColor => _themeColor;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;
  bool get isSystemMode => _themeMode == ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setThemeColor(String color) {
    _themeColor = color;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  // دوال مساعدة إضافية للتحكم في السمة
  void switchToLight() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  void switchToDark() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  void switchToSystem() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  // دالة للتبديل الدائري بين الثيمات
  void cycleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
    }
    notifyListeners();
  }

  // دالة للتحقق مما إذا كان الثيم الحالي يتطابق مع إعدادات النظام
  bool get isFollowingSystem => _themeMode == ThemeMode.system;

  // دالة لإعادة التعيين إلى الإعدادات الافتراضية
  void resetToDefault() {
    _themeMode = ThemeMode.light;
    _themeColor = 'gold';
    notifyListeners();
  }
}
