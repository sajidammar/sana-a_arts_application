import 'package:flutter/material.dart';
import '../../models/store/cart_model.dart';
import '../../models/store/product_model.dart';


class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];
  double _subtotal = 0;
  final double _shipping = 25.0;
  double _tax = 0;
  double _total = 0;

  List<CartItem> get cartItems => _cartItems;
  double get subtotal => _subtotal;
  double get shipping => _shipping;
  double get tax => _tax;
  double get total => _total;

  void loadCartItems() {
    _cartItems = [
      CartItem(
        product: Product(
          id: 1,
          title: "لوحة المدينة القديمة",
          artist: "أحمد محمد الشامي",
          category: "لوحة زيتية",
          price: 450.0,
          originalPrice: 500.0,
          discount: 10,
          rating: 4.8,
          reviews: 24,
          description: "لوحة زيتية تجسد جمال العمارة التراثية في صنعاء القديمة",
          size: "80×60 سم",
          year: "2024",
          medium: "ألوان زيتية على كانفاس",
          isNew: true,
          inStock: true,
        ),
        quantity: 1,
      ),
      CartItem(
        product: Product(
          id: 2,
          title: "تمثال الأصالة",
          artist: "سالم المقطري",
          category: "منحوتة",
          price: 280.0,
          originalPrice: 280.0,
          discount: 0,
          rating: 4.7,
          reviews: 12,
          description: "منحوتة من الحجر الطبيعي تمثل التراث اليمني",
          size: "40×30×25 سم",
          year: "2023",
          medium: "حجر طبيعي",
          isNew: false,
          inStock: true,
        ),
        quantity: 1,
      ),
      CartItem(
        product: Product(
          id: 3,
          title: "كتاب تقنيات الرسم",
          artist: "مؤسسة فنون صنعاء",
          category: "كتاب",
          price: 25.0,
          originalPrice: 25.0,
          discount: 0,
          rating: 4.5,
          reviews: 8,
          description: "كتاب تعليمي لتقنيات الرسم والفن التشكيلي",
          size: "A4",
          year: "2024",
          medium: "طباعة فاخرة",
          isNew: true,
          inStock: true,
        ),
        quantity: 2,
      ),
    ];
    _calculateTotals();
  }

  void _calculateTotals() {
    _subtotal = _cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    _tax = _subtotal * 0.15;
    _total = _subtotal + _shipping + _tax;
    notifyListeners();
  }

  void updateQuantity(int index, int newQuantity) {
    if (newQuantity >= 1) {
      _cartItems[index].quantity = newQuantity;
      _calculateTotals();
    }
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    _calculateTotals();
    notifyListeners();
  }

  void addToCart(Product product) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    _calculateTotals();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _calculateTotals();
    notifyListeners();
  }
}
