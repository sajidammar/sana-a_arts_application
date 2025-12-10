// views/components/quick_nav.dart
import 'package:flutter/material.dart';
import 'package:sanaa_artl/views/academies/quick_access_pages.dart';
import 'package:sanaa_artl/views/academies/components/section_title.dart';

import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class QuickNavigationSection extends StatelessWidget {
  const QuickNavigationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(32),
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionTitle(
            title: 'الوصول السريع',
            description: 'تصفح الخدمات والوظائف الرئيسية بسرعة وسهولة',
            isDark: isDark,
          ),
          const SizedBox(height: 32),

          // ✅ القائمة الأفقية للوصول السريع
          SizedBox(
            height: 140, // ارتفاع ثابت للقائمة الأفقية
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final navItem = _navItems[index];
                return Container(
                  width: 160, // عرض ثابت لكل عنصر
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 12,
                    right: index == _navItems.length - 1 ? 0 : 12,
                  ),
                  child: QuickNavCard(
                    title: navItem.title,
                    description: navItem.description,
                    icon: navItem.icon,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuickNavCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isDark;

  const QuickNavCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ✅ إضافة functionality هنا عند الضغط على العنصر
        handleNavigation(context, title);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5E6D3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // الأيقونة
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFFD4AF37), const Color(0xFFB8860B)]
                      : [const Color(0xFFFFD700), const Color(0xFFB8860B)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),

            // العنوان
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFFD4AF37)
                      : const Color(0xFFB8860B),
                  height: 1.2,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),

            // الوصف
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[400] : const Color(0xFF5D4E37),
                  height: 1.2,
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void handleNavigation(BuildContext context, String title) {
    // ✅ إضافة التنقل حسب العنصر
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericQuickAccessPage(
          title: title,
          description: _getDescriptionForTitle(title),
          icon: _getIconForTitle(title),
        ),
      ),
    );
  }

  static String _getDescriptionForTitle(String title) {
    final item = _navItems.firstWhere(
      (element) => element.title == title,
      orElse: () => const NavItem(
        title: '',
        description: 'صفحة تفاصيل',
        icon: Icons.info,
      ),
    );
    return item.description;
  }

  static IconData _getIconForTitle(String title) {
    final item = _navItems.firstWhere(
      (element) => element.title == title,
      orElse: () => const NavItem(title: '', description: '', icon: Icons.info),
    );
    return item.icon;
  }
}

class NavItem {
  final String title;
  final String description;
  final IconData icon;

  const NavItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

final List<NavItem> _navItems = [
  const NavItem(
    title: 'التسجيل في ورشة',
    description: 'سجل في الورش المتاحة',
    icon: Icons.person_add,
  ),
  const NavItem(
    title: 'ورشي التدريبية',
    description: 'متابعة تقدمك وإنجازاتك',
    icon: Icons.school,
  ),
  const NavItem(
    title: 'المدربين',
    description: 'تعرف على خبراء الفنون',
    icon: Icons.people,
  ),
  const NavItem(
    title: 'الجدول الزمني',
    description: 'مواعيد الورش والفعاليات',
    icon: Icons.calendar_today,
  ),
  const NavItem(
    title: 'الشهادات',
    description: 'عرض وتحميل شهاداتك',
    icon: Icons.verified,
  ),
  const NavItem(
    title: 'التقييمات',
    description: 'آراء وتجارب المتدربين',
    icon: Icons.star,
  ),
  const NavItem(
    title: 'الدفع والتسعير',
    description: 'خيارات دفع متنوعة',
    icon: Icons.payment,
  ),
  const NavItem(
    title: 'المسابقات',
    description: 'شارك في مسابقات فنية',
    icon: Icons.emoji_events,
  ),
];
