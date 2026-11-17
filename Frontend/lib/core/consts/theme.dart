import 'package:flutter/material.dart';

import 'colours.dart';

class AppThemes {
  const AppThemes._();

  static final lightMode = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colours.primary,
      primary: Colours.primary,
      surface: Colours.surface,
    ),
    scaffoldBackgroundColor: Colours.background,
    fontFamily: 'sans-serif',
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colours.background,
      foregroundColor: Colours.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colours.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colours.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colours.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colours.primary, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colours.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    dividerColor: Colours.border,
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colours.primary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
