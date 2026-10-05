import 'package:flutter/material.dart';
import 'package:phan_movies/apiServices/api_client.dart';
import 'package:phan_movies/pages/navigation.dart';

class SocialLoginHandler {
  /// Runs a social sign-in flow, stores the token, and navigates on success.
  /// [provider] is used only for the error message.
  static Future<void> handle({
    required BuildContext context,
    required Future<String?> Function() signIn,
    required String provider,
  }) async {
    final token = await signIn();

    if (!context.mounted) return;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider sign-in cancelled or failed'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Store the Sanctum token
    await ApiClient.storage.write(key: 'token', value: token);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Signed in with $provider'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to the app
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NavigationPage()),
    );
  }
}