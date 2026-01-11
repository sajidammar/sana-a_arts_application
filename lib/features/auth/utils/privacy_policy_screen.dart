import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ScrollController _scrollController = ScrollController();
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateProgress);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    setState(() {
      _progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFFFB300);
    final Color backgroundColor = const Color(0xFFFFF8E1);
    final Color textColor = Colors.brown[900]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'اتفاقية مستخدم فنون صنعاء',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: primaryColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20.0),
              children: [
                const Icon(Icons.gavel_rounded, size: 50, color: Color(0xFFFFB300)),
                const SizedBox(height: 15),
                Text(
                  'سياسة البيع والشراء المباشر',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                _buildPolicySection(
                  title: '1. آلية التوصيل المباشر',
                  icon: Icons.directions_run,
                  content:
                  'في "فنون صنعاء"، يلتزم الفنان (صاحب اللوحة) بتوصيل العمل الفني بنفسه إلى عنوان المشتري. تنتهي مسؤولية الفنان عند تسليم اللوحة وتوقيع المشتري على إشعار الاستلام داخل التطبيق.',
                  primaryColor: primaryColor,
                ),
                _buildPolicySection(
                  title: '2. نظام الوساطة المالية (Escrow)',
                  icon: Icons.verified_user_outlined,
                  content:
                  'لحماية الطرفين، يقوم المشتري بدفع الثمن للتطبيق أولاً. يتم الاحتفاظ بالمبلغ في خزنة التطبيق ولا يتم تحويله لمحفظة الفنان إلا بعد أن يؤكد المشتري استلام اللوحة يدوياً عبر الكود الخاص بالاستلام.',
                  primaryColor: primaryColor,
                ),
                _buildPolicySection(
                  title: '3. المعاينة وحق الرفض',
                  icon: Icons.visibility_outlined,
                  content:
                  'يحق للمشتري معاينة اللوحة عند وصول الفنان إليه. في حال تبين أن اللوحة لا تطابق المواصفات المعروضة، يحق للمشتري رفض الاستلام فوراً، وسيقوم التطبيق بإعادة كامل المبلغ لمحفظته دون أي استقطاعات.',
                  primaryColor: primaryColor,
                ),
                _buildPolicySection(
                  title: '4. عمولة المنصة',
                  icon: Icons.monetization_on_outlined,
                  content:
                  'يتقاضى تطبيق فنون صنعاء عمولة رمزية من قيمة الصفقة مقابل خدمات الوساطة التقنية وحماية الحقوق. تظهر هذه العمولة بوضوح للفنان قبل عرض اللوحة للبيع.',
                  primaryColor: primaryColor,
                ),
                _buildPolicySection(
                  title: '5. سياسة التواصل والأمان',
                  icon: Icons.chat_bubble_outline,
                  content:
                  'يجب أن تتم جميع المراسلات والاتفاقات عبر نظام الدردشة داخل التطبيق. التطبيق غير مسؤول عن أي اتفاقات تتم خارج المنصة، كما يمنع تبادل أرقام الهواتف الشخصية قبل إتمام عملية الدفع لضمان الأمان.',
                  primaryColor: primaryColor,
                ),
                _buildPolicySection(
                  title: '6. النزاعات والتحكيم',
                  icon: Icons.support_agent,
                  content:
                  'في حال نشوب خلاف بين الفنان والمشتري أثناء عملية التسليم، يقوم فريق الدعم الفني في فنون صنعاء بمراجعة سجلات الدردشة والصور لاتخاذ قرار نهائي ملزم للطرفين.',
                  primaryColor: primaryColor,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // الحاوية السفلية للزر
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'أوافق على شروط الوساطة',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicySection({
    required String title,
    required IconData icon,
    required String content,
    required Color primaryColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(content, style: const TextStyle(height: 1.5, fontSize: 13.5), textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}