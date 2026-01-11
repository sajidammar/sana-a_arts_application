import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/store/data/store_repository.dart';
import 'package:sanaa_artl/features/store/data/store_repository_impl.dart';
import 'package:sanaa_artl/features/store/models/cart_model.dart';
import 'package:sanaa_artl/features/store/models/product_model.dart';

class CartProvider with ChangeNotifier {
  final StoreRepository _repository;

  List<CartItem> _cartItems = [];
  double _subtotal = 0;
  final double _shipping = 25.0;
  double _tax = 0;
  double _total = 0;
  String _error = '';

  List<CartItem> get cartItems => _cartItems;
  double get subtotal => _subtotal;
  double get shipping => _shipping;
  double get tax => _tax;
  double get total => _total;
  String get error => _error;

  CartProvider({StoreRepository? repository})
    : _repository = repository ?? StoreRepositoryImpl();

  Future<void> loadCartItems() async {
    final result = await _repository.getCartItems();

    result.fold(
      (failure) {
        _error = failure.message;
      },
      (items) {
        _cartItems = items;
        _calculateTotals();
      },
    );
    notifyListeners();
  }

  void _calculateTotals() {
    _subtotal = _cartItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    _tax = _subtotal * 0.15;
    _total = _subtotal + _shipping + _tax;
    // Notify listeners handled by caller mostly, but strictly logic should not notify.
    // loadCartItems notifies.
  }

  Future<void> updateQuantity(int index, int newQuantity) async {
    if (newQuantity >= 1) {
      // Optimistic
      _cartItems[index].quantity = newQuantity;
      _calculateTotals();
      notifyListeners();

      final result = await _repository.updateCartQuantity(
        _cartItems[index].product.id,
        newQuantity,
      );
      if (!result.isSuccess) {
        // Revert or show error
        _error = result.failure.message;
        notifyListeners();
      }
    }
  }

  Future<void> removeItem(int index) async {
    final product = _cartItems[index].product;

    // Optimistic
    _cartItems.removeAt(index);
    _calculateTotals();
    notifyListeners();

    final result = await _repository.removeFromCart(product.id);
    if (!result.isSuccess) {
      _error = result.failure.message;
      // We should reload cart really to be safe
      await loadCartItems();
    }
  }

  Future<void> addToCart(Product product) async {
    // Current logic adds 1 or increments
    // We rely on repository or provider check?
    // Repository handles "addToCart" which might just add separate item or merge?
    // Repo impl currently merges: "if (index >= 0) ... += quantity".
    // So we just call repo.

    final result = await _repository.addToCart(product, 1);

    if (result.isSuccess) {
      await loadCartItems(); // Reload to get updated state
    } else {
      _error = result.failure.message;
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    _calculateTotals();
    notifyListeners();
    await _repository.clearCart();
  }
}
