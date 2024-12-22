import "package:flutter/material.dart";

import "../utils/constants.dart";

class AppThemes{
  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: lightBlue),
      useMaterial3: true,
      fontFamily: "SpaceGrotesk",
    );
  }

  static ThemeData getDarkTheme() {
    return getLightTheme().copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey.shade800, // Darker background
      colorScheme: getLightTheme().colorScheme.copyWith(
        background: Colors.grey.shade800,
        onBackground: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: getLightTheme().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}