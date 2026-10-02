import 'package:flutter/material.dart';
import 'package:phan_movies/Initializers/shared_preferences.dart';
import 'package:phan_movies/controllers/theme_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int groupValue = SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme') ?? 2;

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
            Container(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 40,
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Phantom',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
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
