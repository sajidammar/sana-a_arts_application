// views/components/workshop_card.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/academy/workshop.dart';

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
    if (isHorizontal) {
      // ✅ تصميم للعرض الأفقي
      return GestureDetector(
        onTap: () {
          // ✅ إضافة functionality هنا عند الضغط على الورشة
          _showWorkshopDetails(context, workshop);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
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
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(workshop.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
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
                          color: _getLevelColor(workshop.level),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          workshop.level,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C1810),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // الوصف
                      Text(
                        workshop.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5D4E37),
                          height: 1.4,
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB8860B),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, 
                                      color: Color(0xFFFFD700), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    workshop.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5D4E37),
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
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(workshop.imageUrl!),
                  fit: BoxFit.cover,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C1810),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB8860B),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, 
                              color: Color(0xFFFFD700), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            workshop.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5D4E37),
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
    // ✅ عرض تفاصيل الورشة (يمكن استبدالها بالتنقل لشاشة التفاصيل)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(workshop.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workshop.description),
            const SizedBox(height: 16),
            Text('المستوى: ${workshop.level}'),
            Text('السعر: ${workshop.price} ر.س'),
            Text('التقييم: ${workshop.rating}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // إضافة logic للتسجيل هنا
            },
            child: const Text('التسجيل في الورشة'),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'مبتدئ':
        return const Color(0xFF28a745);
      case 'متوسط':
        return const Color(0xFFffc107);
      case 'متقدم':
        return const Color(0xFFdc3545);
      default:
        return const Color(0xFFB8860B);
    }
  }
}