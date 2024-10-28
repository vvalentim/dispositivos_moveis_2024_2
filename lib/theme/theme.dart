import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blueAccent);

  static ThemeData defaultTheme = ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      toolbarHeight: 70,
      backgroundColor: colorScheme.primary,
      titleTextStyle: const TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      backgroundColor: colorScheme.primary,
    ),
  );
}
