import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/store/product_controller.dart';
import '../../models/store/product_model.dart';
import '../../providers/store/cart_provider.dart';
import '../../providers/store/product_provider.dart';
import '../../themes/store/app_theme.dart';
import '../../utils/store/app_constants.dart';



class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int _cartCount = 0;

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
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      //   elevation: 1,
      //   title: Row(
      //     children: [
      //       Icon(Icons.palette, color: Theme.of(context).primaryColor),
      //       SizedBox(width: 8),
      //       Text('المتجر', style: TextStyle(
      //         color: Theme.of(context).primaryColor,
      //         fontWeight: FontWeight.bold,
      //         fontSize: 20,
      //       )),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Stack(
      //         children: [
      //           Icon(Icons.shopping_cart, color: Theme.of(context).primaryColor),
      //           if (cartProvider.cartItems.isNotEmpty)
      //             Positioned(
      //               right: 0,
      //               top: 0,
      //               child: Container(
      //                 padding: EdgeInsets.all(2),
      //                 decoration: BoxDecoration(
      //                   color: Colors.red,
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //                 constraints: BoxConstraints(
      //                   minWidth: 16,
      //                   minHeight: 16,
      //                 ),
      //                 child: Text(
      //                   '${cartProvider.cartItems.length}',
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 10,
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //             ),
      //         ],
      //       ),
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/cart');
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.settings, color: Theme.of(context).primaryColor),
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/settings');
      //       },
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // _buildHeroSection(context),
            _buildSearchAndFilters(productProvider, context),
            _buildProductsGrid(productProvider, cartProvider, context),
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

  Widget _buildSearchAndFilters(ProductProvider productProvider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'ابحث عن لوحة أو فنان...',
              prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Color(0xFF2D2D2D)
                  : Colors.white,
              hintStyle: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade500
                    : Colors.grey.shade600,
              ),
            ),
            style: TextStyle(
              color: AppTheme.getTextColor(context),
            ),
          ),
          SizedBox(height: 16),
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
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
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

  Widget _buildProductsGrid(ProductProvider productProvider, CartProvider cartProvider, BuildContext context) {
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
              childAspectRatio: 0.99,
            ),
            itemCount: productProvider.filteredProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(productProvider.filteredProducts[index], cartProvider, context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product, CartProvider cartProvider, BuildContext context) {
    final productController = ProductController(context);
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        productController.navigateToProductDetails(product);
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Theme.of(context).cardTheme.color,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: AppTheme.getGradientDecoration(context),
                child: Center(
                  child: Icon(Icons.image, color: Colors.white, size: 40),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.getTextColor(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.artist,
                      style: TextStyle(
                        color: AppTheme.getSecondaryTextColor(context),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        color: AppTheme.getSecondaryTextColor(context),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Text(
                              '${product.rating}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.getTextColor(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        cartProvider.addToCart(product);
                        productController.showAddToCartSnackBar(product);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                        minimumSize: Size(double.infinity, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 16),
                          SizedBox(width: 4),
                          Text('أضف للسلة'),
                        ],
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