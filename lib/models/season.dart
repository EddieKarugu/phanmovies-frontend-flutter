class Season {
  final int seasonNumber;
  final String name;
  final int episodeCount;
  final String? posterUrl;
  final String? airDate;

  Season({
    required this.seasonNumber,
    required this.name,
    required this.episodeCount,
    required this.posterUrl,
    required this.airDate,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['season_number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      episodeCount: json['episode_count'] as int? ?? 0,
      posterUrl: json['poster_url'] as String?,
      airDate: json['air_date'] as String?,
    );
  }
}