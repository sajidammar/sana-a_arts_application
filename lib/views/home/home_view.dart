import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/views/academies/home_view.dart';
import 'package:sanaa_artl/providers/exhibition/exhibition_provider.dart';
import 'package:sanaa_artl/providers/academy/workshop_provider.dart';
import 'package:sanaa_artl/providers/store/product_provider.dart';
import 'package:sanaa_artl/providers/community/community_provider.dart';
import 'package:sanaa_artl/views/exhibitions/home/home_page.dart';
import 'package:sanaa_artl/views/home/shared/bottom_navigation_bar.dart';
import 'package:sanaa_artl/views/home/shared/side_drawer.dart';
import 'package:sanaa_artl/views/home/widgets/ads_banner.dart';
import 'package:sanaa_artl/views/home/widgets/featured_exhibitions.dart';
import 'package:sanaa_artl/themes/academy/colors.dart';
import '../../providers/theme_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/user_provider.dart';
import '../about/about_view.dart';
import '../community/community_view.dart';
import '../profile/profile_view.dart';
import '../store/home_page.dart';
import '../wishlist/wishlist_view.dart';
import '../help/help_page.dart';
import '../settings/privacy_page.dart';
import '../store/order/order_history_page.dart';
import '../notifications/notifications_view.dart';
import '../artworks_management/artworks_management_view.dart';
import '../my_exhibitions/my_exhibitions_view.dart';
import '../my_certificates/my_certificates_view.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final wishlistProvider = Provider.of<WishlistProvider>(
        context,
        listen: false,
      );

      productProvider.loadProducts();
      if (userProvider.currentUser != null) {
        wishlistProvider.setUserId(userProvider.currentUser!.id);
      }
      wishlistProvider.loadWishlist(productProvider.products);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    setState(() {}); // Update UI for clear button

    if (_currentIndex == 0) {
      context.read<CommunityProvider>().setSearchQuery(query);
    } else if (_currentIndex == 1) {
      context.read<WorkshopProvider>().setSearchQuery(query);
    } else if (_currentIndex == 2) {
      context.read<ExhibitionProvider>().setSearchQuery(query);
    } else if (_currentIndex == 3) {
      context.read<ProductProvider>().setSearchQuery(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});

    // Clear all providers to be safe
    context.read<ExhibitionProvider>().setSearchQuery('');
    context.read<WorkshopProvider>().setSearchQuery('');
    context.read<ProductProvider>().setSearchQuery('');
    context.read<CommunityProvider>().setSearchQuery('');
  }

  final List<Widget> _pages = [
    const CommunityPage(),
    const AcademyHomeView(),
    const ExhibitionHomePage(),
    const StorePage(),
    const _HomeContent(),
  ];

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateToWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WishlistPage()),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void _navigateToAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  void _navigateToContact() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.getBackgroundColor(isDark),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: AppColors.getCardColor(isDark),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: AppColors.getPrimaryColor(isDark),
            size: 28,
          ),
          onPressed: _openDrawer,
        ),
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppColors.getPrimaryColor(isDark).withValues(alpha: 0.3),
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: _handleSearch,
            style: TextStyle(color: AppColors.getTextColor(isDark)),
            decoration: InputDecoration(
              hintText: 'ابحث...',
              hintStyle: TextStyle(
                color: AppColors.getSubtextColor(isDark),
                fontFamily: 'Tajawal',
              ),
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.getPrimaryColor(isDark),
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: AppColors.getSubtextColor(isDark),
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: AppColors.getPrimaryColor(isDark),
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsView(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: SideDrawer(
        onProfilePressed: _navigateToProfile,
        onAboutPressed: _navigateToAbout,
        onContactPressed: _navigateToContact,
        onLanguageChanged: () {},
        onThemeChanged: () {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
        onShareApp: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'سيتم مشاركة التطبيق قريباً',
                style: TextStyle(fontFamily: 'Tajawal'),
              ),
            ),
          );
        },
        onSettingsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyPage()),
          );
        },
        onHelpPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpPage()),
          );
        },
        onLogoutPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.getCardColor(isDark),
              title: Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.getTextColor(isDark),
                ),
              ),
              content: Text(
                'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppColors.getTextColor(isDark),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppColors.getPrimaryColor(isDark),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'تم تسجيل الخروج',
                          style: TextStyle(fontFamily: 'Tajawal'),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontFamily: 'Tajawal', color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        onOrdersPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
          );
        },
        onWishlistPressed: _navigateToWishlist,
        onArtworksManagementPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ArtworksManagementView(),
            ),
          );
        },
        onMyExhibitionsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyExhibitionsView()),
          );
        },
        onMyCertificatesPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCertificatesView()),
          );
        },
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
            _clearSearch();
          });
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const AdsBanner(),
            const FeaturedExhibitions(),
            const SizedBox(height: 20),
          ]),
        ),
      ],
    );
  }
}
