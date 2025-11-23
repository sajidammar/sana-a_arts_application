import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/views/academies/home_view.dart';
import 'package:sanaa_artl/views/exhibitions/home/home_page.dart';
import 'package:sanaa_artl/views/home/shared/bottom_navigation_bar.dart';
import 'package:sanaa_artl/views/home/shared/custom_app_bar.dart';
import 'package:sanaa_artl/views/home/shared/side_drawer.dart';
import 'package:sanaa_artl/views/home/widgets/ads_banner.dart';
import 'package:sanaa_artl/views/home/widgets/featured_exhibitions.dart';
import '../../providers/theme_provider.dart';
import '../about/about_view.dart';

import '../community/community_view.dart';

import '../profile/profile_view.dart';
import '../store/home_page.dart';

import '../wishlist/wishlist_view.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const _HomeContent(),
    const ExhibitionHomePage(),
    const AcademyHomeView(),
    const StorePage(),
    const CommunityPage(),
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeProvider.isDarkMode
          ? const Color(0xFF121212)
          : const Color(0xFFFDF6E3),
      appBar: CustomAppBar(
        onMenuPressed: _openDrawer,
        onSearchPressed: () {},
        onWishlistPressed: _navigateToWishlist,
        onNotificationsPressed: () {},
      ),
      drawer: SideDrawer(
        onProfilePressed: _navigateToProfile,
        onAboutPressed: _navigateToAbout,
        onContactPressed: _navigateToContact,
        onLanguageChanged: () {},
        onThemeChanged: () {
          themeProvider.toggleTheme();
        },
        onShareApp: () {},
        onSettingsPressed: () {},
        onHelpPressed: () {},
        onLogoutPressed: () {},
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AdsBanner(),
          const FeaturedExhibitions(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
