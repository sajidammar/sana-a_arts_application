import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../themes/app_colors.dart';
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

    final backgroundColor = AppColors.getBackgroundColor(isDark);
    final primaryColor = AppColors.getPrimaryColor(isDark);
    final textColor = AppColors.getTextColor(isDark);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            floating: true,
            snap: true,
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
                  backgroundColor: AppColors.exhibitionColor.withValues(
                    alpha: 0.2,
                  ),
                  child: Icon(Icons.palette, color: AppColors.exhibitionColor),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildBreadcrumb(isDark, primaryColor, textColor),
                const SizedBox(height: 24),
                _buildQuickActions(isDark, primaryColor),
                const SizedBox(height: 32),
                const StatsOverview(),
                const SizedBox(height: 32),
                _buildFilterSection(isDark, primaryColor, textColor),
                const SizedBox(height: 24),
              ]),
            ),
          ),
          _buildExhibitionsSliverList(isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: _getFilteredExhibitions().isEmpty
                  ? _buildEmptyState(textColor, primaryColor, isDark)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExhibitionsSliverList(bool isDark) {
    final filtered = _getFilteredExhibitions();
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: MyExhibitionCard(data: filtered[index], isDark: isDark),
          );
        }, childCount: filtered.length),
      ),
    );
  }

  Widget _buildBreadcrumb(bool isDark, Color primaryColor, Color textColor) {
    final subtextColor = AppColors.getSubtextColor(isDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'الرئيسية',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
        Icon(
          Icons.chevron_left,
          size: 14,
          color: subtextColor.withValues(alpha: 0.5),
        ),
        Text(
          'الملف الشخصي',
          style: TextStyle(
            color: primaryColor,
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
        Icon(
          Icons.chevron_left,
          size: 14,
          color: subtextColor.withValues(alpha: 0.5),
        ),
        Text(
          'معارضي',
          style: TextStyle(
            color: subtextColor,
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(bool isDark, Color primaryColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 900
            ? 4
            : (constraints.maxWidth > 600 ? 2 : 1);
        double width =
            (constraints.maxWidth - ((crossAxisCount - 1) * 16)) /
            crossAxisCount;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
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
    final surfaceColor = AppColors.getCardColor(isDark);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black.withValues(alpha: 0.05),
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
          const SizedBox(height: 20),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(
              color: textColor,
              fontFamily: 'Tajawal',
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'البحث في معارضي...',
              hintStyle: TextStyle(
                color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.5),
                fontFamily: 'Tajawal',
                fontSize: 14,
              ),
              prefixIcon: Icon(Icons.search, color: primaryColor, size: 20),
              filled: true,
              fillColor: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.backgroundSecondary.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, FilterType type, bool isDark) {
    final isSelected = _selectedFilter == type;

    // Gradient for active tab
    final activeDecoration = BoxDecoration(
      gradient: AppColors.exhibitionGradient,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: AppColors.exhibitionColor.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final inactiveDecoration = BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
    );

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected ? activeDecoration : inactiveDecoration,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Colors.white
                : AppColors.getSubtextColor(isDark),
            fontSize: 14,
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
            ex['status'] != ExhibitionStatus.active) {
          return false;
        }
        if (_selectedFilter == FilterType.upcoming &&
            ex['status'] != ExhibitionStatus.upcoming) {
          return false;
        }
        if (_selectedFilter == FilterType.completed &&
            ex['status'] != ExhibitionStatus.completed) {
          return false;
        }
        if (_selectedFilter == FilterType.draft &&
            ex['status'] != ExhibitionStatus.draft) {
          return false;
        }
      }

      // Filter by Search
      if (_searchQuery.isNotEmpty) {
        final title = ex['title'].toString().toLowerCase();
        final loc = ex['location'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !loc.contains(query)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  Widget _buildEmptyState(Color textColor, Color primaryColor, bool isDark) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : AppColors.backgroundSecondary.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.palette_outlined,
              size: 80,
              color: AppColors.getSubtextColor(isDark).withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد معارض',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ابدأ رحلتك بإنشاء معرض جديد',
            style: TextStyle(
              color: AppColors.getSubtextColor(isDark),
              fontFamily: 'Tajawal',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text(
              'إنشاء معرض جديد',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: isDark ? Colors.black : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              shadowColor: primaryColor.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
