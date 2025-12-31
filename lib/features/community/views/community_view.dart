import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/community/controllers/community_provider.dart';
import 'package:sanaa_artl/features/community/controllers/reel_provider.dart';
import 'package:sanaa_artl/features/settings/controllers/theme_provider.dart';
import 'package:sanaa_artl/features/community/views/widgets/post_card.dart';
import 'package:sanaa_artl/features/community/views/widgets/reel_thumbnail.dart';
import 'package:sanaa_artl/features/community/views/widgets/reel_grid_item.dart';
import 'package:sanaa_artl/features/community/views/reels_viewer_page.dart';
import 'package:sanaa_artl/features/community/views/add_post_page.dart';
import 'package:sanaa_artl/features/community/views/add_reel_page.dart';
import 'package:sanaa_artl/core/themes/app_colors.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // لتحديث أيقونة زر الإضافة
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(isDark),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              toolbarHeight: 0,
              backgroundColor: AppColors.getCardColor(isDark),
              elevation: 1,
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: AppColors.getSubtextColor(isDark),
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(text: 'المنشورات'),
                  Tab(text: 'الريلز'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [_buildPostsTab(context), _buildReelsTab(context)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddReelPage()),
            );
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: _tabController.index == 0 ? 'إضافة منشور' : 'إضافة ريلز',
        child: Icon(
          _tabController.index == 0 ? Icons.add_comment : Icons.video_call,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPostsTab(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        if (provider.posts.isEmpty) {
          return const Center(child: Text('لا توجد منشورات حتى الآن'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: provider.posts[index]);
          },
        );
      },
    );
  }

  Widget _buildReelsTab(BuildContext context) {
    return Consumer<ReelProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: _buildReelsContent(context, provider),
        );
      },
    );
  }

  Widget _buildReelsContent(BuildContext context, ReelProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.reels.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.movie_filter_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'لا توجد ريلز حالياً',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => provider.initialize(),
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'تنشيط البيانات',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الريلز المميزة',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 20),
          // القائمة الأفقية (Story style)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.reels.length,
              itemBuilder: (context, index) {
                return ReelThumbnail(
                  reel: provider.reels[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReelsViewerPage(
                          reels: provider.reels,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'اكتشف المزيد',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
          const SizedBox(height: 16),
          // Grid for all reels
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.reels.length,
            itemBuilder: (context, index) {
              return ReelGridItem(
                reel: provider.reels[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReelsViewerPage(
                        reels: provider.reels,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
