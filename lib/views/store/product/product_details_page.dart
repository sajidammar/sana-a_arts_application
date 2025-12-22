import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/store/product_controller.dart';
import '../../../models/store/product_model.dart';
import '../../../providers/store/cart_provider.dart';
import '../../../themes/store/app_theme.dart';
import '../../../utils/store/app_constants.dart';
import '../../../providers/wishlist_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productController = ProductController(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProductImages(context),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).scaffoldBackgroundColor.withOpacity(0.7),
                child: BackButton(color: Theme.of(context).iconTheme.color),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withOpacity(0.7),
                  child: IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColor,
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
              _buildProductInfo(context),
              _buildProductSpecs(context),
              _buildProductDescription(context),
              _buildRelatedProducts(context),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomActions(
        cartProvider,
        productController,
        context,
      ),
    );
  }

  Widget _buildProductImages(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.getGradientDecoration(context),
          child: const Center(
            child: Icon(Icons.image, color: Colors.white, size: 80),
          ),
        ),
        Positioned(
          bottom: 16,
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
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      color: Theme.of(context).cardTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextColor(context),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800.withValues(alpha: 0.3)
                  : AppConstants.accentColor,
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.artist,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getTextColor(context),
                        ),
                      ),
                      Text(
                        'فنان تشكيلي متخصص في الفن التراثي',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.getSecondaryTextColor(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 1,
                  ),
                  child: Text('زيارة الصفحة'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: AppTheme.getCardDecoration(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '\$${widget.product.price}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (widget.product.discount > 0)
                      Text(
                        '\$${widget.product.originalPrice}',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.getSecondaryTextColor(context),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                if (widget.product.discount > 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'خصم ${widget.product.discount}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  'السعر شامل الضريبة، الشحن إضافي',
                  style: TextStyle(
                    color: AppTheme.getSecondaryTextColor(context),
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

  Widget _buildProductSpecs(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppConstants.defaultPadding),
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: AppTheme.getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Theme.of(context).primaryColor),
              SizedBox(width: 8),
              Text(
                'مواصفات العمل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getTextColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3,
            children: [
              _buildSpecItem('النوع:', widget.product.category, context),
              _buildSpecItem('الأبعاد:', widget.product.size, context),
              _buildSpecItem('المادة:', widget.product.medium, context),
              _buildSpecItem('سنة الإنتاج:', widget.product.year, context),
              _buildSpecItem('الحالة:', 'جديد - أصلي', context),
              _buildSpecItem('الإطار:', 'متضمن', context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800.withValues(alpha: 0.3)
            : AppConstants.accentColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppTheme.getSecondaryTextColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: AppTheme.getTextColor(context),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDescription(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppConstants.defaultPadding),
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      decoration: AppTheme.getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description, color: Theme.of(context).primaryColor),
              SizedBox(width: 8),
              Text(
                'وصف العمل',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getTextColor(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            widget.product.description,
            style: TextStyle(
              color: AppTheme.getSecondaryTextColor(context),
              fontSize: 16,
              height: 1.6,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أعمال مشابهة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.getTextColor(context),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildRelatedProductCard(
                  'لوحة الطبيعة الصامتة',
                  'محمد علي الحديدي',
                  320.0,
                  context,
                ),
                _buildRelatedProductCard(
                  'منظر طبيعي جبلي',
                  'سارة أحمد القادري',
                  280.0,
                  context,
                ),
                _buildRelatedProductCard(
                  'بورتريه تراثي',
                  'فاطمة علي الحكيمي',
                  380.0,
                  context,
                ),
                _buildRelatedProductCard(
                  'لوحة البحر والشاطئ',
                  'عبدالله محمد الزبيري',
                  420.0,
                  context,
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
  ) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      margin: EdgeInsets.only(right: 12),
      decoration: AppTheme.getCardDecoration(context),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: Container(
              decoration: AppTheme.getGradientDecoration(context).copyWith(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(Icons.image, color: Colors.white, size: 40),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.getTextColor(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  artist,
                  style: TextStyle(
                    color: AppTheme.getSecondaryTextColor(context),
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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
  ) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      Theme.of(context).dividerTheme.color ??
                      Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius,
                ),
              ),
              child: Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, child) {
                  final isFavorite = wishlistProvider.isInWishlist(
                    widget.product.id.toString(),
                  );
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Colors.red
                          : AppTheme.getTextColor(context),
                    ),
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
                          'type': 'product', // To distinguish types if needed
                        });
                      }
                    },
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    padding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      Theme.of(context).dividerTheme.color ??
                      Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius,
                ),
              ),
              child: IconButton(
                icon: Icon(Icons.share, color: AppTheme.getTextColor(context)),
                onPressed: () {},
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  cartProvider.addToCart(widget.product);
                  productController.showAddToCartSnackBar(widget.product);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultBorderRadius,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'إضافة إلى السلة',
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
