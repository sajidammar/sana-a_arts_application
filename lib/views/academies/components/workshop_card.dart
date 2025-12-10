// views/components/workshop_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/models/academy/workshop.dart';
import 'package:sanaa_artl/themes/academy/colors.dart';
import '../../../providers/theme_provider.dart';

class WorkshopCard extends StatelessWidget {
  final Workshop workshop;
  final bool isHorizontal;

  const WorkshopCard({
    super.key,
    required this.workshop,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    if (isHorizontal) {
      // ✅ تصميم للعرض الأفقي
      return GestureDetector(
        onTap: () {
          _showWorkshopDetails(context, workshop);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الورشة
              Container(
                height: 160,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        workshop.image,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                            child: Icon(
                              Icons.image_not_supported,
                              color: isDark ? Colors.grey[600] : Colors.grey,
                            ),
                          );
                        },
                      ),
                      // مستوى الصعوبة
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getLevelColor(workshop.level),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            workshop.level,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // معلومات الورشة
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // العنوان
                      Text(
                        workshop.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF2C1810),
                          height: 1.3,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // الوصف
                      Text(
                        workshop.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? Colors.grey[400]
                              : const Color(0xFF5D4E37),
                          height: 1.4,
                          fontFamily: 'Tajawal',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // السعر والتقييم والتفاصيل
                      Column(
                        children: [
                          // السعر والتقييم
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${workshop.price} ر.س',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? const Color(0xFFD4AF37)
                                      : const Color(0xFFB8860B),
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Color(0xFFFFD700),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    workshop.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.grey[300]
                                          : const Color(0xFF5D4E37),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // زر التسجيل
                          Container(
                            width: double.infinity,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark
                                    ? [
                                        const Color(0xFFD4AF37),
                                        const Color(0xFFB8860B),
                                      ]
                                    : [
                                        const Color(0xFFFFD700),
                                        const Color(0xFFB8860B),
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'سجل الآن',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
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
      );
    } else {
      // ✅ تصميم للعرض العمودي (إذا كنت تحتاجه في أماكن أخرى)
      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الورشة
            Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.asset(
                  workshop.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      child: Icon(
                        Icons.image_not_supported,
                        color: isDark ? Colors.grey[600] : Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workshop.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF2C1810),
                      fontFamily: 'Tajawal',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${workshop.price} ر.س',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFFB8860B),
                          fontFamily: 'Tajawal',
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFD700),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            workshop.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? Colors.grey[300]
                                  : const Color(0xFF5D4E37),
                              fontFamily: 'Tajawal',
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
  }

  void _showWorkshopDetails(BuildContext context, Workshop workshop) {
    // ✅ عرض تفاصيل الورشة
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        title: Text(
          workshop.title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontFamily: 'Tajawal',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workshop.description,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.black87,
                fontFamily: 'Tajawal',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'المستوى: ${workshop.level}',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              'السعر: ${workshop.price} ر.س',
              style: TextStyle(
                color: isDark
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFFB8860B),
                fontFamily: 'Tajawal',
              ),
            ),
            Text(
              'التقييم: ${workshop.rating}',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق', style: TextStyle(fontFamily: 'Tajawal')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFFB8860B),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              // إضافة logic للتسجيل هنا
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال طلب التسجيل بنجاح')),
              );
            },
            child: const Text(
              'التسجيل في الورشة',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }
}
