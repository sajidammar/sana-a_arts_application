import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wishlist_provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: AppBar(
        title: Text(
          'المفضلة',
          style: TextStyle(
            color: themeProvider.isDarkMode
                ? const Color(0xFFD4AF37)
                : const Color(0xFFB8860B),
            fontFamily: 'Tajawal',
          ),
        ),
        backgroundColor: themeProvider.isDarkMode
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        foregroundColor: themeProvider.isDarkMode
            ? const Color(0xFFD4AF37)
            : const Color(0xFFB8860B),
        elevation: 2,
        actions: [
          if (wishlistProvider.itemCount > 0)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'حذف الكل',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    content: const Text(
                      'هل تريد حذف جميع العناصر من المفضلة؟',
                      style: TextStyle(fontFamily: 'Tajawal'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'إلغاء',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          wishlistProvider.clearWishlist();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم حذف جميع العناصر'),
                            ),
                          );
                        },
                        child: const Text(
                          'حذف',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: themeProvider.isDarkMode
                ? const Color(0xFF1E1E1E)
                : Colors.grey[50],
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: themeProvider.isDarkMode
                      ? const Color(0xFFD4AF37)
                      : const Color(0xFFB8860B),
                ),
                const SizedBox(width: 8),
                Text(
                  '${wishlistProvider.itemCount} ${wishlistProvider.itemCount == 1 ? 'عنصر' : 'عناصر'} في المفضلة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: themeProvider.isDarkMode
                        ? Colors.white
                        : const Color(0xFF2C1810),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: wishlistProvider.itemCount == 0
                ? _buildEmptyWishlist(context, themeProvider.isDarkMode)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: wishlistProvider.itemCount,
                    itemBuilder: (context, index) {
                      final item = wishlistProvider.wishlistItems[index];
                      return _buildWishlistItem(
                        context,
                        item,
                        themeProvider.isDarkMode,
                        wishlistProvider,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: isDarkMode
                ? const Color(0xFFD4AF37).withOpacity(0.3)
                : const Color(0xFFB8860B).withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'المفضلة فارغة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: isDarkMode ? Colors.white : const Color(0xFF2C1810),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'لم تقم بإضافة أي معرض أو عمل فني بعد',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Tajawal',
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDarkMode,
    WishlistProvider wishlistProvider,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item['type'] == 'exhibition' ? Icons.museum : Icons.art_track,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? 'عنوان غير متوفر',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF2C1810),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['artist'] ?? item['description'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item['price'] != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${item['price']} ريال',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B35),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                wishlistProvider.removeFromWishlist(item['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إزالة العنصر من المفضلة'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
