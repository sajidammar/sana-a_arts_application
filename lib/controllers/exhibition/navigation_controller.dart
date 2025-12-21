import 'package:sanaa_artl/providers/exhibition/navigation_provider.dart';


class NavigationController {
  final NavigationProvider _navigationProvider;

  NavigationController(this._navigationProvider);

  void setCurrentIndex(int index) {
    _navigationProvider.setCurrentIndex(index);
  }

  void toggleMenu() {
    _navigationProvider.toggleMenu();
  }

  void openMenu() {
    _navigationProvider.openMenu();
  }

  void closeMenu() {
    _navigationProvider.closeMenu();
  }

  void setCurrentRoute(String route) {
    _navigationProvider.setCurrentRoute(route);
  }

  void goBack() {
    _navigationProvider.goBack();
  }

  // Getters
  int get currentIndex => _navigationProvider.currentIndex;
  bool get isMenuOpen => _navigationProvider.isMenuOpen;
  String get currentRoute => _navigationProvider.currentRoute;
  List<String> get routeHistory => _navigationProvider.routeHistory;
  bool get canGoBack => _navigationProvider.canGoBack;
}
