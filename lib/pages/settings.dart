import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/Initializers/shared_preferences.dart';
import 'package:phan_movies/apiServices/auth_service.dart';
import 'package:phan_movies/controllers/theme_controller.dart';
import 'package:phan_movies/models/user.dart';
import 'package:phan_movies/widgets/account_section.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int groupValue = SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme') ?? 2;

  bool _isloading = false;
  User? _user;

  Future<void> _loadUser() async {
    setState(() {
      _isloading = true;
    });
    try {
      final user = await AuthService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _isloading = false;
      });
    } on DioException catch (_) {
      if (!mounted) return;
      setState(() {
        _isloading = false;
      });
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            AccountSection(user: _user, isLoading: _isloading),
            const SizedBox(height: 10),
            const Text(
              'Theme Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              value: 0,
              groupValue: groupValue,
              title: Text('Light Theme'),
              onChanged: (int? value) {
                setState(() {
                  groupValue = value!;
                  SharedPrefs.userSharedprefs?.setInt('PhanMoviesTheme', value);
                  ThemeController.phanTheme.value = value;
                  print(SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme'));
                });
              },
            ),
            RadioListTile(
              value: 1,
              groupValue: groupValue,
              title: Text('Dark Theme'),
              onChanged: (int? value) {
                setState(() {
                  groupValue = value!;
                  SharedPrefs.userSharedprefs?.setInt('PhanMoviesTheme', value);
                  ThemeController.phanTheme.value = value;
                  print(SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme'));
                });
              },
            ),
            RadioListTile(
              value: 2,
              groupValue: groupValue,
              title: Text('Follow System'),
              onChanged: (int? value) {
                setState(() {
                  groupValue = value!;
                  SharedPrefs.userSharedprefs?.setInt('PhanMoviesTheme', value);
                  ThemeController.phanTheme.value = value;
                  print(SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme'));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
