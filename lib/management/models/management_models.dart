class ManagementStat {
  final String title;
  final String value;
  final String icon;
  final String color;

  ManagementStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class AcademyItem {
  final int? id;
  final String title;
  final String instructor;
  final String status;
  final String dateAdded;

  AcademyItem({
    this.id,
    required this.title,
    required this.instructor,
    required this.status,
    required this.dateAdded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'instructor': instructor,
      'status': status,
      'date_added': dateAdded,
    };
  }

  factory AcademyItem.fromMap(Map<String, dynamic> map) {
    return AcademyItem(
      id: map['id'],
      title: map['title'],
      instructor: map['instructor'],
      status: map['status'],
      dateAdded: map['date_added'],
    );
  }
}

class ManagementProduct {
  final int? id;
  final String productName;
  final double price;
  final int stock;
  final String category;

  ManagementProduct({
    this.id,
    required this.productName,
    required this.price,
    required this.stock,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_name': productName,
      'price': price,
      'stock': stock,
      'category': category,
    };
  }

  factory ManagementProduct.fromMap(Map<String, dynamic> map) {
    return ManagementProduct(
      id: map['id'],
      productName: map['product_name'],
      price: map['price'],
      stock: map['stock'],
      category: map['category'],
    );
  }
}
