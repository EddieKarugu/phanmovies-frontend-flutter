import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/models/media_tab.dart';
import 'package:phan_movies/models/movie.dart';
import 'package:phan_movies/models/paginated_movies.dart';
import 'package:phan_movies/widgets/action_button.dart';
import 'package:phan_movies/widgets/carousel_card.dart';

class HomeShell extends StatefulWidget {
  final List<MediaTab> tabs;
  const HomeShell({super.key, required this.tabs});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final Map<String, PaginatedMovies?> _trendingByTab = {};
  final Map<String, PaginatedMovies?> _browseByTab = {};
  final Map<String, bool> _loadingTrendingByTab = {};
  final Map<String, bool> _loadingBrowseByTab = {};

  int _tabIndex = 0;

  late final PageController _carouselController;
  Timer? _autoScrollTimer;
  int _carouselIndex = 0;

  MediaTab get _currentTab => widget.tabs[_tabIndex];

  @override
  void initState() {
    super.initState();
    _carouselController = PageController(viewportFraction: 0.85);
    _loadTab(_currentTab);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // DATA
  // ─────────────────────────────────────────────

  void _loadTab(MediaTab tab) {
    final key = tab.label;

    if (_trendingByTab[key] == null && _loadingTrendingByTab[key] != true) {
      _loadingTrendingByTab[key] = true;
      tab.fetchTrending(page: 1).then((data) {
        if (!mounted) return;
        setState(() {
          _trendingByTab[key] = data;
          _loadingTrendingByTab[key] = false;
        });
        if (_tabIndex == widget.tabs.indexOf(tab)) {
          _startAutoScroll(data.results);
        }
      }).catchError((_) {
        if (!mounted) return;
        setState(() {
          _trendingByTab[key] = PaginatedMovies.empty();
          _loadingTrendingByTab[key] = false;
        });
      });
    }

    if (_browseByTab[key] == null && _loadingBrowseByTab[key] != true) {
      _loadingBrowseByTab[key] = true;
      tab.fetchBrowse(page: 1).then((data) {
        if (!mounted) return;
        setState(() {
          _browseByTab[key] = data;
          _loadingBrowseByTab[key] = false;
        });
      }).catchError((_) {
        if (!mounted) return;
        setState(() {
          _browseByTab[key] = PaginatedMovies.empty();
          _loadingBrowseByTab[key] = false;
        });
      });
    }
  }

  void _onTabChanged(int index) {
    if (index == _tabIndex) return;
    setState(() {
      _tabIndex = index;
      _carouselIndex = 0;
    });
    _autoScrollTimer?.cancel();
    _loadTab(widget.tabs[index]);
  }

  // ─────────────────────────────────────────────
  // CAROUSEL
  // ─────────────────────────────────────────────

  void _startAutoScroll(List<Movie> movies) {
    _autoScrollTimer?.cancel();
    if (movies.isEmpty) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_carouselController.hasClients) return;
      if (movies.isEmpty) return;

      final next = (_carouselIndex + 1) % movies.length;
      _carouselController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: widget.tabs.length,
                itemBuilder: (context, i) {
                  final tab = widget.tabs[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Actionbutton(
                      text: tab.label,
                      isSelected: i == _tabIndex,
                      onPressed: () => _onTabChanged(i),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Expanded(child: _buildTabView()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    final key = _currentTab.label;
    final trending = _trendingByTab[key];
    final browse = _browseByTab[key];
    final loadingTrending = _loadingTrendingByTab[key] ?? true;
    final loadingBrowse = _loadingBrowseByTab[key] ?? true;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _trendingByTab.remove(key);
          _browseByTab.remove(key);
        });
        _loadTab(_currentTab);
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: loadingTrending
                  ? const Center(child: CircularProgressIndicator())
                  : _buildCarousel(trending?.results ?? []),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          if (loadingBrowse)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.55,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _buildPosterTile(browse?.results[i]),
                  childCount: browse?.results.length ?? 0,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text('Nothing to show'));
    }

    return PageView.builder(
      controller: _carouselController,
      itemCount: movies.length,
      onPageChanged: (i) {
        _carouselIndex = i;
        _startAutoScroll(movies);
      },
      itemBuilder: (context, i) {
        final movie = movies[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: CarouselCard(
            imageUrl: movie.wideImage,
            title: movie.title,
            releaseDate: movie.releaseDate,
            genre: movie.genres,
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildPosterTile(Movie? movie) {
    if (movie == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.posterUrl != null
                  ? CachedNetworkImage(
                      imageUrl: movie.posterUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) =>
                          Container(color: Colors.grey[900]),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[900],
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : Container(
                      color: Colors.grey[900],
                      child: const Icon(Icons.movie),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}