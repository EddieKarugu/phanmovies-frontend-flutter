import 'dart:async';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:phan_movies/apiServices/api_client.dart';

class SocialAuthService {
  static final _dio = ApiClient.dio;
  static final GoogleSignIn _google = GoogleSignIn.instance;
  static bool _googleInitialized = false;

  // ─────────────────────────────────────────────
  // INITIALIZATION
  // ─────────────────────────────────────────────

  /// Call this once in main() before runApp().
  static Future<void> init() async {
    if (_googleInitialized) return;

    await _google.initialize(
      // iOS only — the iOS OAuth client ID from Google Cloud Console.
      // Leave null on Android.
      clientId: null,

      // Required for authorizeServer() — the "Web" OAuth client ID.
      serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
    );

    _googleInitialized = true;
  }

  // ─────────────────────────────────────────────
  // GOOGLE
  // ─────────────────────────────────────────────

  /// Returns a Sanctum token string on success, or null if the user
  /// cancelled or an error occurred.
  static Future<String?> signInWithGoogle() async {
    await init(); // safe — no-op if already initialized

    try {
      // 1. Show the native Google sign-in sheet
      final GoogleSignInAccount account = await _google.authenticate();

      // 2. Request a server auth code for Laravel
      final GoogleSignInServerAuthorization? serverAuth =
          await account.authorizationClient.authorizeServer(
        <String>['email', 'profile'],
      );

      if (serverAuth == null) return null;

      // 3. Send the code to Laravel
      final res = await _dio.post('/auth/google', data: {
        'server_auth_code': serverAuth.serverAuthCode,
      });

      return res.data['token'] as String?;
    } on DioException catch (e) {
      print('Google backend error: ${e.message}');
      return null;
    } catch (e) {
      print('Google sign-in error: $e');
      return null;
    }
  }

  /// Sign out of Google on the device. Call this from your logout flow.
  static Future<void> signOutGoogle() async {
    await _google.signOut();
  }

  // ─────────────────────────────────────────────
  // APPLE
  // ─────────────────────────────────────────────

  /// Returns a Sanctum token string on success, or null if the user
  /// cancelled or an error occurred.
  static Future<String?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final res = await _dio.post('/auth/apple', data: {
        'identity_token': credential.identityToken,
        'authorization_code': credential.authorizationCode,
        'name': [
          credential.givenName,
          credential.familyName,
        ].where((s) => s != null).join(' ').trim(),
        'email': credential.email,
      });

      return res.data['token'] as String?;
    } on DioException catch (e) {
      print('Apple backend error: ${e.message}');
      return null;
    } catch (e) {
      print('Apple sign-in error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // SHARED
  // ─────────────────────────────────────────────

  /// Sign out of every provider. Call from logout.
  static Future<void> signOutAll() async {
    await signOutGoogle();
    // Apple has no device-side sign-out — it's stateless.
  }
}