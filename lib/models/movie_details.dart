import 'cast_member.dart';
import 'movie.dart';
import 'season.dart';

class MovieDetails {
  final Movie movie;
  final String? trailerKey;
  final List<CastMember> cast;
  final List<Movie> recommendations;
  final List<Season> seasons;    // ← empty list for movies, populated for TV

  MovieDetails({
    required this.movie,
    required this.trailerKey,
    required this.cast,
    required this.recommendations,
    required this.seasons,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      movie: Movie.fromJson(json['movie'] as Map<String, dynamic>),
      trailerKey: json['trailer_key'] as String?,
      cast: (json['cast'] as List? ?? [])
          .map((e) => CastMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List? ?? [])
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      seasons: (json['seasons'] as List? ?? [])
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}