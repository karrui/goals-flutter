import 'package:flutter/material.dart';

BoxDecoration squircleButtonBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(15),
    color: Theme.of(context).textTheme.body2.color,
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
