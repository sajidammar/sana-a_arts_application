import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/store/invoice_controller.dart';
import '../../../models/store/invoice_model.dart';
import '../../../providers/store/invoice_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../themes/academy/colors.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);
    final invoiceController = InvoiceController(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

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
            elevation: 0,
            floating: true,
            snap: true,
            pinned: true,
            title: Text(
              'الفاتورة',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Tajawal',
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: primaryColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.print_rounded, color: primaryColor),
                onPressed: invoiceController.printInvoice,
                tooltip: 'طباعة الفاتورة',
              ),
              IconButton(
                icon: Icon(Icons.download_rounded, color: primaryColor),
                onPressed: invoiceController.downloadInvoice,
                tooltip: 'تحميل الفاتورة',
              ),
              IconButton(
                icon: Icon(Icons.share_rounded, color: primaryColor),
                onPressed: invoiceController.shareInvoice,
                tooltip: 'مشاركة الفاتورة',
              ),
            ],
          ),
          invoiceProvider.currentInvoice == null
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'جاري تحميل الفاتورة...',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildInvoiceHeader(context, isDark, primaryColor),
                      const SizedBox(height: 24),
                      _buildInvoiceInfo(
                        invoiceProvider.currentInvoice!,
                        context,
                        isDark,
                        primaryColor,
                        textColor,
                        cardColor,
                      ),
                      const SizedBox(height: 24),
                      _buildOrderItems(
                        invoiceProvider.currentInvoice!,
                        context,
                        isDark,
                        primaryColor,
                        textColor,
                        cardColor,
                      ),
                      const SizedBox(height: 24),
                      _buildTotals(
                        invoiceProvider.currentInvoice!,
                        context,
                        isDark,
                        primaryColor,
                        textColor,
                        cardColor,
                      ),
                      const SizedBox(height: 24),
                      _buildFooter(context, isDark, primaryColor, textColor),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader(
    BuildContext context,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        gradient: AppColors.storeGradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'فـــاتــورة',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Tajawal',
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'منصة فنون صنعاء التشكيلية',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceInfo(
    Invoice invoice,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Column(
      children: [
        _buildInfoCard(
          context,
          title: 'معلومات الشركة',
          icon: Icons.business_rounded,
          isDark: isDark,
          primaryColor: primaryColor,
          textColor: textColor,
          cardColor: cardColor,
          children: [
            _buildInfoItem('الاسم:', 'فنون صنعاء التشكيلية', isDark, textColor),
            _buildInfoItem(
              'العنوان:',
              'صنعاء، الجمهورية اليمنية',
              isDark,
              textColor,
            ),
            _buildInfoItem('الهاتف:', '+967 1 234567', isDark, textColor),
            _buildInfoItem(
              'البريد:',
              'info@sanaafineart.com',
              isDark,
              textColor,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          title: 'معلومات الفاتورة',
          icon: Icons.description_rounded,
          isDark: isDark,
          primaryColor: primaryColor,
          textColor: textColor,
          cardColor: cardColor,
          children: [
            _buildInfoItem('رقم الفاتورة:', invoice.id, isDark, textColor),
            _buildInfoItem('رقم الطلب:', invoice.orderId, isDark, textColor),
            _buildInfoItem(
              'تاريخ الفاتورة:',
              '10 يناير 2024',
              isDark,
              textColor,
            ),
            const SizedBox(height: 12),
            _buildStatusBadge('تم التسليم', Colors.green, isDark),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          title: 'معلومات العميل',
          icon: Icons.person_rounded,
          isDark: isDark,
          primaryColor: primaryColor,
          textColor: textColor,
          cardColor: cardColor,
          children: [
            _buildInfoItem('الاسم:', invoice.customer.name, isDark, textColor),
            _buildInfoItem(
              'البريد:',
              invoice.customer.email,
              isDark,
              textColor,
            ),
            _buildInfoItem(
              'العنوان:',
              '${invoice.customer.city}, ${invoice.customer.country}',
              isDark,
              textColor,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(thickness: 0.5),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: primaryColor,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'ملاحظة: يُرجى الاتصال قبل التسليم',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w500,
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
    required bool isDark,
    required Color primaryColor,
    required Color textColor,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: textColor,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 0.5),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    String label,
    String value,
    bool isDark,
    Color textColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.getSubtextColor(isDark),
                fontSize: 14,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems(
    Invoice invoice,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Icon(Icons.shopping_bag_rounded, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'تفاصيل الطلب',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: textColor,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 0.5),
          ),
          ...invoice.items.map(
            (item) =>
                _buildOrderItem(item, context, isDark, primaryColor, textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(
    InvoiceItem item,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    final subtextColor = AppColors.getSubtextColor(isDark);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                gradient: AppColors.storeGradient,
              ),
              child: const Icon(
                Icons.palette_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Tajawal',
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.description,
                  style: TextStyle(
                    color: subtextColor,
                    fontSize: 12,
                    fontFamily: 'Tajawal',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'x${item.quantity}',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    Text(
                      '\$${item.total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 16,
                        fontFamily: 'Tajawal',
                      ),
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

  Widget _buildTotals(
    Invoice invoice,
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
    Color cardColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
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
        children: [
          Row(
            children: [
              Icon(Icons.calculate_rounded, color: primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'ملخص الفاتورة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Tajawal',
                  color: textColor,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 0.5),
          ),
          _buildTotalItem(
            'المجموع الفرعي',
            invoice.subtotal,
            isDark,
            textColor,
            primaryColor,
          ),
          _buildTotalItem(
            'خصم العضوية (5%)',
            -invoice.discount,
            isDark,
            textColor,
            primaryColor,
            isDiscount: true,
          ),
          _buildTotalItem(
            'الشحن والتوصيل',
            invoice.shipping,
            isDark,
            textColor,
            primaryColor,
          ),
          _buildTotalItem(
            'الضريبة (15%)',
            invoice.tax,
            isDark,
            textColor,
            primaryColor,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 1),
          ),
          _buildTotalItem(
            'المجموع الإجمالي',
            invoice.total,
            isDark,
            textColor,
            primaryColor,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(
    String label,
    double amount,
    bool isDark,
    Color textColor,
    Color primaryColor, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontFamily: 'Tajawal',
              color: isTotal ? textColor : AppColors.getSubtextColor(isDark),
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}\$${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: isTotal ? 22 : 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: isDiscount
                  ? Colors.green
                  : (isTotal ? primaryColor : textColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    bool isDark,
    Color primaryColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_rounded, size: 36, color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'شكراً لاختيارك منصة فنون صنعاء',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'نقدر ثقتك بنا ونسعى دائماً لتقديم الأفضل\nللاستفسارات: info@sanaafineart.com',
            style: TextStyle(
              color: AppColors.getSubtextColor(isDark),
              fontSize: 14,
              fontFamily: 'Tajawal',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
