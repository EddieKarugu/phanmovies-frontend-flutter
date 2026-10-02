
import 'package:phan_movies/models/paginated_movies.dart';
import 'api_client.dart';

class MovieService {
  static final _dio = ApiClient.dio;

  // ─────────────────────────────────────────────
  // TRENDING
  // ─────────────────────────────────────────────

  static Future<PaginatedMovies> trendingMovies({
    String window = 'week',
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/trending/movies',
      queryParameters: {'window': window, 'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<PaginatedMovies> trendingTv({
    String window = 'week',
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/trending/tv',
      queryParameters: {'window': window, 'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────
  // ALL / DISCOVER
  // ─────────────────────────────────────────────

  static Future<PaginatedMovies> allMovies({
    int page = 1,
    int? genre,
    String? sort,
  }) async {
    final res = await _dio.get(
      '/movies/all',
      queryParameters: {
        'page': page,
        if (genre != null) 'genre': genre,
        if (sort != null) 'sort': sort,
      },
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<PaginatedMovies> allTv({
    int page = 1,
    int? genre,
    String? sort,
  }) async {
    final res = await _dio.get(
      '/tv/all',
      queryParameters: {
        'page': page,
        if (genre != null) 'genre': genre,
        if (sort != null) 'sort': sort,
      },
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────
  // RECOMMENDATIONS & SIMILAR
  // ─────────────────────────────────────────────

  static Future<PaginatedMovies> movieRecommendations(
    int movieId, {
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/movies/$movieId/recommendations',
      queryParameters: {'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<PaginatedMovies> tvRecommendations(
    int tvId, {
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/tv/$tvId/recommendations',
      queryParameters: {'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<PaginatedMovies> similarMovies(
    int movieId, {
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/movies/$movieId/similar',
      queryParameters: {'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  // ─────────────────────────────────────────────
  // GENRES (still simple maps — you can type these later)
  // ─────────────────────────────────────────────

  static Future<List<Map<String, dynamic>>> movieGenres() async {
    final res = await _dio.get('/genres/movies');
    final list = res.data['genres'] as List;
    return list.cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> tvGenres() async {
    final res = await _dio.get('/genres/tv');
    final list = res.data['genres'] as List;
    return list.cast<Map<String, dynamic>>();
  }


  static Future<PaginatedMovies> trendingAll({
    String window = 'week',
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/trending/all',
      queryParameters: {'window': window, 'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }
  
  static Future<PaginatedMovies> animeTv({int page = 1}) async {
    final res = await _dio.get('/anime/tv', queryParameters: {'page': page});
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }
  
  static Future<PaginatedMovies> animeMovies({int page = 1}) async {
    final res = await _dio.get('/anime/movies', queryParameters: {'page': page});
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }
  
  static Future<PaginatedMovies> search({
    required String query,
    String type = 'multi',
    int page = 1,
  }) async {
    final res = await _dio.get(
      '/search',
      queryParameters: {'q': query, 'type': type, 'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }

  static Future<PaginatedMovies> browseAll({int page = 1}) async {
    final res = await _dio.get(
      '/browse/all',
      queryParameters: {'page': page},
    );
    return PaginatedMovies.fromJson(res.data as Map<String, dynamic>);
  }
}