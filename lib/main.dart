import "package:flutter/material.dart";
import "package:phan_movies/apiServices/api_client.dart";
import "package:phan_movies/controllers/theme_controller.dart";
import "package:phan_movies/pages/Authentication.dart";

import "Initializers/shared_preferences.dart";

void main() async {
  ApiClient.init();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPrefs.Init();
  ThemeController.phanTheme.value = SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme') ?? 2;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.phanTheme,
      builder: (context, currentTheme, child) {
        return MaterialApp(
          home: const  Authentication(),
          theme: ThemeController.lightTheme,
          darkTheme: ThemeController.darkTheme,
          themeMode: currentTheme == 0
              ? ThemeMode.light
              : currentTheme == 1
              ? ThemeMode.dark
              : ThemeMode.system,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
