import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/store/cart_provider.dart';
import '../../../providers/store/product_provider.dart';
import '../../../providers/theme_provider.dart';



class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onWishlistPressed;
  final VoidCallback onNotificationsPressed;

  const CustomAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onWishlistPressed,
    required this.onNotificationsPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return AppBar(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF1E1E1E)
          : Colors.white,
      elevation: 2,
      leading: IconButton(
        icon: Icon(
            Icons.menu,
            color: themeProvider.isDarkMode
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
            size: 28
        ),
        onPressed: onMenuPressed,
      ),
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? const Color(0xFF2D2D2D)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: themeProvider.isDarkMode
                        ? const Color(0xFFD4AF37)
                        : const Color(0xFFB8860B),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن الأعمال الفنية...',
                    hintStyle: TextStyle(
                      color: themeProvider.isDarkMode
                          ? const Color(0xFFB0B0B0)
                          : const Color(0xFF666666),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: themeProvider.isDarkMode
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFFB8860B),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  onTap: onSearchPressed,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
              Icons.notifications_none,
              color: themeProvider.isDarkMode
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFFB8860B),
              size: 28
          ),
          onPressed: onNotificationsPressed,
        ),
        IconButton(
          icon: Icon(
              Icons.favorite_border,
              color: themeProvider.isDarkMode
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFFB8860B),
              size: 28
          ),
          onPressed: onWishlistPressed,
        ),
        IconButton(
          icon: Stack(
            children: [
              Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor),
              if (cartProvider.cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ],
    );
  }
}