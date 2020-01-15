import 'package:flutter/material.dart';

BoxDecoration squircleIconButtonBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Theme.of(context).primaryColor,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColorDark.withOpacity(0.2),
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

BoxDecoration squircleIconButtonBoxDecorationDepressed(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Theme.of(context).primaryColorDark.withOpacity(0.2),
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
