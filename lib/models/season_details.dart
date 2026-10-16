import 'episode.dart';

class SeasonDetails {
  final int seasonNumber;
  final String name;
  final String overview;
  final String? posterUrl;
  final List<Episode> episodes;

  SeasonDetails({
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterUrl,
    required this.episodes,
  });

  factory SeasonDetails.fromJson(Map<String, dynamic> json) {
    return SeasonDetails(
      seasonNumber: json['season_number'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterUrl: json['poster_url'] as String?,
      episodes: (json['episodes'] as List? ?? [])
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}