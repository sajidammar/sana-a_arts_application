import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/store/product_controller.dart';
import '../../models/store/product_model.dart';
import '../../providers/store/cart_provider.dart';
import '../../providers/store/product_provider.dart';
import '../../providers/theme_provider.dart';
import '../../themes/app_colors.dart';
import '../../utils/store/app_constants.dart';
import 'cart/cart_page.dart';
import '../../providers/wishlist_provider.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      productProvider.loadProducts();
      Provider.of<WishlistProvider>(
        context,
        listen: false,
      ).loadWishlist(productProvider.products);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final primaryColor = AppColors.getPrimaryColor(isDark);
    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final cardColor = AppColors.getCardColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header removed as per global layout update
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchAndFilters(
                  productProvider,
                  context,
                  isDark,
                  primaryColor,
                  cardColor,
                ),
                _buildProductsGrid(
                  productProvider,
                  cartProvider,
                  context,
                  isDark,
                  textColor,
                  primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
        backgroundColor: primaryColor,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
              size: 28,
            ),
            if (cartProvider.cartItems.isNotEmpty)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '${cartProvider.cartItems.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeroSection(BuildContext context) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //
  //   return Container(
  //     height: 300,
  //     decoration: BoxDecoration(
  //       gradient: isDark
  //           ? LinearGradient(
  //         colors: [Color(0xFF2D2D2D), Color(0xFF404040), Color(0xFF5A5A5A)],
  //         begin: Alignment.topRight,
  //         end: Alignment.bottomLeft,
  //       )
  //           : LinearGradient(
  //         colors: [Color(0xFFFF6B35), Color(0xFFF7931E), Color(0xFFFFD700)],
  //         begin: Alignment.topRight,
  //         end: Alignment.bottomLeft,
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           'المتجر الفني',
  //           style: TextStyle(
  //             fontSize: 36,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.white,
  //           ),
  //         ),
  //         SizedBox(height: 8),
  //         Text(
  //           'اقتني أروع الأعمال الفنية',
  //           style: TextStyle(
  //             fontSize: 18,
  //             color: Colors.white,
  //           ),
  //         ),
  //         SizedBox(height: 16),
  //         Text(
  //           'تسوق أجمل الأعمال الفنية التشكيلية اليمنية الأصيلة',
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: Colors.white,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //         SizedBox(height: 24),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 foregroundColor: isDark ? Colors.black : AppConstants.primaryColor,
  //                 backgroundColor: Colors.white,
  //                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //               ),
  //               onPressed: () {},
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.shopping_bag),
  //                   SizedBox(width: 8),
  //                   Text('تسوق الآن'),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(width: 16),
  //             OutlinedButton(
  //               style: OutlinedButton.styleFrom(
  //                 side: BorderSide(color: Colors.white),
  //                 padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  //               ),
  //               onPressed: () {},
  //               child: Row(
  //                 children: [
  //                   Icon(Icons.auto_awesome, color: Colors.white),
  //                   SizedBox(width: 8),
  //                   Text('تجربة AR', style: TextStyle(color: Colors.white)),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSearchAndFilters(
    ProductProvider productProvider,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color cardColor,
  ) {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      color: isDark ? AppColors.darkBackground : AppColors.backgroundMain,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(productProvider.filters.length, (index) {
                final isSelected = productProvider.selectedFilter == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      productProvider.filters[index],
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        color: isSelected
                            ? Colors.white
                            : AppColors.getTextColor(isDark),
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      productProvider.filterProducts(index);
                    },
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.transparent
                            : (isDark
                                  ? Colors.white12
                                  : Colors.black.withValues(alpha: 0.05)),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(
    ProductProvider productProvider,
    CartProvider cartProvider,
    BuildContext context,
    bool isDark,
    Color textColor,
    Color primaryColor,
  ) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأعمال الفنية المتاحة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
              childAspectRatio: 0.85,
            ),
            itemCount: productProvider.filteredProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(
                productProvider.filteredProducts[index],
                cartProvider,
                context,
                isDark,
                primaryColor,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    Product product,
    CartProvider cartProvider,
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    final productController = ProductController(context);
    final cardColor = AppColors.getCardColor(isDark);
    final textColor = AppColors.getTextColor(isDark);
    final subtextColor = AppColors.getSubtextColor(isDark);

    return GestureDetector(
      onTap: () {
        productController.navigateToProductDetails(product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black45
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    product.image.isNotEmpty
                        ? Image.asset(
                            product.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.storeGradient,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    if (product.isNew || product.discount > 0)
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: product.discount > 0
                                ? Colors.red
                                : primaryColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            product.discount > 0
                                ? 'خصم ${product.discount}%'
                                : 'جديد',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Consumer<WishlistProvider>(
                        builder: (context, wishlistProvider, child) {
                          final isFavorite = wishlistProvider.isInWishlist(
                            product.id.toString(),
                          );
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                                size: 22,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (isFavorite) {
                                  wishlistProvider.removeFromWishlist(
                                    product.id.toString(),
                                  );
                                } else {
                                  wishlistProvider.addToWishlist({
                                    'id': product.id.toString(),
                                    'title': product.title,
                                    'subtitle': product.artist,
                                    'price': product.price,
                                    'image': product.image,
                                    'type': 'product',
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Tajawal',
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.artist,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 13,
                        fontFamily: 'Tajawal',
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.discount > 0)
                              Text(
                                '\$${product.originalPrice.toStringAsFixed(0)}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: subtextColor.withValues(alpha: 0.5),
                                  fontSize: 12,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontFamily: 'Tajawal',
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            cartProvider.addToCart(product);
                            productController.showAddToCartSnackBar(product);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.add_shopping_cart_rounded, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'أضف للسلة',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

