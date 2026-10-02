import 'package:flutter/material.dart';
import 'package:phan_movies/Initializers/shared_preferences.dart';

class ThemeController {
  static int getPhanTheme =
      SharedPrefs.userSharedprefs?.getInt('PhanMoviesTheme') ?? 2;
      static ValueNotifier<int> phanTheme  = ValueNotifier(getPhanTheme);

  // ─────────────────────────────────────────────
  // Brand Colors
  // ─────────────────────────────────────────────

  static const Color deepRed = Color(0xFFB71C1C);
  static const Color darkCrimson = Color(0xFF8E0000);
  static const Color brightRed = Color(0xFFEF5350);
  static const Color darkRed = Color(0xFFC62828);

  // ─────────────────────────────────────────────
  // Rating / Accent Colors
  // ─────────────────────────────────────────────

  static const Color ratingGold = Color(0xFFFFC857);

  // ─────────────────────────────────────────────
  // Light Theme Colors
  // ─────────────────────────────────────────────

  static const Color lightBackground = Color(0xFFF7F5F3);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0EDED);

  static const Color lightText = Color(0xFF171717);
  static const Color lightSecondaryText = Color(0xFF6B6565);
  static const Color lightDivider = Color(0xFFE2DEDE);

  // ─────────────────────────────────────────────
  // Dark Theme Colors
  // ─────────────────────────────────────────────

  static const Color darkBackground = Color(0xFF0D0D0F);
  static const Color darkSurface = Color(0xFF17171A);
  static const Color darkSurfaceVariant = Color(0xFF222225);

  static const Color darkText = Color(0xFFF5F5F5);
  static const Color darkSecondaryText = Color(0xFFA9A5A5);
  static const Color darkDivider = Color(0xFF2D2D31);

  // ─────────────────────────────────────────────
  // Light Theme
  // ─────────────────────────────────────────────

  static final lightTheme = ThemeData(
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: deepRed,
      onPrimary: Colors.white,

      secondary: darkCrimson,
      onSecondary: Colors.white,

      surface: lightSurface,
      onSurface: lightText,

      error: darkRed,
      onError: Colors.white,

      surfaceContainerHighest: lightSurfaceVariant,
      outline: lightDivider,
    ),

    scaffoldBackgroundColor: lightBackground,

    dividerColor: lightDivider,
  );

  // ─────────────────────────────────────────────
  // Dark Theme
  // ─────────────────────────────────────────────

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: brightRed,
      onPrimary: Color(0xFF1A0000),

      secondary: darkRed,
      onSecondary: Colors.white,

      surface: darkSurface,
      onSurface: darkText,

      error: brightRed,
      onError: Color(0xFF1A0000),

      surfaceContainerHighest: darkSurfaceVariant,
      outline: darkDivider,
    ),

    scaffoldBackgroundColor: darkBackground,

    dividerColor: darkDivider,
  );

  // ─────────────────────────────────────────────
  // Theme Toggle
  // ─────────────────────────────────────────────
}
