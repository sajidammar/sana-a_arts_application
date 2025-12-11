import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class ExhibitionRequestDialog extends StatefulWidget {
  const ExhibitionRequestDialog({super.key});

  @override
  State<ExhibitionRequestDialog> createState() =>
      _ExhibitionRequestDialogState();
}

class _ExhibitionRequestDialogState extends State<ExhibitionRequestDialog> {
  // Mock artworks selection
  final List<String> _selectedArtworks = [];
  final List<Map<String, dynamic>> _availableArtworks = [
    {'id': '1', 'title': 'غروب صنعاء', 'image': 'assets/images/image1.jpg'},
    {'id': '2', 'title': 'تراث يمني', 'image': 'assets/images/image2.jpg'},
    {
      'id': '4',
      'title': 'طبيعة حضرموت',
      'image': 'assets/images/image.jpg',
    }, // Using placeholder names
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final backgroundColor = isDark ? const Color(0xFF2C2C2C) : Colors.white;
    final primaryColor = const Color(0xFFB8860B);
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Container(
          width: 800,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8B4513),
                      Color(0xFFD2691E),
                      Color(0xFFDEB887),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
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
                          'طلب معرض افتراضي',
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
                      'أنشئ معرضك الخاص لعرض أعمالك',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField('اسم المعرض', isDark),
                    const SizedBox(height: 15),
                    _buildTextField('وصف المعرض', isDark, maxLines: 3),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            'تاريخ البداية المقترح',
                            isDark,
                            icon: Icons.calendar_today,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildTextField(
                            'تاريخ النهاية المقترح',
                            isDark,
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'اختيار الأعمال الفنية (الحد الأدنى 10 أعمال)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: _availableArtworks.length,
                        itemBuilder: (context, index) {
                          final item = _availableArtworks[index];
                          final isSelected = _selectedArtworks.contains(
                            item['id'],
                          );
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedArtworks.add(item['id']);
                                } else {
                                  _selectedArtworks.remove(item['id']);
                                }
                              });
                            },
                            title: Text(
                              item['title'],
                              style: TextStyle(
                                color: textColor,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                            secondary: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey,
                              child: const Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildTextField('ملاحظات إضافية', isDark, maxLines: 2),
                    const SizedBox(height: 25),

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
                            // Handle submission
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تم تقديم طلب المعرض بنجاح'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.send),
                          label: const Text(
                            'تقديم الطلب',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    bool isDark, {
    int maxLines = 1,
    IconData? icon,
  }) {
    return TextFormField(
      maxLines: maxLines,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: isDark ? Colors.grey : Colors.grey[600]),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
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
      ),
    );
  }
}
