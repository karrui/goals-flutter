import 'package:flutter/material.dart';

import '../shared/theme.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    themePreference.setIsDarkTheme(value);
    notifyListeners();
  }
}
