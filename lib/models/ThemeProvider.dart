import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get getCurrentThemeMode => _themeMode;

  void toggleTheme(Brightness currentBrightness) {
    _themeMode = currentBrightness == Brightness.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
