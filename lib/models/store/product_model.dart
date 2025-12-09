class Product {
  final int id;
  final String title;
  final String artist;
  final String category;
  final double price;
  final double originalPrice;
  final int discount;
  final double rating;
  final int reviews;
  final String description;
  final String size;
  final String year;
  final String medium;
  final bool isNew;
  final bool inStock;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.artist,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.discount,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.size,
    required this.year,
    required this.medium,
    required this.isNew,
    required this.inStock,
    this.image = '',
  });
}
