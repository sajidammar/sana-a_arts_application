import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/auth_provider.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/core/utils/database/dao/artwork_dao.dart';
import 'package:sanaa_artl/core/utils/database/dao/artist_dao.dart';
import 'package:sanaa_artl/features/auth/views/login_page.dart';
import 'widgets/add_artwork_dialog.dart';
import 'widgets/exhibition_request_dialog.dart';

/// صفحة إدارة الأعمال الفنية - تصميم جديد محسن للهاتف
class ArtworksManagementView extends StatefulWidget {
  const ArtworksManagementView({super.key});

  @override
  State<ArtworksManagementView> createState() => _ArtworksManagementViewState();
}

class _ArtworksManagementViewState extends State<ArtworksManagementView> {
  final ArtworkDao _artworkDao = ArtworkDao();
  final ArtistDao _artistDao = ArtistDao();

  List<Map<String, dynamic>> _artworks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, featured, forSale

  @override
  void initState() {
    super.initState();
    _loadArtworks();
  }

  /// تحميل الأعمال الفنية من قاعدة البيانات
  Future<void> _loadArtworks() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (authProvider.isAuthenticated && authProvider.currentUser != null) {
        // البحث عن معرف الفنان للمستخدم الحالي
        final artistData = await _artistDao.getArtistByUserId(
          authProvider.currentUser!.id,
        );

        if (artistData != null) {
          // تحميل أعمال الفنان
          final artworks = await _artworkDao.getArtworksByArtistId(
            artistData['id'],
          );
          setState(() {
            _artworks = artworks;
            _isLoading = false;
          });
        } else {
          // المستخدم ليس فناناً، عرض جميع الأعمال (للعرض)
          final artworks = await _artworkDao.getAllArtworks(limit: 20);
          setState(() {
            _artworks = artworks;
            _isLoading = false;
          });
        }
      } else {
        // غير مسجل، عرض أعمال للعرض
        final artworks = await _artworkDao.getFeaturedArtworks(limit: 10);
        setState(() {
          _artworks = artworks;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('خطأ في تحميل الأعمال: $e');
      setState(() => _isLoading = false);
    }
  }

  /// الأعمال المفلترة
  List<Map<String, dynamic>> get _filteredArtworks {
    return _artworks.where((artwork) {
      // فلترة بالبحث
      if (_searchQuery.isNotEmpty) {
        final title = (artwork['title'] ?? '').toString().toLowerCase();
        final desc = (artwork['description'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        if (!title.contains(query) && !desc.contains(query)) {
          return false;
        }
      }

      // فلترة بالحالة
      switch (_selectedFilter) {
        case 'featured':
          return artwork['is_featured'] == 1;
        case 'forSale':
          return artwork['is_for_sale'] == 1;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      body: RefreshIndicator(
        onRefresh: _loadArtworks,
        color: primaryColor,
        child: CustomScrollView(
          slivers: [
            // شريط التطبيق
            _buildAppBar(isDark, primaryColor),

            // محتوى الصفحة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // رسالة الترحيب
                    _buildWelcomeSection(isDark, primaryColor, authProvider),
                    const SizedBox(height: 20),

                    // أزرار الإجراءات
                    _buildActionButtons(primaryColor, authProvider),
                    const SizedBox(height: 20),

                    // الإحصائيات
                    _buildStatsRow(isDark, primaryColor),
                    const SizedBox(height: 20),

                    // شريط البحث والفلترة
                    _buildSearchAndFilter(isDark, primaryColor),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // قائمة الأعمال الفنية
            _isLoading
                ? const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _filteredArtworks.isEmpty
                ? _buildEmptyState(isDark, primaryColor, authProvider)
                : _buildArtworksList(isDark, primaryColor),

            // مساحة سفلية
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),

      // زر إضافة عمل فني
      floatingActionButton: authProvider.isAuthenticated
          ? FloatingActionButton.extended(
              onPressed: () => _showAddArtworkDialog(context),
              backgroundColor: primaryColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'إضافة عمل',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  /// شريط التطبيق
  Widget _buildAppBar(bool isDark, Color primaryColor) {
    return SliverAppBar(
      backgroundColor: AppColors.getCardColor(isDark),
      elevation: 0,
      floating: true,
      snap: true,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.palette, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'أعمالي الفنية',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// قسم الترحيب
  Widget _buildWelcomeSection(
    bool isDark,
    Color primaryColor,
    AuthProvider auth,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: isDark ? 0.3 : 0.15),
            primaryColor.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: primaryColor.withValues(alpha: 0.2),
                child: Icon(Icons.person, color: primaryColor, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.isAuthenticated
                          ? 'مرحباً ${auth.currentUser?.name ?? ''}'
                          : 'مرحباً بك',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      auth.isAuthenticated
                          ? 'إدارة أعمالك الفنية من مكان واحد'
                          : 'سجل دخولك لإدارة أعمالك',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// أزرار الإجراءات
  Widget _buildActionButtons(Color primaryColor, AuthProvider auth) {
    if (!auth.isAuthenticated) {
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          ).then((_) => _loadArtworks());
        },
        icon: const Icon(Icons.login),
        label: const Text('تسجيل الدخول للإدارة'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () => _showAddArtworkDialog(context),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('إضافة عمل'),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _showExhibitionRequestDialog(context),
          icon: Icon(Icons.image, size: 20, color: primaryColor),
          label: Text('طلب معرض', style: TextStyle(color: primaryColor)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  /// صف الإحصائيات
  Widget _buildStatsRow(bool isDark, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.palette,
            label: 'الأعمال',
            value: '${_artworks.length}',
            isDark: isDark,
            primaryColor: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.visibility,
            label: 'المشاهدات',
            value: _formatNumber(_calculateTotalViews()),
            isDark: isDark,
            primaryColor: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.favorite,
            label: 'الإعجابات',
            value: _formatNumber(_calculateTotalLikes()),
            isDark: isDark,
            primaryColor: primaryColor,
          ),
        ),
      ],
    );
  }

  /// بطاقة إحصائية
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// شريط البحث والفلترة
  Widget _buildSearchAndFilter(bool isDark, Color primaryColor) {
    return Column(
      children: [
        // حقل البحث
        TextField(
          onChanged: (value) => setState(() => _searchQuery = value),
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            hintText: 'البحث في أعمالك...',
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey,
            ),
            prefixIcon: Icon(Icons.search, color: primaryColor),
            filled: true,
            fillColor: AppColors.getCardColor(isDark),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // أزرار الفلترة
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('الكل', 'all', isDark, primaryColor),
              const SizedBox(width: 8),
              _buildFilterChip('المميزة', 'featured', isDark, primaryColor),
              const SizedBox(width: 8),
              _buildFilterChip('للبيع', 'forSale', isDark, primaryColor),
            ],
          ),
        ),
      ],
    );
  }

  /// شريحة الفلترة
  Widget _buildFilterChip(
    String label,
    String value,
    bool isDark,
    Color primaryColor,
  ) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = selected ? value : 'all');
      },
      backgroundColor: AppColors.getCardColor(isDark),
      selectedColor: primaryColor.withValues(alpha: 0.2),
      checkmarkColor: primaryColor,
      labelStyle: TextStyle(
        color: isSelected
            ? primaryColor
            : (isDark ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? primaryColor : Colors.transparent),
    );
  }

  /// قائمة الأعمال الفنية
  Widget _buildArtworksList(bool isDark, Color primaryColor) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final artwork = _filteredArtworks[index];
          return _buildArtworkCard(artwork, isDark, primaryColor);
        }, childCount: _filteredArtworks.length),
      ),
    );
  }

