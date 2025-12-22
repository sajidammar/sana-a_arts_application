import 'package:flutter/material.dart';

class CartController {
  final BuildContext context;

  CartController(this.context);

  void showRemoveSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف المنتج من السلة'),
        backgroundColor: Color(0xFFB8860B),
      ),
    );
  }

  void showEmptyCartSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('السلة فارغة! أضف بعض المنتجات أولاً'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
