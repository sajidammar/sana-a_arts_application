import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/store/controllers/cart_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final cartProvider = Provider.of<CartProvider>(context);

    return AppBar(
      backgroundColor: AppColors.getCardColor(isDark),
      elevation: 2,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: AppColors.getPrimaryColor(isDark),
          size: 28,
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
                  color: isDark
                      ? const Color(0xFF2D2D2D)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.getPrimaryColor(
                      isDark,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  style: TextStyle(color: AppColors.getTextColor(isDark)),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن الأعمال الفنية...',
                    hintStyle: TextStyle(
                      color: AppColors.getSubtextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.getPrimaryColor(isDark),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
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
            color: AppColors.getPrimaryColor(isDark),
            size: 28,
          ),
          onPressed: onNotificationsPressed,
        ),
        IconButton(
          icon: Stack(
            children: [
              Icon(
                Icons.shopping_cart,
                color: AppColors.getPrimaryColor(isDark),
                size: 24,
              ),
              if (cartProvider.cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
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




