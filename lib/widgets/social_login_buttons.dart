// lib/widgets/social_buttons.dart
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:phan_movies/apiServices/social_auth_service.dart';
import 'package:phan_movies/utils/social_login_handler.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        IconButton(
          onPressed: () => SocialLoginHandler.handle(
            context: context,
            signIn: SocialAuthService.signInWithGoogle,
            provider: 'Google',
          ),
          icon: Brand(Brands.google),
          tooltip: 'Sign in with Google',
        ),

        const SizedBox(width: 24),

        // Apple
        IconButton(
          onPressed: () => SocialLoginHandler.handle(
            context: context,
            signIn: SocialAuthService.signInWithApple,
            provider: 'Apple',
          ),
          icon: Brand(Brands.apple_logo),
          tooltip: 'Sign in with Apple',
        ),
      ],
    );
  }
}