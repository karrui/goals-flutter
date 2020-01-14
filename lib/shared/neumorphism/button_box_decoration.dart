import 'package:flutter/material.dart';

BoxDecoration buttonBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    color: Theme.of(context).primaryColor,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColorDark,
        offset: Offset(9.0, 9.0),
        blurRadius: 14.0,
      ),
      BoxShadow(
        color: Theme.of(context).primaryColorLight,
        offset: Offset(-9.0, -9.0),
        blurRadius: 14.0,
      ),
    ],
  );
}

BoxDecoration buttonBoxDecorationDepressed(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    color: Theme.of(context).primaryColor,
    border: Border.all(color: Color(0xFFA8FFEA).withOpacity(0.7), width: 2.0),
    gradient: LinearGradient(
      // Where the linear gradient begins and ends
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      // Add one stop for each color. Stops should increase from 0 to 1
      stops: [0.1, 0.5, 0.7, 0.9],
      colors: [
        Color(0xFFA8FFEA),
        Color(0xFF72FFDD),
        Color(0xFF64F4D1),
        Color(0xFF1ec79d),
      ],
    ),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColorLight.withOpacity(0.5),
        offset: Offset(-2.0, -2.0),
        blurRadius: 12.0,
      ),
      BoxShadow(
        color: Theme.of(context).primaryColorDark,
        offset: Offset(2.0, 2.0),
        blurRadius: 8.0,
      ),
    ],
  );
}
