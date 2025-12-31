import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/store/controllers/cart_controller.dart';
import 'package:sanaa_artl/features/store/models/cart_model.dart';
import 'package:sanaa_artl/features/store/controllers/cart_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: cardColor,
                      elevation: 0,
                      floating: true,
                      snap: true,
                      pinned: true,
                      title: Text(
                        'سلة التسوق',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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
                    cartProvider.cartItems.isEmpty
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: _buildEmptyCart(
                              context,
                              isDark,
                              primaryColor,
                              textColor,
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                return _buildCartItem(
                                  cartProvider.cartItems[index],
                                  index,
                                  context,
                                  isDark,
                                  primaryColor,
                                  textColor,
                                  cardColor,
                                );
                              }, childCount: cartProvider.cartItems.length),
                            ),
                          ),
                  ],
                ),
              ),
              if (cartProvider.cartItems.isNotEmpty)
                _buildOrderSummary(
                  cartProvider,
                  context,
                  isDark,
                  primaryColor,
                  textColor,
                  cardColor,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(
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
              Icons.shopping_cart_outlined,
              size: 80,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            'سلة التسوق فارغة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'أضف بعض الأعمال الفنية إلى سلتك',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            child: const Text(
              'تصفح المتجر',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    CartItem item,
    int index,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartController = CartController(context);

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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  gradient: AppColors.storeGradient,
                ),
                child: const Icon(
                  Icons.palette_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.product.artist,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Tajawal',
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildQuantitySelector(
                    cartProvider,
                    index,
                    item,
                    isDark,
                    primaryColor,
                    textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(item.product.price * item.quantity).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    cartProvider.removeItem(index);
                    cartController.showRemoveSnackBar();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(
    CartProvider cartProvider,
    int index,
    CartItem item,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityBtn(
            Icons.remove,
            () => cartProvider.updateQuantity(index, item.quantity - 1),
            isDark,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              item.quantity.toString(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: textColor,
              ),
            ),
          ),
          _buildQuantityBtn(
            Icons.add,
            () => cartProvider.updateQuantity(index, item.quantity + 1),
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onPressed, bool isDark) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    CartProvider cartProvider,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'المجموع الفرعي',
            cartProvider.subtotal,
            isDark,
            textColor,
            primaryColor,
          ),
          _buildSummaryRow(
            'الشحن',
            cartProvider.shipping,
            isDark,
            textColor,
            primaryColor,
          ),
          _buildSummaryRow(
            'الضريبة (15%)',
            cartProvider.tax,
            isDark,
            textColor,
            primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              color: isDark ? Colors.white10 : Colors.black12,
              thickness: 1,
            ),
          ),
          _buildSummaryRow(
            'المجموع النهائي',
            cartProvider.total,
            isDark,
            textColor,
            primaryColor,
            isTotal: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () => _proceedToCheckout(cartProvider, context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.payment_rounded, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'متابعة إلى الدفع',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    double amount,
    bool isDark,
    Color textColor,
    Color primaryColor, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'Tajawal',
              color: isTotal ? textColor : AppColors.getSubtextColor(isDark),
            ),
          ),
          Text(
            '\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 22 : 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: isTotal ? primaryColor : textColor,
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(CartProvider cartProvider, BuildContext context) {
    final cartController = CartController(context);

    if (cartProvider.cartItems.isEmpty) {
      cartController.showEmptyCartSnackBar();
      return;
    }
    Navigator.pushNamed(context, '/order-history');
  }
}




