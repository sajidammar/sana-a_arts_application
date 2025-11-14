import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onWishlistPressed;
  final VoidCallback onNotificationsPressed;

  const CustomAppBar({
    Key? key,
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onWishlistPressed,
    required this.onNotificationsPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
      ],
    );
  }
}