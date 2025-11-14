import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';
import 'exhibition_card.dart';

class FeaturedExhibitions extends StatelessWidget {
  const FeaturedExhibitions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أبرز المعارض الجديدة',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xFF2C1810),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 350,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ExhibitionCard(
                title: 'معرض التراث اليمني',
                description: 'أجمل اللوحات المستوحاة من التراث اليمني الأصيل',
                imageUrl: '',
              ),
              const SizedBox(width: 16),
              ExhibitionCard(
                title: 'فنون معاصرة',
                description: 'أعمال فنية معاصرة تجمع بين الأصالة والحداثة',
                imageUrl: '',
              ),
              const SizedBox(width: 16),
              ExhibitionCard(
                title: 'مناظر طبيعية',
                description: 'استكشف جمال الطبيعة اليمنية عبر ريشة الفنانين',
                imageUrl: '',
              ),
              const SizedBox(width: 16),
              ExhibitionCard(
                title: 'بورتريهات',
                description: 'صور شخصية تعبر عن هوية المجتمع اليمني',
                imageUrl: '',
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أبرز الدورات ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkMode
                  ? Colors.white
                  : const Color(0xFF2C1810),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 350,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              ExhibitionCard(
                title: 'معرض التراث اليمني',
                description: 'أجمل اللوحات المستوحاة من التراث اليمني الأصيل',
                imageUrl: '',
              ),
              const SizedBox(width: 16),
              ExhibitionCard(
                title: 'فنون معاصرة',
                description: 'أعمال فنية معاصرة تجمع بين الأصالة والحداثة',
                imageUrl: '',
              ),
              const SizedBox(width: 16),
              ExhibitionCard(
                title: 'مناظر طبيعية',
                description: 'استكشف جمال الطبيعة اليمنية عبر ريشة الفنانين',
                imageUrl: '',
              ),
              const SizedBox(width: 16),
              ExhibitionCard(
                title: 'بورتريهات',
                description: 'صور شخصية تعبر عن هوية المجتمع اليمني',
                imageUrl: '',
              ),
            ],
          ),
        ),
      ],
    );
  }
}