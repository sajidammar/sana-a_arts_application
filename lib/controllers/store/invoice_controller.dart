import 'package:flutter/material.dart';

class InvoiceController {
  final BuildContext context;

  InvoiceController(this.context);

  void printInvoice() {
    // Logic for printing invoice
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري طباعة الفاتورة...'),
        backgroundColor: Color(0xFFB8860B),
      ),
    );
  }

  void downloadInvoice() {
    // Logic for downloading invoice
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل الفاتورة...'),
        backgroundColor: Color(0xFF17a2b8),
      ),
    );
  }

  void shareInvoice() {
    // Logic for sharing invoice
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري مشاركة الفاتورة...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
