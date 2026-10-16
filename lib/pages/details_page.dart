import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/apiServices/movie_service.dart';
import 'package:phan_movies/models/cast_member.dart';
import 'package:phan_movies/models/episode.dart';
import 'package:phan_movies/models/movie.dart';
import 'package:phan_movies/models/movie_details.dart';
import 'package:phan_movies/models/season.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieDetailsPage extends StatefulWidget {
  final int id;
  final String mediaType;
  final Movie? preview;

  const MovieDetailsPage({
    super.key,
    required this.id,
    required this.mediaType,
    this.preview,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  MovieDetails? _details;
  bool _loading = true;
  String? _error;

  // Trailer
  YoutubePlayerController? _ytController;
  bool _trailerStarted = false;

  // Season episodes — cached per season number
  final Map<int, List<Episode>> _seasonEpisodes = {};
  final Set<int> _loadingSeasons = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ytController?.close();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _trailerStarted = false;
      _seasonEpisodes.clear();
      _loadingSeasons.clear();
    });

    try {
      final data = widget.mediaType == 'tv'
          ? await MovieService.tvDetails(widget.id)
          : await MovieService.movieDetails(widget.id);

      if (!mounted) return;
      setState(() {
        _details = data;
        _loading = false;
      });
    } on DioException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.response?.data?['message'] ?? e.message ?? 'Failed to load';
        _loading = false;
      });
    }
  }

  Future<void> _loadSeason(int seasonNumber) async {
    if (_loadingSeasons.contains(seasonNumber)) return;
    if (_seasonEpisodes.containsKey(seasonNumber)) return;

    setState(() => _loadingSeasons.add(seasonNumber));

    try {
      final data = await MovieService.seasonDetails(widget.id, seasonNumber);
      if (!mounted) return;
      setState(() {
        _seasonEpisodes[seasonNumber] = data.episodes;
        _loadingSeasons.remove(seasonNumber);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingSeasons.remove(seasonNumber);
        _seasonEpisodes[seasonNumber] = [];
      });
    }
  }

  void _startTrailer(String key) {
    _ytController = YoutubePlayerController.fromVideoId(
      videoId: key,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
        enableCaption: false,
        loop: false,
      ),
    );
    setState(() => _trailerStarted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(body: _buildError());
    }
    return Scaffold(body: _buildContent());
  }

  Widget _buildError() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final details = _details!;
    final movie = details.movie;

    return CustomScrollView(
      slivers: [
        // ── App bar with backdrop ────────────────
        SliverAppBar(
          expandedHeight: 240,
          pinned: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (movie.backdropUrl != null)
                  CachedNetworkImage(
                    imageUrl: movie.backdropUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[900]),
                    errorWidget: (_, __, ___) => Container(color: Colors.grey[900]),
                  )
                else
                  Container(color: Colors.grey[900]),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Title + meta ─────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (movie.year != null) ...[
                      Text('${movie.year}', style: TextStyle(color: Colors.grey[400])),
                      const SizedBox(width: 12),
                    ],
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(movie.voteAverage.toStringAsFixed(1),
                        style: TextStyle(color: Colors.grey[400])),
                    if (movie.isTv) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('TV',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                if (movie.genres.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: movie.genres
                        .map((g) => Chip(
                              label: Text(g, style: const TextStyle(fontSize: 11)),
                              padding: EdgeInsets.zero,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Trailer ──────────────────────────────
        if (details.trailerKey != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Trailer',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildTrailer(details.trailerKey!),
                ],
              ),
            ),
          ),

        // ── Movie playback container ─────────────
        if (movie.isMovie)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildMoviePlaybackContainer(),
            ),
          ),

        // ── Overview ─────────────────────────────
        if (movie.overview.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(movie.overview, style: const TextStyle(height: 1.5)),
                ],
              ),
            ),
          ),

        // ── Cast ─────────────────────────────────
        if (details.cast.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Top Cast',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: details.cast.length,
                      itemBuilder: (context, i) => _buildCastCard(details.cast[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // ── Seasons (TV only) ────────────────────
        if (movie.isTv && details.seasons.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Episodes',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  ...details.seasons.map((season) => _buildSeasonTile(season)),
                ],
              ),
            ),
          ),

        // ── Recommendations ──────────────────────
        if (details.recommendations.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('You Might Also Like',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: details.recommendations.length,
                      itemBuilder: (context, i) =>
                          _buildRecommendationCard(details.recommendations[i]),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // TRAILER
  // ─────────────────────────────────────────────

  Widget _buildTrailer(String key) {
    if (_trailerStarted && _ytController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(controller: _ytController!),
        ),
      );
    }

    final thumbUrl = 'https://img.youtube.com/vi/$key/maxresdefault.jpg';

    return GestureDetector(
      onTap: () => _startTrailer(key),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: thumbUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[900]),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.movie, size: 48, color: Colors.white54),
                  ),
                ),
              ),
              Container(color: Colors.black38),
              const Center(
                child: Icon(Icons.play_circle_fill, size: 72, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MOVIE PLAYBACK CONTAINER
  // ─────────────────────────────────────────────

  Widget _buildMoviePlaybackContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_details?.trailerKey != null) {
                _startTrailer(_details!.trailerKey!);
              }
            },
            child: const Icon(Icons.play_circle_fill, size: 44, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Watch Now',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 2),
                Text('Full movie playback',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEASON TILE
  // ─────────────────────────────────────────────

  Widget _buildSeasonTile(Season season) {
    final episodes = _seasonEpisodes[season.seasonNumber];
    final isLoading = _loadingSeasons.contains(season.seasonNumber);

    return ExpansionTile(
      key: PageStorageKey('season_${season.seasonNumber}'),
      title: Text(season.name),
      subtitle: Text('${season.episodeCount} episodes'),
      leading: season.posterUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: season.posterUrl!,
                width: 40,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[900]),
                errorWidget: (_, __, ___) => Container(
                  width: 40,
                  height: 60,
                  color: Colors.grey[900],
                ),
              ),
            )
          : null,
      onExpansionChanged: (expanded) {
        if (expanded && episodes == null && !isLoading) {
          _loadSeason(season.seasonNumber);
        }
      },
      children: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (episodes == null)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('Expand to load episodes')),
          )
        else if (episodes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: Text('No episodes found')),
          )
        else
          Column(
            children: episodes.map((e) => _buildEpisodeTile(e)).toList(),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // EPISODE TILE
  // ─────────────────────────────────────────────

  Widget _buildEpisodeTile(Episode episode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: episode.stillUrl != null
                ? CachedNetworkImage(
                    imageUrl: episode.stillUrl!,
                    width: 120,
                    height: 68,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(width: 120, height: 68, color: Colors.grey[900]),
                    errorWidget: (_, __, ___) => Container(
                      width: 120,
                      height: 68,
                      color: Colors.grey[900],
                      child: const Icon(Icons.movie, size: 24),
                    ),
                  )
                : Container(
                    width: 120,
                    height: 68,
                    color: Colors.grey[900],
                    child: const Icon(Icons.movie, size: 24),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${episode.episodeNumber}. ${episode.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (episode.runtime != null)
                  Text('${episode.runtime} min',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                const SizedBox(height: 2),
                Text(
                  episode.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_outline, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Episode playback coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.download, size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download coming soon')),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CAST
  // ─────────────────────────────────────────────

  Widget _buildCastCard(CastMember cast) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: cast.profileUrl != null
                  ? CachedNetworkImage(
                      imageUrl: cast.profileUrl!,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(width: 90, height: 90, color: Colors.grey[900]),
                      errorWidget: (_, __, ___) => _castFallback(cast),
                    )
                  : _castFallback(cast),
            ),
            const SizedBox(height: 6),
            Text(
              cast.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              cast.character,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _castFallback(CastMember cast) {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey[900],
      child: Center(
        child: Text(
          cast.initial,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // RECOMMENDATION CARD
  // ─────────────────────────────────────────────

  Widget _buildRecommendationCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailsPage(
              id: movie.id,
              mediaType: movie.mediaType,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.posterUrl != null
                    ? CachedNetworkImage(
                        imageUrl: movie.posterUrl!,
                        width: 130,
                        height: 195,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(width: 130, height: 195, color: Colors.grey[900]),
                        errorWidget: (_, __, ___) => Container(
                          width: 130,
                          height: 195,
                          color: Colors.grey[900],
                          child: const Icon(Icons.broken_image),
                        ),
                      )
                    : Container(
                        width: 130,
                        height: 195,
                        color: Colors.grey[900],
                        child: const Icon(Icons.movie, size: 40),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}