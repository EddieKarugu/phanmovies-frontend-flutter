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
    required this.genre, required this.releaseDate,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        width: screenSize.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : Container(
                      color: Colors.grey,
                      child: Icon(Icons.movie, size: 40),
                    ),
              Positioned(
                bottom: 0,
                left: 20,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: ThemeController.ratingGold,
                          size: 20,
                        ),
                        Text(rating.toString().substring(0, 3), style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(width: 5),
                        Text(releaseDate ?? ''),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row( 
                      children: [
                        ... List.generate(genre.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(genre[index]),
                          );
                        
                        }),
                        
                      ],
                    )
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
