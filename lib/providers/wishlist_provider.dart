import 'package:flutter/foundation.dart';

class WishlistProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;

  int get itemCount => _wishlistItems.length;

  void addToWishlist(Map<String, dynamic> item) {
    // التحقق من عدم وجود العنصر مسبقاً
    final exists = _wishlistItems.any((element) => element['id'] == item['id']);
    if (!exists) {
      _wishlistItems.add(item);
      notifyListeners();
    }
  }

  void removeFromWishlist(String itemId) {
    _wishlistItems.removeWhere((item) => item['id'] == itemId);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }

  bool isInWishlist(String itemId) {
    return _wishlistItems.any((item) => item['id'] == itemId);
  }
}
