import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanaa_artl/features/exhibitions/models/exhibition.dart';
import 'package:sanaa_artl/features/exhibitions/controllers/exhibition_provider.dart';
import 'package:sanaa_artl/features/exhibitions/models/artwork.dart';

class OpenExhibitionPage extends StatelessWidget {
  final Exhibition exhibition;

  const OpenExhibitionPage({super.key, required this.exhibition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                exhibition.title,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              background: exhibition.imageUrl.isNotEmpty
                  ? Image.asset(exhibition.imageUrl, fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(
                        gradient: exhibition.type.gradient,
                      ),
                      child: Center(
                        child: Icon(
                          exhibition.type.icon,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: exhibition.type.color.withValues(alpha: 0.1),
                        child: Icon(Icons.person, color: exhibition.type.color),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'القيم: ${exhibition.curator}',
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    exhibition.description,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'الأعمال المعروضة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          // Artworks Grid
          Consumer<ExhibitionProvider>(
            builder: (context, provider, _) {
              final artworks = provider.getArtworksByExhibition(exhibition.id);
              if (artworks.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('لا توجد أعمال لعرضها حالياً'),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildArtworkCard(context, artworks[index]),
                    childCount: artworks.length,
                  ),
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }

  Widget _buildArtworkCard(BuildContext context, Artwork artwork) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: artwork.imageUrl != ''
                ? Image.asset(
                    artwork.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  )
                : Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(Icons.image, color: Colors.grey[400]),
                    ),
                  ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artwork.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artwork.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      Text(
                        artwork.rating.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



