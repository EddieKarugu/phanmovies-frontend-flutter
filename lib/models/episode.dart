class Episode {
  final int episodeNumber;
  final String name;
  final String overview;
  final String? stillUrl;
  final int? runtime;
  final String? airDate;
  final double voteAverage;

  Episode({
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.stillUrl,
    required this.runtime,
    required this.airDate,
    required this.voteAverage,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episode_number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      stillUrl: json['still_url'] as String?,
      runtime: json['runtime'] as int?,
      airDate: json['air_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }
}