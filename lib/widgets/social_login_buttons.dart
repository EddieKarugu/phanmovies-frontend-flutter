import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:phan_movies/apiServices/social_auth_service.dart';
import 'package:phan_movies/utils/social_login_handler.dart';

class SocialButtons extends StatefulWidget {
  const SocialButtons({super.key});

  @override
  State<SocialButtons> createState() => _SocialButtonsState();
}

class _SocialButtonsState extends State<SocialButtons> {
  String? _loadingProvider;

  bool get _anyLoading => _loadingProvider != null;

  Future<void> _handle(String provider) async {
    if (_anyLoading) return;  

    setState(() => _loadingProvider = provider);

    try {
      await SocialLoginHandler.handle(
        context: context,
        signIn: provider == 'Google'
            ? SocialAuthService.signInWithGoogle
            : SocialAuthService.signInWithApple,
        provider: provider,
      );
    } finally {
      if (mounted) {
        setState(() => _loadingProvider = null);
      }
    }
  }

  Widget _buildIcon(String provider, Widget idleIcon) {
    if (_loadingProvider == provider) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return idleIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        IconButton(
          onPressed: _anyLoading ? null : () => _handle('Google'),
          icon: _buildIcon('Google', Brand(Brands.google, size: 28)),
          tooltip: 'Sign in with Google',
        ),

        const SizedBox(width: 24),

        // Apple
        IconButton(
          onPressed: _anyLoading ? null : () => _handle('Apple'),
          icon: _buildIcon('Apple', Brand(Brands.apple_logo, size: 28)),
          tooltip: 'Sign in with Apple',
        ),
      ],
    );
  }
}