class Invoice {
  final String id;
  final String orderId;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final Customer customer;
  final List<InvoiceItem> items;
  final double subtotal;
  final double discount;
  final double shipping;
  final double tax;
  final double total;
  final String status;

  Invoice({
    required this.id,
    required this.orderId,
    required this.invoiceDate,
    required this.dueDate,
    required this.customer,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.status,
  });
}

class Customer {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String country;

  Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.country,
  });
}

class InvoiceItem {
  final String title;
  final String description;
  final int quantity;
  final double price;
  final double total;

  InvoiceItem({
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
    required this.total,
  });
}

