import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/core/localization/app_localizations.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/academies/controllers/workshop_provider.dart';
import 'package:sanaa_artl/features/store/controllers/product_provider.dart';
import 'package:sanaa_artl/features/community/controllers/community_provider.dart';
import 'package:sanaa_artl/features/exhibitions/views/home/home_page.dart';
import 'package:sanaa_artl/features/home/views/shared/bottom_navigation_bar.dart';
import 'package:sanaa_artl/features/home/views/shared/side_drawer.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';
import 'package:sanaa_artl/features/auth/controllers/user_controller.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/core/services/notification_service.dart';
import 'package:sanaa_artl/features/wishlist/controllers/wishlist_provider.dart';
import 'package:sanaa_artl/features/wishlist/views/wishlist_view.dart';
import 'package:sanaa_artl/features/notifications/views/notifications_view.dart';
import 'package:sanaa_artl/features/about/views/about_view.dart';
import 'package:sanaa_artl/features/community/views/community_view.dart';
import 'package:sanaa_artl/features/profile/views/profile_view.dart';
import 'package:sanaa_artl/features/chat/views/chat_hub_view.dart';
import 'package:sanaa_artl/features/settings/views/privacy_page.dart';
import 'package:sanaa_artl/features/help/views/help_page.dart';
import 'package:sanaa_artl/features/admin/views/dashboard/admin_dashboard_view.dart';
import 'package:sanaa_artl/core/widgets/coming_soon_page.dart';
import 'package:sanaa_artl/core/widgets/coming_soon_page_with_back.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      Provider.of<UserProvider>(context, listen: false);
      final wishlistProvider = Provider.of<WishlistProvider>(
        context,
        listen: false,
      );

      // productProvider.loadProducts();
      // if (userProvider.currentUser != null) {
      //   wishlistProvider.setUserId(userProvider.currentUser!.id);
      // }
      wishlistProvider.loadWishlist(productProvider.products);

      // اختبار الإشعارات عند الدخول
      NotificationService().showNotification(
        id: 0,
        title: 'مرحباً بك في سناء للفنون ✨',
        body: 'تم تفعيل نظام الإشعارات والمزامنة الذكي بنجاح.',
      );
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
    const ComingSoonPage(
      featureName: 'الأكاديمية',
      description:
          'أكاديمية الفنون قيد التطوير\nسيتم إطلاقها قريباً مع دورات ومحاضرات فنية متنوعة',
      icon: Icons.school_rounded,
    ),
    const ExhibitionHomePage(),
    const ComingSoonPage(
      featureName: 'المتجر',
      description:
          'متجر الأعمال الفنية قيد التطوير\nسيتم إطلاقه قريباً مع مجموعة رائعة من اللوحات والمنتجات الفنية',
      icon: Icons.store_rounded,
    ),
    const ChatHubView(),
  ];

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _navigateToWishlist() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WishlistPage()),
    );
  }

  void _navigateToProfile() {
    Navigator.pop(context);
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
    Navigator.pop(context);
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
              hintText: context.tr('search'),
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
            MaterialPageRoute(
              builder: (context) => const ComingSoonPageWithBack(
                featureName: 'طلباتي',
                description:
                    'صفحة طلباتك قيد التطوير\nستتمكن قريباً من متابعة جميع طلباتك ومشترياتك',
                icon: Icons.shopping_bag_outlined,
              ),
            ),
          );
        },
        onWishlistPressed: _navigateToWishlist,
        onArtworksManagementPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ComingSoonPageWithBack(
                featureName: 'إدارة الأعمال الفنية',
                description:
                    'صفحة إدارة أعمالك الفنية قيد التطوير\nستتمكن قريباً من إضافة وتعديل وحذف أعمالك الفنية',
                icon: Icons.palette_outlined,
              ),
            ),
          );
        },
        onMyExhibitionsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ComingSoonPageWithBack(
                featureName: 'معارضي',
                description:
                    'صفحة معارضك الفنية قيد التطوير\nستتمكن قريباً من إدارة ومتابعة جميع معارضك',
                icon: Icons.museum_outlined,
              ),
            ),
          );
        },
        onMyCertificatesPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ComingSoonPageWithBack(
                featureName: 'الشهادات والإنجازات',
                description:
                    'صفحة شهاداتك وإنجازاتك قيد التطوير\nستتمكن قريباً من عرض جميع شهاداتك الفنية',
                icon: Icons.workspace_premium_outlined,
              ),
            ),
          );
        },
        onAdminPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboardView()),
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
