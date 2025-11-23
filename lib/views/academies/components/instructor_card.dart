// views/components/instructor_card.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/models/academy/instructor.dart';

class InstructorCard extends StatelessWidget {
  final Instructor instructor;
  final bool isHorizontal;

  const InstructorCard({
    super.key,
    required this.instructor,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      // ✅ تصميم للعرض الأفقي
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المدرب
            Container(
              // height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(instructor.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // معلومات المدرب
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // الاسم والتخصص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instructor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          instructor.specialties.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D4E37),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // التقييم والخبرة
                    Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFFD700),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              instructor.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5D4E37),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${instructor.experience} سنوات',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB8860B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // عدد الورش
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5E6D3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${instructor.workshops} ورشة',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF5D4E37),
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
      );
    } else {
      // ✅ تصميم للعرض العمودي (إذا كنت تحتاجه في أماكن أخرى)
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // صورة المدرب
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: NetworkImage(instructor.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // معلومات المدرب
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    instructor.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C1810),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    instructor.specialties as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5D4E37),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD700),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        instructor.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D4E37),
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
  }
}
