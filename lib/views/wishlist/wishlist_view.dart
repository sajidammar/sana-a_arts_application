import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../themes/app_colors.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subtextColor = AppColors.getSubtextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'المفضلة',
              style: TextStyle(
                color: primaryColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: cardColor,
            foregroundColor: primaryColor,
            elevation: 0,
            pinned: true,
            actions: [
              if (wishlistProvider.itemCount > 0)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: 'مسح الكل',
                  onPressed: () {
                    _showClearDialog(
                      context,
                      isDark,
                      primaryColor,
                      wishlistProvider,
                    );
                  },
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black26
                        : Colors.black.withValues(alpha: 0.03),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_rounded,
                      color: primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${wishlistProvider.itemCount} ${wishlistProvider.itemCount == 1 ? 'عنصر' : 'عناصر'} تم حفظها',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          wishlistProvider.itemCount == 0
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyWishlist(
                    context,
                    isDark,
                    primaryColor,
                    textColor,
                    subtextColor,
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = wishlistProvider.wishlistItems[index];
                      return _buildWishlistItem(
                        context,
                        item,
                        isDark,
                        primaryColor,
                        textColor,
                        subtextColor,
                        cardColor,
                        wishlistProvider,
                      );
                    }, childCount: wishlistProvider.itemCount),
                  ),
                ),
        ],
      ),
    );
  }

  void _showClearDialog(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    WishlistProvider wishlistProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardColor(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'حذف الكل',
          style: TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'هل تريد حذف جميع العناصر من المفضلة؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(fontFamily: 'Tajawal'),
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.getSubtextColor(isDark),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    wishlistProvider.clearWishlist();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'تم حذف جميع العناصر',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                        backgroundColor: primaryColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'حذف الكل',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWishlist(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color subtextColor,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 80,
                color: primaryColor.withValues(alpha: 0.2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'المفضلة فارغة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ابدأ بإضافة المعارض والأعمال الفنية التي تنال إعجابك للوصول إليها لاحقاً بسهولة',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Tajawal',
                color: subtextColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
              ),
              child: const Text(
                'اكتشف الآن',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color subtextColor,
    Color cardColor,
    WishlistProvider wishlistProvider,
  ) {
    final type = item['type'] ?? 'product';
    final isExhibition = type == 'exhibition';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate based on type if needed
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: AppColors.storeGradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    isExhibition
                        ? Icons.museum_outlined
                        : Icons.palette_outlined,
                    size: 35,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isExhibition ? 'معرض' : 'عمل فني',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['title'] ?? 'بدون عنوان',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['subtitle'] ??
                            item['artist'] ??
                            item['description'] ??
                            '',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Tajawal',
                          color: subtextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (item['price'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '\$${item['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.redAccent,
                    size: 22,
                  ),
                  onPressed: () {
                    wishlistProvider.removeFromWishlist(item['id']);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'تمت الإزالة من المفضلة',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        width: 200,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
