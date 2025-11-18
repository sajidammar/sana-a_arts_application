class Order {
  final String id;
  final String date;
  final String status;
  final String statusText;
  final double total;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.statusText,
    required this.total,
    required this.items,
  });
}

class OrderItem {
  final String title;
  final String artist;
  final double price;
  final int quantity;

  OrderItem(this.title, this.artist, this.price, this.quantity);
}