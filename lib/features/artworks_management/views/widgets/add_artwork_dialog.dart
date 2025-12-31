import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';

class AddArtworkDialog extends StatefulWidget {
  const AddArtworkDialog({super.key});

  @override
  State<AddArtworkDialog> createState() => _AddArtworkDialogState();
}

class _AddArtworkDialogState extends State<AddArtworkDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form Fields
  String? _category;
  String? _status = 'published';
  String? _exhibition;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Colors
    final backgroundColor = AppColors.getCardColor(isDark);
    final primaryColor = AppColors.primaryColor;
    final textColor = AppColors.getTextColor(isDark);

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Container(
          width: 800, // Max width for larger screens
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.sunsetGradient,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          'إضافة عمل فني جديد',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'شارك إبداعك مع العالم',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // File Upload Placeholder
                      _buildLabel('صورة العمل الفني', textColor),
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8860B).withValues(alpha: 0.05),
                          border: Border.all(
                            color: primaryColor,
                            style:
                                BorderStyle.solid, // Should be dashed ideally
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 40,
                                color: primaryColor,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'اضغط لاختيار الصورة أو اسحبها هنا',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'يدعم: JPG, PNG, GIF (الحد الأقصى: 10 ميجابايت)',
                                style: TextStyle(
                                  color: textColor.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      _buildLabel('عنوان العمل الفني', textColor),
                      _buildTextField('أدخل عنوان العمل الفني', isDark),

                      _buildLabel('وصف العمل الفني', textColor),
                      _buildTextField(
                        'اكتب وصفاً تفصيلياً عن العمل الفني...',
                        isDark,
                        maxLines: 4,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('فئة العمل الفني', textColor),
                                _buildDropdown(
                                  value: _category,
                                  items: const [
                                    'رسم زيتي',
                                    'ألوان مائية',
                                    'أكريليك',
                                    'فن رقمي',
                                    'نحت',
                                  ],
                                  hint: 'اختر الفئة',
                                  onChanged: (val) =>
                                      setState(() => _category = val),
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('أبعاد العمل الفني', textColor),
                                _buildTextField('مثال: 50×70 سم', isDark),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('السعر (ريال يمني)', textColor),
                                _buildTextField(
                                  'أدخل السعر (اختياري)',
                                  isDark,
                                  isNumber: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('حالة النشر', textColor),
                                _buildDropdown(
                                  value: _status,
                                  items: const [
                                    'published',
                                    'draft',
                                    'private',
                                  ],
                                  displayItems: const [
                                    'منشور (مرئي للجميع)',
                                    'مسودة (غير منشور)',
                                    'خاص (مرئي لك فقط)',
                                  ],
                                  hint: '',
                                  onChanged: (val) =>
                                      setState(() => _status = val),
                                  isDark: isDark,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      _buildLabel('الكلمات المفتاحية', textColor),
                      _buildTextField(
                        'فصل الكلمات بفاصلة: تراث، طبيعة، بورتريه',
                        isDark,
                      ),

                      _buildLabel('ربط بمعرض أو مسابقة (اختياري)', textColor),
                      _buildDropdown(
                        value: _exhibition,
                        items: const ['exh1', 'exh2'],
                        displayItems: const [
                          'معرض التراث اليمني',
                          'مسابقة الطبيعة اليمنية',
                        ],
                        hint: 'بدون ربط',
                        onChanged: (val) => setState(() => _exhibition = val),
                        isDark: isDark,
                      ),

                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            label: const Text(
                              'إلغاء',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle save
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تم حفظ العمل الفني بنجاح'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.save),
                            label: const Text(
                              'حفظ العمل الفني',
                              style: TextStyle(fontFamily: 'Tajawal'),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 15.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: 'Tajawal',
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    bool isDark, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey : Colors.grey[600],
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[800]! : const Color(0xFFF5E6D3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark ? Colors.grey[800]! : const Color(0xFFF5E6D3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFB8860B)),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    List<String>? displayItems,
    required String hint,
    required ValueChanged<String?> onChanged,
    required bool isDark,
  }) {
    // If displayItems is null, use items for display
    final labels = displayItems ?? items;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : const Color(0xFFF5E6D3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(
              color: isDark ? Colors.grey : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          items: List.generate(items.length, (index) {
            return DropdownMenuItem(
              value: items[index],
              child: Text(
                labels[index],
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontFamily: 'Tajawal',
                ),
              ),
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }
}





