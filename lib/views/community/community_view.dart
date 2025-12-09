import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/providers/community/community_provider.dart';
import 'package:sanaa_artl/providers/theme_provider.dart';
import 'package:sanaa_artl/views/community/widgets/artist_card.dart';
import 'package:sanaa_artl/views/community/widgets/post_card.dart';

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
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'المجتمع الفني',
          style: TextStyle(
            color: isDark ? const Color(0xFFD4AF37) : const Color(0xFFB8860B),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'المنشورات'),
            Tab(text: 'الفنانين'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPostsTab(context), _buildArtistsTab(context)],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add post
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('سيتم إضافة هذه الميزة قريباً')),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
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

  Widget _buildArtistsTab(BuildContext context) {
    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'فنانون مميزون',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.artists.length,
                  itemBuilder: (context, index) {
                    return ArtistCard(artist: provider.artists[index]);
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'كل الفنانين',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              // Grid for all artists
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: provider.artists.length,
                itemBuilder: (context, index) {
                  return ArtistCard(artist: provider.artists[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
