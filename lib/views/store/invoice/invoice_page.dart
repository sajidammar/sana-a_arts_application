import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/store/invoice_controller.dart';
import '../../../models/store/invoice_model.dart';
import '../../../providers/store/invoice_provider.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final invoiceController = InvoiceController(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
        title: Text(
          'الفاتورة',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.print, color: Theme.of(context).primaryColor),
            onPressed: invoiceController.printInvoice,
            tooltip: 'طباعة الفاتورة',
          ),
          IconButton(
            icon: Icon(Icons.download, color: Theme.of(context).primaryColor),
            onPressed: invoiceController.downloadInvoice,
            tooltip: 'تحميل الفاتورة',
          ),
          IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).primaryColor),
            onPressed: invoiceController.shareInvoice,
            tooltip: 'مشاركة الفاتورة',
          ),
        ],
      ),
      body: invoiceProvider.currentInvoice == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'جاري تحميل الفاتورة...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInvoiceHeader(context),
                  SizedBox(height: 24),
                  _buildInvoiceInfo(invoiceProvider.currentInvoice!, context),
                  SizedBox(height: 24),
                  _buildOrderItems(invoiceProvider.currentInvoice!, context),
                  SizedBox(height: 24),
                  _buildTotals(invoiceProvider.currentInvoice!, context),
                  SizedBox(height: 16),
                  _buildFooter(context),
                ],
              ),
            ),
    );
  }

  Widget _buildInvoiceHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.9),
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long, size: 48, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'فـــاتــورة',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'منصة فنون صنعاء التشكيلية',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceInfo(Invoice invoice, BuildContext context) {
    return Column(
      children: [
        // معلومات الشركة والفاتورة
        _buildInfoCard(
          context,
          title: 'معلومات الشركة',
          icon: Icons.business,
          children: [
            _buildInfoItem('الاسم:', 'فنون صنعاء التشكيلية', context),
            _buildInfoItem('العنوان:', 'صنعاء، الجمهورية اليمنية', context),
            _buildInfoItem('الهاتف:', '+967 1 234567', context),
            _buildInfoItem('البريد:', 'info@sanaafineart.com', context),
            _buildInfoItem('الموقع:', 'www.sanaafineart.com', context),
          ],
        ),
        SizedBox(height: 16),
        _buildInfoCard(
          context,
          title: 'معلومات الفاتورة',
          icon: Icons.description,
          children: [
            _buildInfoItem('رقم الفاتورة:', invoice.id, context),
            _buildInfoItem('رقم الطلب:', invoice.orderId, context),
            _buildInfoItem('تاريخ الفاتورة:', '10 يناير 2024', context),
            _buildInfoItem('تاريخ الاستحقاق:', '17 يناير 2024', context),
            _buildStatusBadge('تم التسليم', Colors.green, context),
          ],
        ),
        SizedBox(height: 16),
        // معلومات العميل
        _buildInfoCard(
          context,
          title: 'معلومات العميل',
          icon: Icons.person,
          children: [
            _buildInfoItem('الاسم:', invoice.customer.name, context),
            _buildInfoItem('البريد:', invoice.customer.email, context),
            _buildInfoItem('الهاتف:', invoice.customer.phone, context),
            Divider(height: 24),
            _buildInfoItem('المدينة:', invoice.customer.city, context),
            _buildInfoItem('البلد:', invoice.customer.country, context),
            _buildInfoItem('العنوان:', invoice.customer.address, context),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ملاحظة: يُرجى الاتصال قبل التسليم',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: color, size: 14),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(Invoice invoice, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.shopping_bag,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'تفاصيل الطلب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...invoice.items.map((item) => _buildOrderItem(item, context)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(InvoiceItem item, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800.withValues(alpha: 0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? Colors.grey.shade300,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  Theme.of(context).primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          // تفاصيل المنتج
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuantityBadge(item.quantity, context),
                    // Spacer removed
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'السعر: \$${item.price}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'المجموع: \$${item.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityBadge(int quantity, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 14,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 4),
          Text(
            'الكمية: $quantity',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals(Invoice invoice, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'ملخص الفاتورة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTotalItem('المجموع الفرعي', invoice.subtotal, context),
          _buildTotalItem(
            'خصم العضوية (5%)',
            -invoice.discount,
            context,
            isDiscount: true,
          ),
          _buildTotalItem('الشحن والتوصيل', invoice.shipping, context),
          _buildTotalItem('التأمين', 15.0, context),
          _buildTotalItem('الضريبة (15%)', invoice.tax, context),
          Divider(height: 24),
          _buildTotalItem(
            'المجموع الإجمالي',
            invoice.total,
            context,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(
    String label,
    double amount,
    BuildContext context, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isDiscount
                  ? Colors.green
                  : (isTotal
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.celebration,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 12),
          Text(
            'شكراً لاختيارك منصة فنون صنعاء',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'نقدر ثقتك بنا ونسعى دائماً لتقديم الأفضل\nللاستفسارات: info@sanaafineart.com',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
