import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/store/cart_model.dart';
import '../../../providers/store/order_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/app_colors.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: cardColor,
            elevation: 0,
            floating: true,
            snap: true,
            pinned: true,
            title: Text(
              'سجل الطلبات',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildFilters(
              orderProvider,
              context,
              isDark,
              primaryColor,
              textColor,
              cardColor,
            ),
          ),
          orderProvider.filteredOrders.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(
                    context,
                    isDark,
                    primaryColor,
                    textColor,
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildOrderCard(
                        orderProvider.filteredOrders[index],
                        context,
                        isDark,
                        primaryColor,
                        textColor,
                        cardColor,
                      );
                    }, childCount: orderProvider.filteredOrders.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: Color(0xFFC0A060),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'لم تقم بأي طلبات حتى الآن',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(
    OrderProvider orderProvider,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    final fieldColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withValues(alpha: 0.05);
    final subtextColor = AppColors.getSubtextColor(isDark);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'البحث في الطلبات...',
              prefixIcon: Icon(Icons.search_rounded, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: fieldColor,
              hintStyle: TextStyle(color: subtextColor, fontFamily: 'Tajawal'),
            ),
            style: TextStyle(color: textColor, fontFamily: 'Tajawal'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  context,
                  isDark,
                  textColor,
                  fieldColor,
                  orderProvider.selectedStatus,
                  [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('جميع الحالات'),
                    ),
                    const DropdownMenuItem(
                      value: 'pending',
                      child: Text('في الانتظار'),
                    ),
                    const DropdownMenuItem(
                      value: 'processing',
                      child: Text('قيد المعالجة'),
                    ),
                    const DropdownMenuItem(
                      value: 'shipped',
                      child: Text('تم الشحن'),
                    ),
                    const DropdownMenuItem(
                      value: 'delivered',
                      child: Text('تم التسليم'),
                    ),
                    const DropdownMenuItem(
                      value: 'cancelled',
                      child: Text('ملغي'),
                    ),
                  ],
                  (value) => orderProvider.setSelectedStatus(value.toString()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  context,
                  isDark,
                  textColor,
                  fieldColor,
                  orderProvider.selectedDate,
                  [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('جميع التواريخ'),
                    ),
                    const DropdownMenuItem(
                      value: 'month',
                      child: Text('آخر شهر'),
                    ),
                    const DropdownMenuItem(
                      value: '3months',
                      child: Text('آخر 3 أشهر'),
                    ),
                    const DropdownMenuItem(
                      value: 'year',
                      child: Text('آخر سنة'),
                    ),
                  ],
                  (value) => orderProvider.setSelectedDate(value.toString()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color fieldColor,
    String value,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        filled: true,
        fillColor: fieldColor,
      ),
      style: TextStyle(color: textColor, fontFamily: 'Tajawal', fontSize: 14),
    );
  }

  Widget _buildOrderCard(
    Order order,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    final subtextColor = AppColors.getSubtextColor(isDark);
    final borderColor = isDark
        ? Colors.white10
        : Colors.black.withValues(alpha: 0.05);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${order.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.date,
                        style: TextStyle(
                          color: subtextColor,
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(
                  order.statusText,
                  _getStatusColor(order.status),
                ),
                const SizedBox(width: 12),
                Text(
                  '\$${order.total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Tajawal',
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Order Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: order.items
                  .map(
                    (item) => _buildOrderItem(
                      item,
                      context,
                      isDark,
                      primaryColor,
                      textColor,
                    ),
                  )
                  .toList(),
            ),
          ),

          // Actions Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: borderColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == 'shipped' || order.status == 'delivered')
                  ElevatedButton(
                    onPressed: () => _trackOrder(
                      order,
                      context,
                      isDark,
                      primaryColor,
                      textColor,
                      cardColor,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.local_shipping_rounded, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'تتبع الطلب',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => _viewInvoice(order, context),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.receipt_long_rounded, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'الفاتورة',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.status == 'pending' ||
                    order.status == 'processing') ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => _cancelOrder(
                      order,
                      context,
                      isDark,
                      primaryColor,
                      textColor,
                      cardColor,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.cancel_outlined, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'إلغاء الطلب',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildOrderItem(
    OrderItem item,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    final subtextColor = AppColors.getSubtextColor(isDark);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                gradient: AppColors.storeGradient,
              ),
              child: const Icon(
                Icons.palette_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                    color: textColor,
                  ),
                ),
                Text(
                  '${item.artist} • x${item.quantity}',
                  style: TextStyle(
                    color: subtextColor,
                    fontSize: 12,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.price.toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 15,
              fontFamily: 'Tajawal',
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
        return const Color(0xFFFF6B35);
      case 'processing':
        return const Color(0xFF17a2b8);
      case 'pending':
        return const Color(0xFFFFC107);
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _trackOrder(
    Order order,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'تتبع الطلب #${order.id}',
          style: TextStyle(
            color: textColor,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTrackingTimeline(
                order,
                context,
                isDark,
                primaryColor,
                textColor,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إغلاق',
              style: TextStyle(
                color: primaryColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(
    Order order,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
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
        'status': 'active',
      },
      {'title': 'خارج للتسليم', 'date': '-', 'status': 'pending'},
      {'title': 'تم التسليم', 'date': '-', 'status': 'pending'},
    ];

    return Column(
      children: trackingSteps
          .map(
            (step) => _buildTimelineStep(
              step,
              context,
              isDark,
              primaryColor,
              textColor,
            ),
          )
          .toList(),
    );
  }

  Widget _buildTimelineStep(
    Map<String, String> step,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    final subtextColor = AppColors.getSubtextColor(isDark);
    Color stepColor;
    switch (step['status']) {
      case 'completed':
        stepColor = Colors.green;
        break;
      case 'active':
        stepColor = primaryColor;
        break;
      default:
        stepColor = subtextColor.withValues(alpha: 0.3);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: step['status'] == 'completed'
                      ? stepColor
                      : Colors.transparent,
                  border: Border.all(color: stepColor, width: 2),
                  shape: BoxShape.circle,
                ),
                child: step['status'] == 'completed'
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: step['status'] == 'pending'
                        ? subtextColor
                        : textColor,
                  ),
                ),
                if (step['date'] != '-')
                  Text(
                    step['date']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Tajawal',
                      color: subtextColor,
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

  void _cancelOrder(
    Order order,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'إلغاء الطلب',
          style: TextStyle(
            color: textColor,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من إلغاء الطلب #${order.id}؟',
          style: TextStyle(
            color: AppColors.getSubtextColor(isDark),
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'لا',
              style: TextStyle(
                color: primaryColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar(
                'تم إلغاء الطلب #${order.id}',
                context,
                primaryColor,
              );
            },
            child: const Text(
              'نعم',
              style: TextStyle(
                color: Colors.redAccent,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, BuildContext context, Color primaryColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Tajawal')),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