  /// بطاقة العمل الفني
  Widget _buildArtworkCard(
    Map<String, dynamic> artwork,
    bool isDark,
    Color primaryColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.getCardColor(isDark),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة العمل الفني
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  artwork['image_url'] ?? 'assets/images/image1.jpg',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.image,
                        size: 60,
                        color: primaryColor.withValues(alpha: 0.5),
                      ),
                    );
                  },
                ),
              ),

              // شارات الحالة
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    if (artwork['is_featured'] == 1)
                      _buildBadge('مميز', Colors.amber, Icons.star),
                    if (artwork['is_for_sale'] == 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _buildBadge(
                          'للبيع',
                          Colors.green,
                          Icons.shopping_cart,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // معلومات العمل الفني
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork['title'] ?? 'بدون عنوان',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // السعر والتقييم
                Row(
                  children: [
                    if ((artwork['price'] ?? 0) > 0)
                      Text(
                        '${artwork['price']} ${artwork['currency'] ?? '\$'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${(artwork['rating'] ?? 0).toStringAsFixed(1)}',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // إحصائيات
                Row(
                  children: [
                    _buildMiniStat(
                      Icons.visibility,
                      '${artwork['views'] ?? 0}',
                      isDark,
                    ),
                    const SizedBox(width: 16),
                    _buildMiniStat(
                      Icons.favorite,
                      '${artwork['likes'] ?? 0}',
                      isDark,
                    ),
                    const Spacer(),

                    // أزرار الإجراءات
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit, color: primaryColor, size: 20),
                      tooltip: 'تعديل',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.share, color: Colors.blue, size: 20),
                      tooltip: 'مشاركة',
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

  /// شارة صغيرة
  Widget _buildBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// إحصائية صغيرة
  Widget _buildMiniStat(IconData icon, String value, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// حالة فارغة
  SliverFillRemaining _buildEmptyState(
    bool isDark,
    Color primaryColor,
    AuthProvider auth,
  ) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.palette_outlined,
                  size: 60,
                  color: primaryColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'لا توجد أعمال فنية',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                auth.isAuthenticated
                    ? 'ابدأ بإضافة أول عمل فني لك'
                    : 'سجل دخولك لعرض أعمالك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              if (auth.isAuthenticated)
                ElevatedButton.icon(
                  onPressed: () => _showAddArtworkDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة عمل فني'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// حساب إجمالي المشاهدات
  int _calculateTotalViews() {
    return _artworks.fold(0, (sum, a) => sum + ((a['views'] ?? 0) as int));
  }

  /// حساب إجمالي الإعجابات
  int _calculateTotalLikes() {
    return _artworks.fold(0, (sum, a) => sum + ((a['likes'] ?? 0) as int));
  }

  /// تنسيق الأرقام
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  /// عرض حوار إضافة عمل فني
  void _showAddArtworkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddArtworkDialog(),
    );
  }

  /// عرض حوار طلب معرض
  void _showExhibitionRequestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ExhibitionRequestDialog(),
    );
  }
}


