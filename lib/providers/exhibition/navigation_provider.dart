import 'package:flutter/foundation.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 0;
  bool _isMenuOpen = false;
  String _currentRoute = '/';
  final List<String> _routeHistory = [];

  int get currentIndex => _currentIndex;
  bool get isMenuOpen => _isMenuOpen;
  String get currentRoute => _currentRoute;
  List<String> get routeHistory => _routeHistory;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners();
  }

  void openMenu() {
    _isMenuOpen = true;
    notifyListeners();
  }

  void closeMenu() {
    _isMenuOpen = false;
    notifyListeners();
  }

  void setCurrentRoute(String route) {
    _currentRoute = route;
    _routeHistory.add(route);
    
    // الحفاظ على تاريخ محدود للمسارات
    if (_routeHistory.length > 10) {
      _routeHistory.removeAt(0);
    }
    
    notifyListeners();
  }

  void goBack() {
    if (_routeHistory.length > 1) {
      _routeHistory.removeLast();
      _currentRoute = _routeHistory.last;
      notifyListeners();
    }
  }

  bool get canGoBack => _routeHistory.length > 1;
}
