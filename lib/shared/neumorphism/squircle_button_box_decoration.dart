import 'package:flutter/material.dart';

BoxDecoration squircleButtonBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Theme.of(context).textTheme.body2.color,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).textTheme.body2.color.withOpacity(0.4),
        offset: Offset(9.0, 9.0),
        blurRadius: 10.0,
      ),
      BoxShadow(
        color: Theme.of(context).primaryColorLight,
        offset: Offset(-9.0, -9.0),
        blurRadius: 12.0,
      ),
    ],
  );
}

BoxDecoration squircleButtonBoxDecorationDepressed(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Theme.of(context).buttonColor,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColorLight,
        offset: Offset(3, 3),
        blurRadius: 3,
        spreadRadius: -3,
      ),
    ],
  );
}
