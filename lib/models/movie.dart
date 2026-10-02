class Movie {
  final int id;
  final String title;
  final String? posterUrl;
  final String? backdropUrl;
  final String overview;
  final String? releaseDate;
  final double voteAverage;
  final String mediaType;
  final List<int> genreIds;
  final List<String> genres;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.overview,
    required this.releaseDate,
    required this.voteAverage,
    required this.mediaType,
    required this.genreIds,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int? ?? 0,
      title: (json['title'] ?? json['name'] ?? 'Untitled') as String,
      posterUrl: json['poster_url'] as String?,
      backdropUrl: json['backdrop_url'] as String?,
      overview: json['overview'] as String? ?? '',
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      mediaType: json['media_type'] as String? ?? 'movie',
      genreIds: _parseIntList(json['genre_ids']),
      genres: _parseStringList(json['genres']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_url': posterUrl,
      'backdrop_url': backdropUrl,
      'overview': overview,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'media_type': mediaType,
      'genre_ids': genreIds,
      'genres': genres,
    };
  }

  // ── Helpers ────────────────────────────────
  // Parse a JSON list safely. If it's missing, null, or contains
  // non-matching types, return an empty list instead of throwing.

  static List<int> _parseIntList(dynamic value) {
    if (value is! List) return [];
    return value.whereType<int>().toList();
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return [];
    return value.whereType<String>().toList();
  }

  // ── Convenience ────────────────────────────

  /// Year extracted from release date, or null if unavailable.
  int? get year {
    if (releaseDate == null || releaseDate!.length < 4) return null;
    return int.tryParse(releaseDate!.substring(0, 4));
  }

  /// Genres joined as a single display string.
  /// "Horror • Mystery • Thriller" or empty if no genres.
  String get genresDisplay => genres.join(' • ');

  /// Best image URL: backdrop for wide cards, poster for tall cards.
  String? get wideImage => backdropUrl ?? posterUrl;
  String? get tallImage => posterUrl ?? backdropUrl;

  bool get isMovie => mediaType == 'movie';
  bool get isTv => mediaType == 'tv';

  @override
  String toString() => 'Movie($id, "$title", $mediaType)';
}