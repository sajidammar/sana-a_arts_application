import 'package:flutter/material.dart';
import '../../models/store/product_model.dart';
import '../../views/store/product/product_details_page.dart';

class ProductController {
  final BuildContext context;

  ProductController(this.context);

  void showAddToCartSnackBar(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة ${product.title} إلى السلة'),
        backgroundColor: Color(0xFFB8860B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void navigateToProductDetails(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(product: product),
      ),
    );
  }
}
