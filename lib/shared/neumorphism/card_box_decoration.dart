import 'package:flutter/material.dart';

BoxDecoration cardBoxDecoration(BuildContext context) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(25),
    color: Theme.of(context).primaryColor,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColorDark,
        offset: Offset(12, 10),
        blurRadius: 10.0,
      ),
      BoxShadow(
        color: Theme.of(context).primaryColorLight,
        offset: Offset(-12, -10),
        blurRadius: 14.0,
      ),
    ],
  );
}
