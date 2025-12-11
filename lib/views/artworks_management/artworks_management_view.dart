import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// If AppColors doesn't exist, I will use direct colors or Theme.
// User's HTML had specific colors. I will try to match them using the ThemeProvider if possible.

import '../../../providers/theme_provider.dart';
import 'widgets/management_stats_card.dart';
import 'widgets/exhibition_request_banner.dart';
import 'widgets/management_artwork_card.dart';
import 'widgets/add_artwork_dialog.dart';
import 'widgets/exhibition_request_dialog.dart';

// Enum for filtering
enum ArtworkStatus { published, draft, private }

enum ArtworkCategory { oilPainting, watercolor, acrylic, digital, mixed, all }

class ArtworksManagementView extends StatefulWidget {
  const ArtworksManagementView({super.key});

  @override
  State<ArtworksManagementView> createState() => _ArtworksManagementViewState();
}

class _ArtworksManagementViewState extends State<ArtworksManagementView> {
  // Filters
  ArtworkStatus? _selectedStatus; // null means 'all'
  String _searchQuery = '';
  ArtworkCategory _selectedCategory = ArtworkCategory.all;

  // Sort
  String _sortBy = 'newest'; // newest, oldest, most_viewed, most_liked, alpha

  // Mock Data (Replace with Provider/Backend later)
  List<Map<String, dynamic>> _artworks = [
    {
      'id': '1',
      'title': "غروب صنعاء",
      'description': "لوحة زيتية تصور جمال غروب الشمس فوق صنعاء القديمة",
      'category': ArtworkCategory.oilPainting,
      'status': ArtworkStatus.published,
      'image': "assets/images/image1.jpg", // Placeholder
      'views': 245,
      'likes': 89,
      'price': 150000.0,
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '2',
      'title': "تراث يمني",
      'description': "عمل فني يجسد التراث اليمني الأصيل",
      'category': ArtworkCategory.watercolor,
      'status': ArtworkStatus.published,
      'image': "assets/images/image2.jpg",
      'views': 312,
      'likes': 156,
      'price': null,
      'date': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': '3',
      'title': "وجوه من اليمن",
      'description': "بورتريه لشخصيات يمنية",
      'category': ArtworkCategory
          .all, // Using 'all' as placeholder for Charcoal if not in enum yet
      'status': ArtworkStatus.draft,
      'image': "assets/images/image3.jpg",
      'views': 189,
      'likes': 67,
      'price': 80000.0,
      'date': DateTime.now().subtract(const Duration(days: 8)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Custom Colors matching user request but adapted to Theme
    final primaryColor = const Color(0xFFB8860B);
    final backgroundColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFFDF6E3);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2C1810);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: surfaceColor,
            elevation: 0,
            floating: true,
            snap: true,
            iconTheme: IconThemeData(color: primaryColor),
            title: Row(
              children: [
                Icon(Icons.palette, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  'إدارة الأعمال الفنية',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildPageHeader(isDark, textColor, primaryColor),
                  const SizedBox(height: 20),
                  _buildStatsGrid(isDark),
                  const SizedBox(height: 20),
                  ExhibitionRequestBanner(
                    onTap: () => _showExhibitionRequestModal(context),
                  ),
                  const SizedBox(height: 20),
                  _buildFilterBar(
                    isDark,
                    surfaceColor,
                    textColor,
                    primaryColor,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildArtworksSliverGrid(isDark),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: _getFilteredArtworks().isEmpty
                  ? _buildEmptyState(isDark, textColor, primaryColor)
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworksSliverGrid(bool isDark) {
    final filtered = _getFilteredArtworks();
    if (filtered.isEmpty)
      return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final artwork = filtered[index];
          return ManagementArtworkCard(
            title: artwork['title'],
            image: artwork['image'],
            views: artwork['views'],
            likes: artwork['likes'],
            date: artwork['date'].toString().split(' ')[0],
            statusLabel: artwork['status'] == ArtworkStatus.published
                ? 'منشور'
                : (artwork['status'] == ArtworkStatus.draft ? 'مسودة' : 'خاص'),
            statusColor: artwork['status'] == ArtworkStatus.published
                ? Colors.green
                : (artwork['status'] == ArtworkStatus.draft
                      ? Colors.amber
                      : Colors.grey),
            onEdit: () {},
            onDelete: () {},
            onView: () {},
            onShare: () {},
          );
        }, childCount: filtered.length),
      ),
    );
  }

  Widget _buildPageHeader(bool isDark, Color textColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      // decoration: BoxDecoration(
      //   color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      //   borderRadius: BorderRadius.circular(15),
      //   boxShadow: [
      //     BoxShadow(
      //       color: const Color(0xFF8B4513).withOpacity(0.1),
      //       blurRadius: 15,
      //       offset: const Offset(0, 5),
      //     ),
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إدارة الأعمال الفنية',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'تصفح وإدارة جميع أعمالك الفنية من مكان واحد',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? Colors.grey[400]
                            : const Color(0xFF5D4E37),
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddArtworkModal(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'إضافة عمل فني جديد',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showExhibitionRequestModal(context),
                  icon: Icon(Icons.image, color: primaryColor),
                  label: Text(
                    'طلب معرض افتراضي',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: primaryColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive grid count

        return Wrap(
          spacing: 15,
          runSpacing: 15,
          alignment: WrapAlignment.center,
          children: [
            _buildStatItem('إجمالي الأعمال', '45', Icons.palette, isDark),
            _buildStatItem('المشاهدات', '12,847', Icons.remove_red_eye, isDark),
            _buildStatItem('الإعجابات', '2,156', Icons.favorite, isDark),
            _buildStatItem('المباعة', '23', Icons.shopping_cart, isDark),
            _buildStatItem('المعارض', '8', Icons.photo_library, isDark),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return ManagementStatsCard(
      label: label,
      value: value,
      icon: icon,
      isDark: isDark,
    );
  }

  Widget _buildFilterBar(
    bool isDark,
    Color surfaceColor,
    Color textColor,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
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
                _buildDropdown<String>(
                  value: _selectedStatus == null
                      ? 'all'
                      : _selectedStatus.toString(),
                  items: [
                    const DropdownMenuItem(
                      value: 'all',
                      child: Text('جميع الأعمال'),
                    ),
                    DropdownMenuItem(
                      value: ArtworkStatus.published.toString(),
                      child: const Text('منشور'),
                    ),
                    DropdownMenuItem(
                      value: ArtworkStatus.draft.toString(),
                      child: const Text('مسودة'),
                    ),
                    DropdownMenuItem(
                      value: ArtworkStatus.private.toString(),
                      child: const Text('خاص'),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      if (val == 'all') _selectedStatus = null;
                      // Simple mapping for demo
                    });
                  },
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _buildDropdown<ArtworkCategory>(
                  value: _selectedCategory,
                  items: const [
                    DropdownMenuItem(
                      value: ArtworkCategory.all,
                      child: Text('جميع الفئات'),
                    ),
                    DropdownMenuItem(
                      value: ArtworkCategory.oilPainting,
                      child: Text('رسم زيتي'),
                    ),
                    DropdownMenuItem(
                      value: ArtworkCategory.watercolor,
                      child: Text('ألوان مائية'),
                    ),
                    DropdownMenuItem(
                      value: ArtworkCategory.acrylic,
                      child: Text('أكريليك'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategory = val);
                  },
                  isDark: isDark,
                ),
                const SizedBox(width: 10),
                _buildDropdown<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(
                      value: 'newest',
                      child: Text('الأحدث أولاً'),
                    ),
                    DropdownMenuItem(
                      value: 'oldest',
                      child: Text('الأقدم أولاً'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _sortBy = val);
                  },
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'البحث في أعمالك...',
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
              prefixIcon: Icon(Icons.search, color: primaryColor),
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

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : const Color(0xFFF5E6D3),
          width: 2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF2C1810),
            fontFamily: 'Tajawal',
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFB8860B)),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredArtworks() {
    return _artworks.where((artwork) {
      // Filter by Status
      if (_selectedStatus != null) {
        if (artwork['status'] != _selectedStatus) return false;
      }

      // Filter by Category
      if (_selectedCategory != ArtworkCategory.all) {
        if (artwork['category'] != _selectedCategory) return false;
      }

      // Filter by Search Query
      if (_searchQuery.isNotEmpty) {
        final title = artwork['title'].toString().toLowerCase();
        final desc = artwork['description'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !desc.contains(query)) return false;
      }

      return true;
    }).toList();
  }

  Widget _buildEmptyState(bool isDark, Color textColor, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.palette_outlined,
            size: 80,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'لا توجد أعمال فنية بعد',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ابدأ رحلتك الفنية بإضافة أول عمل فني لك.',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor.withOpacity(0.7)),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _showAddArtworkModal(context),
            icon: const Icon(Icons.add),
            label: const Text('أضف عملك الأول'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddArtworkModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddArtworkDialog(),
    );
  }

  void _showExhibitionRequestModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ExhibitionRequestDialog(),
    );
  }
}
