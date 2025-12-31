import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/management_provider.dart';
import 'package:sanaa_artl/management/themes/management_colors.dart';

class StoreManagementView extends StatelessWidget {
  final bool isDark;
  const StoreManagementView({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ManagementProvider>(context);
    final products = provider.storeProducts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallStat(
                          'إجمالي المنتجات',
                          '${products.length}',
                          Icons.inventory,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildSmallStat(
                          'المبيعات اليوم',
                          '5',
                          Icons.sell,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      color: ManagementColors.getCard(isDark),
                      child: products.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد منتجات',
                                style: TextStyle(fontFamily: 'Tajawal'),
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
                                      color: ManagementColors.getText(isDark),
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
                                        provider.deleteProduct(product.id!);
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
        backgroundColor: ManagementColors.getPrimary(isDark),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSmallStat(String title, String val, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 5),
            Text(
              val,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontFamily: 'Tajawal'),
            ),
          ],
        ),
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
              Provider.of<ManagementProvider>(
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



