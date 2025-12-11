import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'widgets/quick_action_card.dart';
import 'widgets/stats_overview.dart';
import 'widgets/my_exhibition_card.dart';

// Enums
enum ExhibitionStatus { active, upcoming, completed, draft }

enum FilterType { all, active, upcoming, completed, draft }

class MyExhibitionsView extends StatefulWidget {
  const MyExhibitionsView({super.key});

  @override
  State<MyExhibitionsView> createState() => _MyExhibitionsViewState();
}

class _MyExhibitionsViewState extends State<MyExhibitionsView> {
  // State
  FilterType _selectedFilter = FilterType.all;
  String _searchQuery = '';

  // Mock Data
  final List<Map<String, dynamic>> _exhibitions = [
    {
      'id': '1',
      'title': "معرض التراث اليمني الأصيل",
      'location': "قاعة التراث - صنعاء القديمة",
      'image': "assets/images/exhibition1.jpg", // Placeholder
      'status': ExhibitionStatus.active,
      'startDate': "1 ديسمبر 2024",
      'endDate': "31 ديسمبر 2024",
      'remainingDays': 25,
      'artworksCount': 15,
      'visitors': 456,
      'soldCount': 3,
    },
    {
      'id': '2',
      'title': "معرض الرسم الحديث والمعاصر",
      'location': "مركز الفنون الحديثة - صنعاء",
      'image': "assets/images/exhibition2.jpg",
      'status': ExhibitionStatus.upcoming,
      'startDate': "15 يناير 2025",
      'endDate': "15 فبراير 2025",
      'remainingTime': "40 يوم",
      'preparedArtworks': 12,
      'visitors': 0,
      'requests': 5,
    },
    {
      'id': '3',
      'title': "معرض فن الألوان المائية",
      'location': "جمعية الفنانين التشكيليين",
      'image': "assets/images/exhibition3.jpg",
      'status': ExhibitionStatus.completed,
      'startDate': "1 أكتوبر 2024",
      'endDate': "31 أكتوبر 2024",
      'duration': "30 يوم",
      'artworksCount': 18,
      'visitors': 678,
      'soldCount': 5,
    },
    {
      'id': '4',
      'title': "معرض الفن الرقمي والتكنولوجيا",
      'location': "مركز التكنولوجيا الحديثة",
      'image': "assets/images/exhibition4.jpg",
      'status': ExhibitionStatus.draft,
      'plannedStartDate': "1 مارس 2025",
      'plannedEndDate': "30 مارس 2025",
      'progress': 0.6,
      'preparedArtworks': 8,
      'visitors': 0,
      'soldCount': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFFDF6E3);
    final primaryColor = const Color(0xFFB8860B);
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: primaryColor),
        title: Text(
          'معارضي الفنية',
          style: TextStyle(
            color: textColor,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: const Color(
                0xFFFECFEF,
              ), // From CSS --gradient-exhibitions approx
              child: const Icon(Icons.palette, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header / Breadcrumbs Mock
            _buildBreadcrumb(isDark, primaryColor, textColor),

            const SizedBox(height: 20),

            // Quick Actions
            _buildQuickActions(isDark),

            const SizedBox(height: 30),

            // Stats Overview
            const StatsOverview(),

            const SizedBox(height: 30),

            // Filters and Search
            _buildFilterSection(isDark, primaryColor, textColor),

            const SizedBox(height: 20),

            // List
            _buildExhibitionsList(isDark),

            const SizedBox(height: 40),

            // Empty State (Logic handled inside list builder if empty, but here separately if full list empty)
            if (_getFilteredExhibitions().isEmpty)
              _buildEmptyState(textColor, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(bool isDark, Color primaryColor, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'الرئيسية',
          style: TextStyle(color: primaryColor, fontFamily: 'Tajawal'),
        ),
        Icon(
          Icons.chevron_left,
          size: 16,
          color: isDark ? Colors.grey : Colors.grey[600],
        ),
        Text(
          'الملف الشخصي',
          style: TextStyle(color: primaryColor, fontFamily: 'Tajawal'),
        ),
        Icon(
          Icons.chevron_left,
          size: 16,
          color: isDark ? Colors.grey : Colors.grey[600],
        ),
        Text(
          'معارضي',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : const Color(0xFF5D4E37),
            fontFamily: 'Tajawal',
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 900
            ? 4
            : (constraints.maxWidth > 600 ? 2 : 1);
        double width =
            (constraints.maxWidth - ((crossAxisCount - 1) * 15)) /
            crossAxisCount;

        return Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            SizedBox(
              width: width,
              child: QuickActionCard(
                title: 'إنشاء معرض جديد',
                description: 'ابدأ في تنظيم معرض فني جديد لأعمالك',
                icon: Icons.add,
                onTap: () {},
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: width,
              child: QuickActionCard(
                title: 'ترشح لمعرض',
                description: 'قدم أعمالك للمشاركة في المعارض الجماعية',
                icon: Icons.upload,
                onTap: () {},
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: width,
              child: QuickActionCard(
                title: 'إدارة الأعمال',
                description: 'أضف أو عدل أعمالك الفنية المعروضة',
                icon: Icons.palette,
                onTap: () {},
                isDark: isDark,
              ),
            ),
            SizedBox(
              width: width,
              child: QuickActionCard(
                title: 'إحصائيات المعارض',
                description: 'تابع أداء معارضك وتفاعل الزوار',
                icon: Icons.show_chart,
                onTap: () {},
                isDark: isDark,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterSection(bool isDark, Color primaryColor, Color textColor) {
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B4513).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterTab('جميع المعارض', FilterType.all, isDark),
                _buildFilterTab('نشطة', FilterType.active, isDark),
                _buildFilterTab('قادمة', FilterType.upcoming, isDark),
                _buildFilterTab('مكتملة', FilterType.completed, isDark),
                _buildFilterTab('مسودات', FilterType.draft, isDark),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(color: textColor, fontFamily: 'Tajawal'),
            decoration: InputDecoration(
              hintText: 'البحث في معارضي...',
              hintStyle: TextStyle(
                color: textColor.withOpacity(0.5),
                fontFamily: 'Tajawal',
              ),
              prefixIcon: const Icon(Icons.search, color: Color(0xFFB8860B)),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFF5E6D3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, FilterType type, bool isDark) {
    final isSelected = _selectedFilter == type;
    final primaryColor = const Color(0xFFB8860B);

    // Gradient for active tab
    final activeDecoration = BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFFff9a9e),
          Color(0xFFfecfef),
        ], // Approx --gradient-exhibitions
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(15),
    );

    final inactiveDecoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
    );

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = type),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: isSelected ? activeDecoration : inactiveDecoration,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.grey[400] : const Color(0xFF5D4E37)),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredExhibitions() {
    return _exhibitions.where((ex) {
      // Filter by Type
      if (_selectedFilter != FilterType.all) {
        if (_selectedFilter == FilterType.active &&
            ex['status'] != ExhibitionStatus.active)
          return false;
        if (_selectedFilter == FilterType.upcoming &&
            ex['status'] != ExhibitionStatus.upcoming)
          return false;
        if (_selectedFilter == FilterType.completed &&
            ex['status'] != ExhibitionStatus.completed)
          return false;
        if (_selectedFilter == FilterType.draft &&
            ex['status'] != ExhibitionStatus.draft)
          return false;
      }

      // Filter by Search
      if (_searchQuery.isNotEmpty) {
        final title = ex['title'].toString().toLowerCase();
        final loc = ex['location'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !loc.contains(query)) return false;
      }

      return true;
    }).toList();
  }

  Widget _buildExhibitionsList(bool isDark) {
    final filtered = _getFilteredExhibitions();
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return MyExhibitionCard(data: filtered[index], isDark: isDark);
      },
    );
  }

  Widget _buildEmptyState(Color textColor, Color primaryColor) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.palette_outlined,
            size: 80,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          Text(
            'لا توجد معارض',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ابدأ رحلتك بإنشاء معرض جديد',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text(
              'إنشاء معرض جديد',
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
