class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  const CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
