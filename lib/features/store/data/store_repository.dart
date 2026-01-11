import 'package:sanaa_artl/core/utils/result.dart';
import 'package:sanaa_artl/features/store/models/product_model.dart';
import 'package:sanaa_artl/features/store/models/cart_model.dart';

abstract class StoreRepository {
  Future<Result<List<Product>>> getProducts();
  Future<Result<Product>> getProductById(int id);

  // Cart operations
  Future<Result<List<CartItem>>> getCartItems();
  Future<Result<void>> addToCart(Product product, int quantity);
  Future<Result<void>> removeFromCart(int productId);
  Future<Result<void>> updateCartQuantity(int productId, int quantity);
  Future<Result<void>> clearCart();
}
