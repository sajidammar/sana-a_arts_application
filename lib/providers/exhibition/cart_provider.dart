import 'package:flutter/foundation.dart';
import 'package:sanaa_artl/models/exhibition/artwork.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  bool _isLoading = false;
  String _error = '';

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String get error => _error;
  int get itemCount => _items.length;
  double get totalPrice {
    return _items.fold(0, (total, item) => total + (item.artwork.price * item.quantity));
  }

  void addToCart(Artwork artwork, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.artwork.id == artwork.id);
    
    if (existingIndex != -1) {
      // زيادة الكمية إذا كان العمل موجوداً بالفعل
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // إضافة عنصر جديد
      _items.add(CartItem(
        artwork: artwork,
        quantity: quantity,
        addedAt: DateTime.now(),
      ));
    }
    
    notifyListeners();
  }

  void removeFromCart(String artworkId) {
    _items.removeWhere((item) => item.artwork.id == artworkId);
    notifyListeners();
  }

  void updateQuantity(String artworkId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(artworkId);
      return;
    }

    final index = _items.indexWhere((item) => item.artwork.id == artworkId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  void incrementQuantity(String artworkId) {
    final index = _items.indexWhere((item) => item.artwork.id == artworkId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
      notifyListeners();
    }
  }

  void decrementQuantity(String artworkId) {
    final index = _items.indexWhere((item) => item.artwork.id == artworkId);
    if (index != -1) {
      final newQuantity = _items[index].quantity - 1;
      if (newQuantity <= 0) {
        removeFromCart(artworkId);
      } else {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String artworkId) {
    return _items.any((item) => item.artwork.id == artworkId);
  }

  int getQuantity(String artworkId) {
    final item = _items.firstWhere((item) => item.artwork.id == artworkId, orElse: () => CartItem(artwork: Artwork(id: '', title: '', artist: '', artistId: '', year: 0, technique: '', dimensions: '', description: '', rating: 0, ratingCount: 0, price: 0, currency: '', category: '', tags: [], imageUrl: '', createdAt: DateTime.now(), isFeatured: true, views: 1, likes: 2), quantity: 0, addedAt: DateTime.now()));
    return item.quantity;
  }

  Future<void> checkout() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // محاكاة عملية الدفع
      await Future.delayed(const Duration(seconds: 3));
      
      // في التطبيق الحقيقي، سيتم إرسال طلب الشراء إلى الخادم
      clearCart();
      _error = '';
    } catch (e) {
      _error = 'حدث خطأ أثناء عملية الدفع: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class CartItem {
  final Artwork artwork;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.artwork,
    required this.quantity,
    required this.addedAt,
  });

  CartItem copyWith({
    Artwork? artwork,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      artwork: artwork ?? this.artwork,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  double get totalPrice => artwork.price * quantity;
}
