import 'movie.dart';

class PaginatedMovies {
  final int page;
  final int totalPages;
  final int totalResults;
  final List<Movie> results;

  PaginatedMovies({
    required this.page,
    required this.totalPages,
    required this.totalResults,
    required this.results,
  });

  factory PaginatedMovies.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List? ?? [];
    return PaginatedMovies(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? rawResults.length,
      results: rawResults
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}