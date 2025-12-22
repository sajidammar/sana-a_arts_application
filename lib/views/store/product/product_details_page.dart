import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/store/product_controller.dart';
import '../../../models/store/product_model.dart';
import '../../../providers/store/cart_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/app_colors.dart';

import '../../../providers/wishlist_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final productController = ProductController(context);

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
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProductImages(context, isDark, primaryColor),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: cardColor.withValues(alpha: 0.7),
                child: BackButton(color: primaryColor),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: cardColor.withValues(alpha: 0.7),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                ),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildProductInfo(
                context,
                isDark,
                primaryColor,
                textColor,
                cardColor,
              ),
              _buildProductSpecs(
                context,
                isDark,
                primaryColor,
                textColor,
                cardColor,
              ),
              _buildProductDescription(
                context,
                isDark,
                primaryColor,
                textColor,
                cardColor,
              ),
              _buildRelatedProducts(
                context,
                isDark,
                primaryColor,
                textColor,
                cardColor,
              ),
              const SizedBox(height: 100), // Reserve space for bottom bar
            ]),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(
        cartProvider,
        productController,
        context,
        isDark,
        primaryColor,
        textColor,
        cardColor,
      ),
      extendBody: true,
    );
  }

  Widget _buildProductImages(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.storeGradient),
          child: const Center(
            child: Icon(Icons.palette_outlined, color: Colors.white, size: 80),
          ),
        ),
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _selectedImageIndex == index
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (_selectedImageIndex == index)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    final subtextColor = AppColors.getSubtextColor(isDark);
    final fieldColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withValues(alpha: 0.05);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.03),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor.withValues(alpha: 0.15),
                  radius: 25,
                  child: Icon(
                    Icons.person_outline,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.artist,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Text(
                        'فنان تشكيلي محترف',
                        style: TextStyle(
                          fontSize: 13,
                          color: subtextColor,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'زيارة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                '\$${widget.product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Tajawal',
                ),
              ),
              const SizedBox(width: 12),
              if (widget.product.discount > 0) ...[
                Text(
                  '\$${widget.product.originalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    color: subtextColor,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Tajawal',
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${widget.product.discount}% خصم',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'السعر شامل الضريبة، الشحن حسب المنطقة',
            style: TextStyle(
              color: subtextColor,
              fontSize: 12,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSpecs(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'مواصفات العمل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: [
              _buildSpecItem(
                'النوع',
                widget.product.category,
                context,
                isDark,
                primaryColor,
                textColor,
              ),
              _buildSpecItem(
                'الأبعاد',
                widget.product.size,
                context,
                isDark,
                primaryColor,
                textColor,
              ),
              _buildSpecItem(
                'المادة',
                widget.product.medium,
                context,
                isDark,
                primaryColor,
                textColor,
              ),
              _buildSpecItem(
                'السنة',
                widget.product.year,
                context,
                isDark,
                primaryColor,
                textColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(
    String label,
    String value,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    final fieldColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.grey.withValues(alpha: 0.03);
    final subtextColor = AppColors.getSubtextColor(isDark);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: subtextColor,
              fontSize: 11,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes_rounded, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'وصف العمل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description,
            style: TextStyle(
              color: AppColors.getSubtextColor(isDark),
              fontSize: 15,
              height: 1.7,
              fontFamily: 'Tajawal',
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'أعمال مشابهة',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                _buildRelatedProductCard(
                  'لوحة الطبيعة الصامتة',
                  'محمد علي الحديدي',
                  320,
                  context,
                  isDark,
                  primaryColor,
                  textColor,
                  cardColor,
                ),
                _buildRelatedProductCard(
                  'منظر طبيعي جبلي',
                  'سارة أحمد القادري',
                  280,
                  context,
                  isDark,
                  primaryColor,
                  textColor,
                  cardColor,
                ),
                _buildRelatedProductCard(
                  'بورتريه تراثي',
                  'فاطمة علي الحكيمي',
                  380,
                  context,
                  isDark,
                  primaryColor,
                  textColor,
                  cardColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProductCard(
    String title,
    String artist,
    double price,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black12
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.storeGradient,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.palette_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Tajawal',
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  artist,
                  style: TextStyle(
                    color: AppColors.getSubtextColor(isDark),
                    fontSize: 11,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    CartProvider cartProvider,
    ProductController productController,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.share_rounded,
            onPressed: () {},
            isDark: isDark,
            primaryColor: primaryColor,
            textColor: textColor,
          ),
          const SizedBox(width: 12),
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isFavorite = wishlistProvider.isInWishlist(
                widget.product.id.toString(),
              );
              return _buildActionButton(
                icon: isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: isFavorite ? Colors.redAccent : null,
                onPressed: () {
                  if (isFavorite) {
                    wishlistProvider.removeFromWishlist(
                      widget.product.id.toString(),
                    );
                  } else {
                    wishlistProvider.addToWishlist({
                      'id': widget.product.id.toString(),
                      'title': widget.product.title,
                      'subtitle': widget.product.artist,
                      'price': widget.product.price,
                      'image': widget.product.image,
                      'type': 'product',
                    });
                  }
                },
                isDark: isDark,
                primaryColor: primaryColor,
                textColor: textColor,
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                cartProvider.addToCart(widget.product);
                productController.showAddToCartSnackBar(widget.product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart_outlined, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'إضافة للسلة',
                    style: TextStyle(
                      fontSize: 16,
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

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    required Color primaryColor,
    required Color textColor,
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: color ?? textColor.withValues(alpha: 0.8),
          size: 22,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

