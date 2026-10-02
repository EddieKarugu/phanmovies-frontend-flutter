import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  // Replace with YOUR computer's LAN IP — the one you tested in the browser
  static const String _host = '192.168.12.1';
  static const String _port = '8000';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://$_host:$_port/api',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 30)
    ),
  );

  static const FlutterSecureStorage storage = FlutterSecureStorage();

  // Attach the token to every request automatically
  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}