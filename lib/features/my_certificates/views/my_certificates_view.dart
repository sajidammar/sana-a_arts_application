import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'widgets/certificates_stats_grid.dart';
import 'widgets/achievements_section.dart';
import 'widgets/certificate_card.dart';
import 'certificate_enums.dart';

class MyCertificatesView extends StatefulWidget {
  const MyCertificatesView({super.key});

  @override
  State<MyCertificatesView> createState() => _MyCertificatesViewState();
}

class _MyCertificatesViewState extends State<MyCertificatesView> {
  // State
  CertificateFilter _selectedFilter = CertificateFilter.all;
  String _searchQuery = '';
  String _sortBy = 'newest';

  // Mock Data
  final List<Map<String, dynamic>> _certificates = [
    {
      'id': '1',
      'title': "أساسيات الرسم بالألوان الزيتية",
      'institution': "معهد فنون صنعاء التشكيلية",
      'type': "شهادة إتمام دورة",
      'status': CertificateStatus.completed,
      'date': "15 ديسمبر 2024",
      'duration': "40 ساعة",
      'instructor': "أحمد المحضار",
      'grade': "ممتاز (95%)",
      'isVerified': true,
    },
    {
      'id': '2',
      'title': "فن الخط العربي المتقدم",
      'institution': "أكاديمية الخط العربي",
      'type': "شهادة تخصص",
      'status': CertificateStatus.completed,
      'date': "28 نوفمبر 2024",
      'duration': "60 ساعة",
      'instructor': "عبدالله البيضاني",
      'grade': "جيد جداً (88%)",
      'isVerified': true,
    },
    {
      'id': '3',
      'title': "التصوير الفوتوغرافي الاحترافي",
      'institution': "استوديو الإبداع المرئي",
      'type': "دورة قيد التقدم",
      'status': CertificateStatus.inProgress,
      'startDate': "1 ديسمبر 2024",
      'progress': 0.75,
      'instructor': "سارة العولقي",
    },
    {
      'id': '4',
      'title': "ورشة النحت على الطين",
      'institution': "مركز التراث الفني",
      'type': "شهادة مشاركة",
      'status': CertificateStatus.completed,
      'date': "10 أكتوبر 2024",
      'duration': "16 ساعة",
      'instructor': "محمد الهادي",
      'grade': "جيد (85%)",
      'isVerified': true,
    },
    {
      'id': '5',
      'title': "تقنيات الرسم الرقمي",
      'institution': "معهد التصميم الرقمي",
      'type': "في انتظار التقييم",
      'status': CertificateStatus.pending,
      'endDate': "5 ديسمبر 2024",
      'duration': "32 ساعة",
      'instructor': "رنا العسالي",
    },
    {
      'id': '6',
      'title': "تاريخ الفن اليمني",
      'institution': "جامعة الفنون التطبيقية",
      'type': "دورة قيد التقدم",
      'status': CertificateStatus.inProgress,
      'startDate': "20 نوفمبر 2024",
      'progress': 0.45,
      'instructor': "د. فاطمة الزبيدي",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

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
              'الشهادات والإنجازات',
              style: TextStyle(
                color: textColor,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.learningGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.workspace_premium, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildBreadcrumb(isDark, primaryColor, textColor),
                const SizedBox(height: 30),
                const CertificatesStatsGrid(),
                const SizedBox(height: 30),
                const AchievementsSection(),
                const SizedBox(height: 30),
                _buildFilterSection(isDark, primaryColor, textColor),
                const SizedBox(height: 20),
              ]),
            ),
          ),
          _buildCertificatesSliverList(isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: _getSortedAndFilteredCertificates().isEmpty
                  ? _buildEmptyState(context, textColor, primaryColor)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificatesSliverList(bool isDark) {
    final filtered = _getSortedAndFilteredCertificates();
    if (filtered.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: CertificateCard(data: filtered[index], isDark: isDark),
          );
        }, childCount: filtered.length),
      ),
    );
  }

  Widget _buildBreadcrumb(bool isDark, Color primaryColor, Color textColor) {
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
          size: 16,
          color: isDark ? Colors.grey : Colors.grey[600],
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
          size: 16,
          color: isDark ? Colors.grey : Colors.grey[600],
        ),
        Text(
          'الشهادات',
          style: TextStyle(
            color: AppColors.getSubtextColor(isDark),
            fontFamily: 'Tajawal',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(bool isDark, Color primaryColor, Color textColor) {
    final surfaceColor = AppColors.getCardColor(isDark);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
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
                _buildFilterTab('جميع الشهادات', CertificateFilter.all, isDark),
                _buildFilterTab('مكتملة', CertificateFilter.completed, isDark),
                _buildFilterTab(
                  'قيد التقدم',
                  CertificateFilter.inProgress,
                  isDark,
                ),
                _buildFilterTab(
                  'في الانتظار',
                  CertificateFilter.pending,
                  isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: textColor, fontFamily: 'Tajawal'),
                  decoration: InputDecoration(
                    hintText: 'البحث في الشهادات...',
                    hintStyle: TextStyle(
                      color: AppColors.getSubtextColor(isDark),
                      fontFamily: 'Tajawal',
                    ),
                    prefixIcon: Icon(Icons.search, color: primaryColor),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.backgroundSecondary.withValues(alpha: 0.5),
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
              ),
              const SizedBox(width: 10),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColors.getPrimaryColor(
                        isDark,
                      ).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _sortBy,
                    dropdownColor: surfaceColor,
                    icon: Icon(Icons.sort, color: primaryColor),
                    items: const [
                      DropdownMenuItem(
                        value: 'newest',
                        child: Text(
                          'الأحدث',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'oldest',
                        child: Text(
                          'الأقدم',
                          style: TextStyle(fontFamily: 'Tajawal', fontSize: 13),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _sortBy = v!),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, CertificateFilter type, bool isDark) {
    final isSelected = _selectedFilter == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = type),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.learningGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
            color: isSelected
                ? Colors.white
                : AppColors.getSubtextColor(isDark),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getSortedAndFilteredCertificates() {
    var filtered = _certificates.where((cert) {
      if (_selectedFilter == CertificateFilter.completed &&
          cert['status'] != CertificateStatus.completed) {
        return false;
      }
      if (_selectedFilter == CertificateFilter.inProgress &&
          cert['status'] != CertificateStatus.inProgress) {
        return false;
      }
      if (_selectedFilter == CertificateFilter.pending &&
          cert['status'] != CertificateStatus.pending) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final title = cert['title'].toString().toLowerCase();
        final inst = cert['institution'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !inst.contains(query)) return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      if (_sortBy == 'newest') {
        return int.parse(b['id']).compareTo(int.parse(a['id']));
      } else {
        return int.parse(a['id']).compareTo(int.parse(b['id']));
      }
    });

    return filtered;
  }

  Widget _buildEmptyState(
    BuildContext context,
    Color textColor,
    Color primaryColor,
  ) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: textColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 15),
          Text(
            'لا توجد شهادات',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('الانتقال إلى دليل الدورات... (محاكاة)'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'تصفح الدورات',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




