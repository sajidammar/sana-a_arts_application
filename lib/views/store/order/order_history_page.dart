import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/store/cart_model.dart';
import '../../../providers/store/order_provider.dart';
import '../../../themes/store/app_theme.dart';
import '../../../utils/store/app_constants.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 1,
            floating: true,
            snap: true,
            pinned: true,
            title: Text(
              'سجل الطلبات',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(child: _buildFilters(orderProvider, context)),
          orderProvider.filteredOrders.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildOrderCard(
                        orderProvider.filteredOrders[index],
                        context,
                      );
                    }, childCount: orderProvider.filteredOrders.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لم تقم بأي طلبات حتى الآن',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(OrderProvider orderProvider, BuildContext context) {
    return Card(
      margin: EdgeInsets.all(AppConstants.defaultPadding),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'البحث في الطلبات...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultBorderRadius,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF2D2D2D)
                    : Colors.grey.shade50,
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade500
                      : Colors.grey.shade600,
                ),
              ),
              style: TextStyle(color: AppTheme.getTextColor(context)),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    value: orderProvider.selectedStatus,
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('جميع الحالات'),
                      ),
                      DropdownMenuItem(
                        value: 'pending',
                        child: Text('في الانتظار'),
                      ),
                      DropdownMenuItem(
                        value: 'processing',
                        child: Text('قيد المعالجة'),
                      ),
                      DropdownMenuItem(
                        value: 'shipped',
                        child: Text('تم الشحن'),
                      ),
                      DropdownMenuItem(
                        value: 'delivered',
                        child: Text('تم التسليم'),
                      ),
                      DropdownMenuItem(value: 'cancelled', child: Text('ملغي')),
                    ],
                    onChanged: (value) {
                      orderProvider.setSelectedStatus(value.toString());
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF2D2D2D)
                          : Colors.grey.shade50,
                    ),
                    style: TextStyle(color: AppTheme.getTextColor(context)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField(
                    value: orderProvider.selectedDate,
                    items: [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('جميع التواريخ'),
                      ),
                      DropdownMenuItem(value: 'week', child: Text('آخر أسبوع')),
                      DropdownMenuItem(value: 'month', child: Text('آخر شهر')),
                      DropdownMenuItem(
                        value: '3months',
                        child: Text('آخر 3 أشهر'),
                      ),
                      DropdownMenuItem(value: 'year', child: Text('آخر سنة')),
                    ],
                    onChanged: (value) {
                      orderProvider.setSelectedDate(value.toString());
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF2D2D2D)
                          : Colors.grey.shade50,
                    ),
                    style: TextStyle(color: AppTheme.getTextColor(context)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      Theme.of(context).dividerTheme.color ??
                      Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.getTextColor(context),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        order.date,
                        style: TextStyle(
                          color: AppTheme.getSecondaryTextColor(context),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withValues(alpha: 0.1),
                    border: Border.all(color: _getStatusColor(order.status)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '\$${order.total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Order Items
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: order.items
                  .map((item) => _buildOrderItem(item, context))
                  .toList(),
            ),
          ),

          // Actions Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      Theme.of(context).dividerTheme.color ??
                      Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == 'shipped' || order.status == 'delivered')
                  ElevatedButton(
                    onPressed: () => _trackOrder(order, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor:
                          Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_shipping, size: 16),
                        SizedBox(width: 4),
                        Text('تتبع الطلب'),
                      ],
                    ),
                  ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () => _viewInvoice(order, context),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt),
                      SizedBox(width: 4),
                      Text('الفاتورة'),
                    ],
                  ),
                ),
                if (order.status == 'pending' ||
                    order.status == 'processing') ...[
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _cancelOrder(order, context),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cancel),
                        SizedBox(width: 4),
                        Text('إلغاء الطلب'),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem item, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800.withValues(alpha: 0.3)
            : AppConstants.accentColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  Theme.of(context).primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'الفنان: ${item.artist}',
                  style: TextStyle(
                    color: AppTheme.getSecondaryTextColor(context),
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'الكمية: ${item.quantity}',
                  style: TextStyle(
                    color: AppTheme.getSecondaryTextColor(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Color(0xFFFF6B35);
      case 'processing':
        return Color(0xFF17a2b8);
      case 'pending':
        return Color(0xFFFFC107);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _trackOrder(Order order, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'تتبع الطلب ${order.id}',
          style: TextStyle(color: AppTheme.getTextColor(context)),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: _buildTrackingTimeline(order, context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(Order order, BuildContext context) {
    List<Map<String, String>> trackingSteps = [
      {
        'title': 'تم تأكيد الطلب',
        'date': '10 يناير 2024 - 1:00 م',
        'status': 'completed',
      },
      {
        'title': 'قيد التحضير',
        'date': '12 يناير 2024 - 10:00 ص',
        'status': 'completed',
      },
      {
        'title': 'تم الشحن',
        'date': '14 يناير 2024 - 3:00 م',
        'status': 'completed',
      },
      {
        'title': 'وصل إلى مركز التوزيع',
        'date': '15 يناير 2024 - 9:00 ص',
        'status': 'completed',
      },
      {
        'title': 'خارج للتسليم',
        'date': '15 يناير 2024 - 2:30 م',
        'status': 'completed',
      },
      {
        'title': 'تم التسليم',
        'date': '15 يناير 2024 - 4:00 م',
        'status': 'completed',
      },
    ];

    return Column(
      children: trackingSteps
          .map((step) => _buildTimelineStep(step, context))
          .toList(),
    );
  }

  Widget _buildTimelineStep(Map<String, String> step, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: step['status'] == 'completed'
                  ? Colors.green
                  : Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: step['status'] == 'completed'
                ? Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextColor(context),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  step['date']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.getSecondaryTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewInvoice(Order order, BuildContext context) {
    Navigator.pushNamed(context, '/invoice');
  }

  void _cancelOrder(Order order, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          'إلغاء الطلب',
          style: TextStyle(color: AppTheme.getTextColor(context)),
        ),
        content: Text(
          'هل أنت متأكد من إلغاء الطلب ${order.id}؟',
          style: TextStyle(color: AppTheme.getSecondaryTextColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'لا',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('تم إلغاء الطلب ${order.id}', context);
            },
            child: Text('نعم', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
