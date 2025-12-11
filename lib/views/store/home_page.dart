import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/store/product_controller.dart';
import '../../models/store/product_model.dart';
import '../../providers/store/cart_provider.dart';
import '../../providers/store/product_provider.dart';
import '../../themes/store/app_theme.dart';
import '../../utils/store/app_constants.dart';
import 'cart/cart_page.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header removed as per global layout update
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchAndFilters(productProvider, context),
                _buildProductsGrid(productProvider, cartProvider, context),
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
        backgroundColor: Theme.of(context).primaryColor,
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
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
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
  ) {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          // TextField(
          //   decoration: InputDecoration(
          //     hintText: 'ابحث عن لوحة أو فنان...',
          //     prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     filled: true,
          //     fillColor: Theme.of(context).brightness == Brightness.dark
          //         ? Color(0xFF2D2D2D)
          //         : Colors.white,
          //     hintStyle: TextStyle(
          //       color: Theme.of(context).brightness == Brightness.dark
          //           ? Colors.grey.shade500
          //           : Colors.grey.shade600,
          //     ),
          //   ),
          //   style: TextStyle(
          //     color: AppTheme.getTextColor(context),
          //   ),
          // ),
          // SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(productProvider.filters.length, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(
                      productProvider.filters[index],
                      style: TextStyle(
                        color: productProvider.selectedFilter == index
                            ? Colors.white
                            : AppTheme.getTextColor(context),
                      ),
                    ),
                    selected: productProvider.selectedFilter == index,
                    onSelected: (bool selected) {
                      productProvider.filterProducts(index);
                    },
                    selectedColor: Theme.of(context).primaryColor,
                    checkmarkColor: Colors.white,
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? Color(0xFF2D2D2D)
                        : Colors.grey.shade200,
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
  ) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الأعمال الفنية المتاحة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextColor(context),
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 22,
              childAspectRatio: 0.85,
            ),
            itemCount: productProvider.filteredProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(
                productProvider.filteredProducts[index],
                cartProvider,
                context,
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
  ) {
    final productController = ProductController(context);
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        productController.navigateToProductDetails(product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color, // Using card theme color
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Important for fitting
            children: [
              // Image Section
              SizedBox(
                height: 200, // Reduced height slightly
                width: double.infinity,
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
                            decoration: AppTheme.getGradientDecoration(context),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                    if (product.isNew || product.discount > 0)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: product.discount > 0
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.discount > 0
                                ? 'خصم ${product.discount}%'
                                : 'جديد',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11, // Reduced font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Restored font size
                        color: AppTheme.getTextColor(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.artist,
                      style: TextStyle(
                        color: AppTheme.getSecondaryTextColor(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Removed Description to save space as per user request implicit context of overflow
                    // Or keep it but very short
                    Text(
                      product.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.discount > 0)
                              Text(
                                '\$${product.originalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            Text(
                              '\$${product.price}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${product.rating}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.getTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          cartProvider.addToCart(product);
                          productController.showAddToCartSnackBar(product);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.shopping_cart_outlined, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'أضف للسلة',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
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
