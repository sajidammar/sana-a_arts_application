import 'package:flutter/foundation.dart';
import '../utils/database/dao/wishlist_dao.dart';

class WishlistProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _wishlistItems = [];
  final WishlistDao _dao = WishlistDao();
  String _userId = 'current_user';

  void setUserId(String id) {
    _userId = id;
  }

  List<Map<String, dynamic>> get wishlistItems => _wishlistItems;

  int get itemCount => _wishlistItems.length;

  Future<void> loadWishlist(List<dynamic> products) async {
    final wishlistItemsDb = await _dao.getAllWishlistItems(_userId);
    _wishlistItems.clear();

    for (var item in wishlistItemsDb) {
      if (item['item_type'] == WishlistItemType.product.name) {
        final productId = int.tryParse(item['item_id'] as String) ?? -1;
        final product = products.firstWhere(
          (p) => p.id == productId,
          orElse: () => null,
        );

        if (product != null) {
          _wishlistItems.add({
            'id': product.id.toString(),
            'title': product.title,
            'subtitle': product.artist,
            'price': product.price,
            'image': product.image,
            'type': WishlistItemType.product.name,
          });
        }
      }
    }
    notifyListeners();
  }

  Future<void> addToWishlist(Map<String, dynamic> item) async {
    final exists = _wishlistItems.any((element) => element['id'] == item['id']);
    if (!exists) {
      _wishlistItems.add(item);
      notifyListeners();

      await _dao.addToWishlist(
        userId: _userId,
        itemId: item['id'],
        itemType:
            WishlistItemType.product, // Assuming product for now based on usage
      );
    }
  }

  Future<void> removeFromWishlist(String itemId) async {
    _wishlistItems.removeWhere((item) => item['id'] == itemId);
    notifyListeners();

    await _dao.removeFromWishlist(
      userId: _userId,
      itemId: itemId,
      itemType: WishlistItemType.product,
    );
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
    _dao.clearWishlist(_userId);
  }

  bool isInWishlist(String itemId) {
    return _wishlistItems.any((item) => item['id'] == itemId);
  }
}
