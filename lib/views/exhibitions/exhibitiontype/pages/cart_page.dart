import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/exhibition/vr_provider.dart';

class ExhibitionCartPage extends StatelessWidget {
  const ExhibitionCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VRProvider>(
      builder: (context, vrProvider, child) {
        final cartItems = vrProvider.cartItems;

        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    pinned: true,
                    elevation: 1,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Text(
                      'سلة الأعمال الفنية',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    centerTitle: true,
                    actions: [
                      if (cartItems.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            vrProvider.clearCart();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم إفراغ السلة'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red[400],
                          ),
                        ),
                    ],
                  ),
                  if (cartItems.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyCart(context),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return _buildCartItem(
                            context,
                            cartItems[index],
                            vrProvider,
                          );
                        }, childCount: cartItems.length),
                      ),
                    ),
                ],
              ),
            ),
            if (cartItems.isNotEmpty) _buildCheckoutBar(context, cartItems),
          ],
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 100,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'السلة فارغة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'لم تقم بإضافة أي عمل فني بعد',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Tajawal',
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    Map<String, dynamic> item,
    VRProvider vrProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة العمل الفني
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Icon(Icons.image, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 16),
          // تفاصيل العمل الفني
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? 'عمل فني',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item['artist'] ?? 'فنان مجهول',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Tajawal',
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item['price'] ?? '0'} ريال',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          // زر الحذف
          IconButton(
            onPressed: () {
              vrProvider.removeFromCart(item['id'] ?? 0);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إزالة العمل من السلة'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: Icon(Icons.close, color: Colors.red[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(
    BuildContext context,
    List<Map<String, dynamic>> cartItems,
  ) {
    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + (item['price'] ?? 0),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المجموع:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  '$total ريال',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // معالجة عملية الشراء
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('جاري معالجة الطلب...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'إتمام الشراء',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

