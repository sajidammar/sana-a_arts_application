import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/store/models/invoice_model.dart';


class InvoiceProvider with ChangeNotifier {
  Invoice? _currentInvoice;

  Invoice? get currentInvoice => _currentInvoice;

  void loadInvoice(String orderId) {
    // Simulate loading invoice data
    _currentInvoice = Invoice(
      id: 'INV-2024-001',
      orderId: orderId,
      invoiceDate: DateTime(2024, 1, 10),
      dueDate: DateTime(2024, 1, 17),
      customer: Customer(
        name: 'محمد أحمد السعدي',
        email: 'mohammed.alsaedi@email.com',
        phone: '+967 777 123456',
        address: 'صنعاء، شارع الزبيري، مجمع النصر التجاري، الطابق الثالث',
        city: 'صنعاء',
        country: 'اليمن',
      ),
      items: [
        InvoiceItem(
          title: 'لوحة المدينة القديمة',
          description: 'لوحة زيتية • 80×60 سم • 2024 • مع إطار',
          quantity: 1,
          price: 450.0,
          total: 450.0,
        ),
        InvoiceItem(
          title: 'لوحة الطبيعة الصامتة',
          description: 'لوحة أكريليك • 70×50 سم • 2024 • مع إطار',
          quantity: 1,
          price: 320.0,
          total: 320.0,
        ),
      ],
      subtotal: 770.0,
      discount: 38.5,
      shipping: 25.0,
      tax: 115.73,
      total: 887.23,
      status: 'paid',
    );
    notifyListeners();
  }

  void clearInvoice() {
    _currentInvoice = null;
    notifyListeners();
  }
}


