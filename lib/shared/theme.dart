import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setIsDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class AppTheme {
  static final _darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
  );

  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.grey,
    primaryColor: Color(0xFFF4FAFF),
    primaryColorLight: Colors.white,
    primaryColorDark: Color(0xFFA3B1C6).withOpacity(0.2),
    buttonColor: Color(0xFF38496C),
    backgroundColor: Color(0xFFF4FAFF),
    textTheme: TextTheme(
      title: TextStyle(
        color: Color(0xFF38496C),
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
      body2: TextStyle(
        color: Color(0xFF495C83),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
      subtitle: TextStyle(
        color: Color(0xFFA3BCDC),
        fontSize: 20,
      ),
      overline: TextStyle(
        color: Color(0xFF495C83),
        fontSize: 14,
        fontWeight: FontWeight.normal,
        letterSpacing: 0,
      ),
      button: TextStyle(
        color: Color(0xFFA3BCDC),
      ),
    ),
    accentColor: Colors.green.withOpacity(0.65),
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme ? _darkTheme : _lightTheme;
  }
}
