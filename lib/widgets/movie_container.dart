import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/controllers/theme_controller.dart';

class MovieContainer extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final double rating;
  final List<String> genres;

  const MovieContainer({
    super.key,
    this.imageUrl,
    required this.title,
    required this.rating,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: BoxBorder.all(
        //   color: Theme.of(context).colorScheme.primary,
        //   width: 1,
        // ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageUrl != null
                ? CachedNetworkImage(imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url)=> Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                )
                : Icon(
                    Icons.movie,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Theme.of(context).colorScheme.surface.withOpacity(.2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  
                  Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines:1, overflow: TextOverflow.ellipsis),
                  Text(genres.join(', '), style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),),
                  Row(children: [ 
                    Icon(Icons.star, color: ThemeController.ratingGold, size: 20,),
                    const SizedBox(width: 5,),
                    Text(rating.toString().substring(0, 3), style: TextStyle(fontSize: 12),)
                  ],),
                  
                ],),
              ),
            )
          ],
        ),
      ),
    );
  }
}
