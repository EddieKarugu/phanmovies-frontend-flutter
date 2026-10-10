import 'package:phan_movies/apiServices/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/models/media_tab.dart';
import 'package:phan_movies/widgets/home_shell.dart' show HomeShell;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      tabs: [
        MediaTab(
          label: 'All',
          fetchTrending: MovieService.trendingAll,
          fetchBrowse: MovieService.browseAll,
        ),
        MediaTab(
          label: 'Movies',
          fetchTrending: MovieService.trendingMovies,
          fetchBrowse: MovieService.allMovies,
        ),
        MediaTab(
          label: 'TV Shows',
          fetchTrending: MovieService.trendingTv,
          fetchBrowse: MovieService.allTv,
        ),
        MediaTab(
          label: 'Anime',
          fetchTrending: MovieService.animeMovies,
          fetchBrowse: MovieService.animeTv,
        ),
      ],
    );
  }
}
