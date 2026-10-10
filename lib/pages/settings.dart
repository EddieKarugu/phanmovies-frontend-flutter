import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/Initializers/shared_preferences.dart';
import 'package:phan_movies/apiServices/auth_service.dart';
import 'package:phan_movies/apiServices/social_auth_service.dart';
import 'package:phan_movies/controllers/theme_controller.dart';
import 'package:phan_movies/models/user.dart';
import 'package:phan_movies/widgets/account_section.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _groupValue =
      SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme') ?? 2;

  bool _loadingUser = false;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loadingUser = true);

    try {
      final user = await AuthService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _loadingUser = false;
      });
    } on DioException catch (e) {
      debugPrint('[Settings] /me failed: ${e.response?.statusCode}');
      if (!mounted) return;
      setState(() => _loadingUser = false);
    }
  }

  Future<void> _logout() async {
    try {
      await AuthService.logout();
    } catch (_) {
      // AuthService.logout already clears the local token, so even
      // if the server call fails, the user is signed out locally.
    }
    // Also clear the device-side Google session so the next sign-in
    // shows the account picker again.
    try {
      await SocialAuthService.signOutGoogle();
    } catch (_) {}
  }

  void _setTheme(int value) {
    setState(() => _groupValue = value);
    SharedPrefs.userSharedprefs?.setInt('PhanMoviesTheme', value);
    ThemeController.phanTheme.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────
              const Text(
                'Account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              // ── Account card ───────────────────────
              Center(
                child: AccountSection(
                  user: _user,
                  isLoading: _loadingUser,
                  onLogout: _logout,
                ),
              ),

              const SizedBox(height: 24),

              // ── Theme ──────────────────────────────
              const Text(
                'Theme Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),

              RadioListTile<int>(
                value: 0,
                groupValue: _groupValue,
                title: const Text('Light Theme'),
                onChanged: (value) {
                  if (value == null) return;
                  _setTheme(value);
                },
              ),
              RadioListTile<int>(
                value: 1,
                groupValue: _groupValue,
                title: const Text('Dark Theme'),
                onChanged: (value) {
                  if (value == null) return;
                  _setTheme(value);
                },
              ),
              RadioListTile<int>(
                value: 2,
                groupValue: _groupValue,
                title: const Text('Follow System'),
                onChanged: (value) {
                  if (value == null) return;
                  _setTheme(value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}