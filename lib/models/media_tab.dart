// lib/models/media_tab.dart
import 'package:phan_movies/models/paginated_movies.dart';

class MediaTab {
  final String label;
  final Future<PaginatedMovies> Function({int page}) fetchTrending;
  final Future<PaginatedMovies> Function({int page}) fetchBrowse;

  MediaTab({
    required this.label,
    required this.fetchTrending,
    required this.fetchBrowse,
  });
}