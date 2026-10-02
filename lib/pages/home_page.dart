import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phan_movies/apiServices/movie_service.dart';
import 'package:phan_movies/models/movie.dart';
import 'package:phan_movies/models/paginated_movies.dart';
import 'package:phan_movies/widgets/Input_field.dart';
import 'package:phan_movies/widgets/action_button.dart';
import 'package:phan_movies/widgets/carousel_card.dart';
import 'package:phan_movies/widgets/movie_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _controller;
  late PageController _carouselController;

  final List<String> tabs = ['All', 'Movies', 'TV Shows', 'Anime'];
  String _currentTab = 'All';
  int _currentIndex = 0;
  Timer? autoScrollTimer;

  Future<PaginatedMovies>? trendingAll;
  Future<PaginatedMovies>? browseAll;
  String? error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _carouselController = PageController(viewportFraction: .85);
    trendingAll = MovieService.trendingAll();
    browseAll = MovieService.browseAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  void _startAutoScroll(List<Movie> movies) {
    autoScrollTimer?.cancel();
    if (movies.isEmpty) return;
    autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_carouselController.hasClients) return;

      final next = (_currentIndex + 1) % movies.length;
      _carouselController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InputField(
                controller: _controller,
                hintText: 'Search',
                prefixIcon: Icons.search,
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Actionbutton(
                        text: tabs[index],
                        isSelected: _currentTab == tabs[index],
                        onPressed: () {
                          setState(() {
                            _currentTab = tabs[index];
                          });
                        },
                      ),
                    );
                  },
                  itemCount: tabs.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              SizedBox(
                height: 250,
                child: FutureBuilder<PaginatedMovies>(
                  future: trendingAll,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final movies = snapshot.data?.results ?? [];
                      if (movies.isEmpty) return SizedBox.shrink();

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _startAutoScroll(movies);
                      });
                      return PageView.builder(
                        controller: _carouselController,
                        onPageChanged: (int index) {
                          _currentIndex = index;
                          _startAutoScroll(movies);
                        },
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          return CarouselCard(
                            imageUrl:
                                movies[index].backdropUrl ??
                                movies[index].posterUrl,
                            title: movies[index].title,
                            onTap: () {},
                            genre: movies[index].genres,
                            rating: movies[index].voteAverage,
                            releaseDate: movies[index].releaseDate,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<PaginatedMovies>(
                  future: browseAll,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final movies = snapshot.data?.results ?? [];
                      if (movies.isEmpty) {
                        return Center(
                          child: Text('No Movies available at the moment'),
                        );
                      }

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          childAspectRatio: .65
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final currentMovie = movies[index];
                          return MovieContainer(
                            title: currentMovie.title,
                            imageUrl:
                                currentMovie.backdropUrl ??
                                currentMovie.posterUrl,
                            rating: currentMovie.voteAverage,
                            genres: currentMovie.genres,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
