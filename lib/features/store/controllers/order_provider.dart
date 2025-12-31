import 'package:flutter/material.dart';
import 'package:sanaa_artl/features/store/models/cart_model.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  String _selectedStatus = 'all';
  String _selectedDate = 'all';

  List<Order> get orders => _orders;
  List<Order> get filteredOrders => _filteredOrders;
  String get selectedStatus => _selectedStatus;
  String get selectedDate => _selectedDate;

  void loadOrders() {
    _orders = [
      Order(
        id: 'ORD-2024-001',
        date: '15 يناير 2024',
        status: 'delivered',
        statusText: 'تم التسليم',
        total: 850.0,
        items: [
          OrderItem('لوحة المدينة القديمة', 'أحمد محمد الشامي', 450.0, 1),
          OrderItem('لوحة الطبيعة الصامتة', 'محمد علي الحديدي', 320.0, 1),
        ],
      ),
      Order(
        id: 'ORD-2024-002',
        date: '20 يناير 2024',
        status: 'shipped',
        statusText: 'تم الشحن',
        total: 680.0,
        items: [
          OrderItem('منظر طبيعي جبلي', 'سارة أحمد القادري', 280.0, 1),
          OrderItem('بورتريه تراثي', 'فاطمة علي الحكيمي', 380.0, 1),
        ],
      ),
      Order(
        id: 'ORD-2024-003',
        date: '25 يناير 2024',
        status: 'processing',
        statusText: 'قيد المعالجة',
        total: 420.0,
        items: [
          OrderItem('لوحة البحر والشاطئ', 'عبدالله محمد الزبيري', 420.0, 1),
        ],
      ),
    ];
    _filteredOrders = _orders;
    notifyListeners();
  }

  void setSelectedStatus(String status) {
    _selectedStatus = status;
    _filterOrders();
    notifyListeners();
  }

  void setSelectedDate(String date) {
    _selectedDate = date;
    _filterOrders();
    notifyListeners();
  }

  void _filterOrders() {
    if (_selectedStatus == 'all' && _selectedDate == 'all') {
      _filteredOrders = _orders;
    } else {
      _filteredOrders = _orders.where((order) {
        final statusMatch = _selectedStatus == 'all' || order.status == _selectedStatus;
        return statusMatch;
      }).toList();
    }
  }
}


