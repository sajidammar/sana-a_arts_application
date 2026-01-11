import 'package:sanaa_artl/core/errors/failures.dart';
import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/store/data/store_repository.dart';
import 'package:sanaa_artl/features/store/models/product_model.dart';
import 'package:sanaa_artl/features/store/models/cart_model.dart';

class StoreRepositoryImpl implements StoreRepository {
  // In-memory cache for simplicity
  final List<CartItem> _cartItems = [];

  // Mock Data moved from Provider
  final List<Product> _products = [
    Product(
      id: 1,
      title: "صنعاء العتيقة",
      artist: "أحمد المقطري",
      category: "لوحة زيتية",
      price: 680,
      originalPrice: 850,
      discount: 20,
      rating: 4.8,
      reviews: 24,
      description: "لوحة زيتية تجسد جمال العمارة التراثية في صنعاء القديمة",
      size: "70x100 سم",
      year: "2024",
      medium: "ألوان زيتية على كانفاس",
      isNew: true,
      inStock: true,
      image: 'assets/images/sanaa_img_09.jpg',
    ),
    Product(
      id: 2,
      title: "وجه يمني تراثي",
      artist: "فاطمة الحضرمي",
      category: "بورتريه",
      price: 620,
      originalPrice: 620,
      discount: 0,
      rating: 4.9,
      reviews: 18,
      description: "بورتريه لامرأة يمنية بالزي التراثي مرسوم بالألوان المائية",
      size: "50x70 سم",
      year: "2024",
      medium: "ألوان مائية",
      isNew: false,
      inStock: true,
      image: 'assets/images/sanaa_img_10.jpg',
    ),
    Product(
      id: 3,
      title: "منحوتة جبال اليمن",
      artist: "سالم المقطري",
      category: "منحوتة",
      price: 960,
      originalPrice: 1200,
      discount: 20,
      rating: 4.7,
      reviews: 12,
      description: "منحوتة من الحجر الطبيعي تمثل قمم الجبال اليمنية",
      size: "40x30x25 سم",
      year: "2023",
      medium: "حجر طبيعي",
      isNew: false,
      inStock: true,
      image: 'assets/images/sanaa_img_11.jpg',
    ),
    Product(
      id: 4,
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
      image: 'assets/images/sanaa_img_12.jpg',
    ), // Added from CartProvider mock
  ];

  @override
  Future<Result<List<Product>>> getProducts() async {
    // Simulate delay
    await Future.delayed(const Duration(milliseconds: 500));
    return Result.success(_products);
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    try {
      final product = _products.firstWhere((p) => p.id == id);
      return Result.success(product);
    } catch (e) {
      return const Result.failure(CacheFailure('Product not found'));
    }
  }

  @override
  Future<Result<List<CartItem>>> getCartItems() async {
    // Return copy to prevent external mutation
    return Result.success(List.from(_cartItems));
  }

  @override
  Future<Result<void>> addToCart(Product product, int quantity) async {
    try {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (index >= 0) {
        _cartItems[index].quantity += quantity;
      } else {
        _cartItems.add(CartItem(product: product, quantity: quantity));
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('Failed to add to cart: $e'));
    }
  }

  @override
  Future<Result<void>> removeFromCart(int productId) async {
    _cartItems.removeWhere((item) => item.product.id == productId);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> updateCartQuantity(int productId, int quantity) async {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity > 0) {
        _cartItems[index].quantity = quantity;
      } else {
        _cartItems.removeAt(index);
      }
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> clearCart() async {
    _cartItems.clear();
    return const Result.success(null);
  }
}
