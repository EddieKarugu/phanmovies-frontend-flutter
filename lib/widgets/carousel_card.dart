import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/controllers/theme_controller.dart';

class CarouselCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final double? rating;
  final String? releaseDate;
  final List<String> genre;
  final VoidCallback onTap;

  const CarouselCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.rating,
    required this.genre,
    required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: screenSize.width * 0.8,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image fills the entire card
              imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.error),
                      ),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.movie, size: 40),
                    ),

              // Dark gradient so text is readable
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),

              // Info overlay
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: ThemeController.ratingGold,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating != null ? rating!.toStringAsFixed(1) : '—',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (releaseDate != null && releaseDate!.isNotEmpty)
                          Text(
                            releaseDate!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                      ],
                    ),
                    if (genre.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        genre.take(3).join(' • '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
