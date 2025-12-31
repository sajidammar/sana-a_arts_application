import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/vr_provider.dart';

class ArtistProfilePage extends StatelessWidget {
  const ArtistProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VRProvider>(
      builder: (context, vrProvider, child) {
        final artist = vrProvider.currentArtist;

        return CustomScrollView(
          slivers: [
            // Header مع صورة الخلفية
            SliverAppBar(
              expandedHeight: 200,
              pinned: false,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // صورة الفنان
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        artist['name'] ?? 'الفنان',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        artist['specialty'] ?? 'فنان تشكيلي',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Tajawal',
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // محتوى الصفحة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // إحصائيات الفنان
                    _buildStatsRow(context, artist),
                    const SizedBox(height: 20),

                    // نبذة عن الفنان
                    _buildSectionTitle(context, 'نبذة عن الفنان'),
                    const SizedBox(height: 12),
                    _buildBioCard(context, artist),
                    const SizedBox(height: 20),

                    // الأعمال الفنية
                    _buildSectionTitle(context, 'الأعمال الفنية'),
                    const SizedBox(height: 12),
                    _buildArtworksList(context, artist),
                    const SizedBox(height: 80), // مساحة للشريط السفلي
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context, Map<String, dynamic> artist) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            Icons.palette,
            '${artist['artworksCount'] ?? 0}',
            'أعمال',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            Icons.museum,
            '${artist['exhibitionsCount'] ?? 0}',
            'معارض',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            Icons.workspace_premium,
            '${artist['awardsCount'] ?? 0}',
            'جوائز',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Tajawal',
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Tajawal',
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildBioCard(BuildContext context, Map<String, dynamic> artist) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        artist['bio'] ??
            'فنان تشكيلي يمني، متخصص في الفنون التشكيلية المعاصرة.',
        style: TextStyle(
          fontSize: 14,
          height: 1.6,
          fontFamily: 'Tajawal',
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildArtworksList(BuildContext context, Map<String, dynamic> artist) {
    final artworks =
        artist['artworks'] as List? ??
        [
          {'title': 'تراث صنعاء', 'year': '2024'},
          {'title': 'ألوان اليمن', 'year': '2023'},
          {'title': 'روح المدينة', 'year': '2023'},
        ];

    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artworks.length,
        itemBuilder: (context, index) {
          final artwork = artworks[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.image, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                Text(
                  artwork['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  artwork['year'] ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: 'Tajawal',
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



