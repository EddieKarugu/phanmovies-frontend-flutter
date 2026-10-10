import 'package:dio/dio.dart';
import 'package:phan_movies/models/user.dart';
import 'api_client.dart';

class AuthService {
  static final _dio = ApiClient.dio;
  static const _storage = ApiClient.storage;

  static Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final res = await _dio.post(
      '/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    await _storage.write(key: 'token', value: res.data['token']);
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    await _storage.write(key: 'token', value: res.data['token']);
  }

  static Future<String?> getToken() => _storage.read(key: 'token');

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } on DioException {
      // Even if the server call fails, clear locally
    }
    await _storage.delete(key: 'token');
  }

  static Future<User?> getCurrentUser() async {
    try {
      final response = await _dio.get('/me');
      return User.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return null;
      }
      rethrow;
    }
  }
}
