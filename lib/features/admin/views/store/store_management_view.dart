import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/admin_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class StoreManagementView extends StatelessWidget {
  final bool isDark;
  const StoreManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final products = adminProvider.storeProducts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: adminProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppColors.getPrimaryColor(isDark),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallStat(
                          context,
                          'إجمالي المنتجات',
                          '${products.length}',
                          Icons.inventory_2,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallStat(
                          context,
                          'المبيعات اليوم',
                          '5',
                          Icons.insights,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.getCardColor(isDark),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.getPrimaryColor(
                            isDark,
                          ).withValues(alpha: 0.1),
                        ),
                      ),
                      child: products.isEmpty
                          ? Center(
                              child: Text(
                                'لا توجد منتجات',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: AppColors.getSubtextColor(isDark),
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: products.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ListTile(
                                  title: Text(
                                    product.productName,
                                    style: TextStyle(
                                      color: AppColors.getTextColor(isDark),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  subtitle: Text(
                                    'السعر: ${product.price}\$ - المخزون: ${product.stock}',
                                    style: const TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      if (product.id != null) {
                                        adminProvider.deleteProduct(
                                          product.id!,
                                        );
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: AppColors.getPrimaryColor(isDark),
        foregroundColor: isDark ? Colors.black : Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSmallStat(
    BuildContext context,
    String title,
    String val,
    IconData icon,
    Color color,
  ) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.getTextColor(isDark),
              fontFamily: 'Tajawal',
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Tajawal',
              color: AppColors.getSubtextColor(isDark),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'إضافة منتج جديد',
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'اسم المنتج'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'السعر'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'المخزون'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text) ?? 0.0;
              final stock = int.tryParse(stockController.text) ?? 0;
              Provider.of<AdminProvider>(
                context,
                listen: false,
              ).addStoreProduct(nameController.text, price, stock, 'لوحات');
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
