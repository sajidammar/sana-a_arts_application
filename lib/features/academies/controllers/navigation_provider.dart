// providers/navigation_provider.dart
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currentIndex = 2;
  String _currentRoute = '/courses';

  int get currentIndex => _currentIndex;
  String get currentRoute => _currentRoute;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setCurrentRoute(String route) {
    _currentRoute = route;
    notifyListeners();
  }

  final List<NavigationItem> mainNavigationItems = [
    NavigationItem(
      name: 'الرئيسية',
      icon: Icons.home,
      route: '/home',
    ),
    NavigationItem(
      name: 'المعارض',
      icon: Icons.photo_library,
      route: '/exhibitions',
    ),
    NavigationItem(
      name: 'الدورات',
      icon: Icons.school,
      route: '/courses',
      active: true,
    ),
    NavigationItem(
      name: 'المتجر',
      icon: Icons.shopping_cart,
      route: '/store',
    ),
    NavigationItem(
      name: 'الأخبار',
      icon: Icons.newspaper,
      route: '/news',
    ),
    NavigationItem(
      name: 'التواصل',
      icon: Icons.contact_mail,
      route: '/contact',
    ),
    NavigationItem(
      name: 'من نحن',
      icon: Icons.info,
      route: '/about',
    ),
  ];

  final List<NavigationItem> workshopNavigationItems = [
    NavigationItem(
      name: 'التسجيل في ورشة',
      icon: Icons.person_add,
      route: '/registration',
    ),
    NavigationItem(
      name: 'ورشي التدريبية',
      icon: Icons.school,
      route: '/my-workshops',
    ),
    NavigationItem(
      name: 'المدربين',
      icon: Icons.people,
      route: '/instructors',
    ),
    NavigationItem(
      name: 'الجدول الزمني',
      icon: Icons.calendar_today,
      route: '/calendar',
    ),
    NavigationItem(
      name: 'الشهادات',
      icon: Icons.verified,
      route: '/certificates',
    ),
    NavigationItem(
      name: 'التقييمات',
      icon: Icons.star,
      route: '/reviews',
    ),
    NavigationItem(
      name: 'الدفع والتسعير',
      icon: Icons.payment,
      route: '/payment',
    ),
    NavigationItem(
      name: 'المسابقات',
      icon: Icons.emoji_events,
      route: '/competitions',
    ),
  ];
}

class NavigationItem {
  final String name;
  final IconData icon;
  final String route;
  final bool active;

  const NavigationItem({
    required this.name,
    required this.icon,
    required this.route,
    this.active = false,
  });
}

