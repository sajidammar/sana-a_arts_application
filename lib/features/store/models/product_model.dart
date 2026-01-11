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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['original_price'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      description: json['description'] ?? '',
      size: json['size'] ?? '',
      year: json['year'] ?? '',
      medium: json['medium'] ?? '',
      isNew: json['is_new'] ?? false,
      inStock: json['in_stock'] ?? false,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'category': category,
      'price': price,
      'original_price': originalPrice,
      'discount': discount,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'size': size,
      'year': year,
      'medium': medium,
      'is_new': isNew,
      'in_stock': inStock,
      'image': image,
    };
  }

  Product copyWith({
    int? id,
    String? title,
    String? artist,
    String? category,
    double? price,
    double? originalPrice,
    int? discount,
    double? rating,
    int? reviews,
    String? description,
    String? size,
    String? year,
    String? medium,
    bool? isNew,
    bool? inStock,
    String? image,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discount: discount ?? this.discount,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      description: description ?? this.description,
      size: size ?? this.size,
      year: year ?? this.year,
      medium: medium ?? this.medium,
      isNew: isNew ?? this.isNew,
      inStock: inStock ?? this.inStock,
      image: image ?? this.image,
    );
  }
}
