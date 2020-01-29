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
    fontFamily: 'Gilroy',
    scaffoldBackgroundColor: Color(0xFF171C26),
    brightness: Brightness.dark,
    errorColor: Color(0xFFFF416C),
    indicatorColor: Color(0xFF63FF79),
    primarySwatch: Colors.grey,
    primaryColor: Color(0xFF171C26),
    primaryColorLight: Color(0xFFF2F2F2),
    primaryColorDark: Color(0xFFF2F2F2),
    buttonColor: Colors.white,
    cursorColor: Color(0xFF495C83),
    backgroundColor: Color(0xFF171C26),
    textTheme: TextTheme(
      title: TextStyle(
        color: Color(0xFFF2F2F2),
        fontWeight: FontWeight.w800,
        fontSize: 32.0,
      ),
      body2: TextStyle(
        color: Color(0xFFF2F2F2),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
      subhead: TextStyle(fontWeight: FontWeight.w600),
      subtitle: TextStyle(
        color: Color(0xFFF0F1F5),
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      overline: TextStyle(
        color: Color(0xFFF0F1F5),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      button: TextStyle(
        color: Color(0xFFF2F2F2),
      ),
    ),
    accentColor: Colors.green.withOpacity(0.65),
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
  );

  static final _lightTheme = ThemeData(
    fontFamily: 'Gilroy',
    scaffoldBackgroundColor: Color(0xFFF4FAFF),
    brightness: Brightness.light,
    errorColor: Color(0xFFFF416C),
    indicatorColor: Color(0xFF37D779),
    primarySwatch: Colors.grey,
    primaryColor: Color(0xFFF4FAFF),
    primaryColorLight: Colors.white,
    primaryColorDark: Color(0xFFA3B1C6),
    buttonColor: Color(0xFF38496C),
    cursorColor: Color(0xFF495C83),
    backgroundColor: Color(0xFFF4FAFF),
    textTheme: TextTheme(
      title: TextStyle(
        color: Color(0xFF38496C),
        fontWeight: FontWeight.w800,
        fontSize: 32.0,
      ),
      body2: TextStyle(
        color: Color(0xFF495C83),
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
      subhead: TextStyle(fontWeight: FontWeight.w600),
      subtitle: TextStyle(
        color: Color(0xFFA3BCDC),
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      overline: TextStyle(
        color: Color(0xFF495C83),
        fontSize: 14,
        fontWeight: FontWeight.w500,
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
