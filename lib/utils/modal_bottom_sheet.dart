import 'package:flutter/material.dart';

showModalBottomSheetWithChild(BuildContext context, Widget child) {
  showModalBottomSheet(
    backgroundColor: Theme.of(context).backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25.0),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            child,
          ],
        ),
      );
    },
  );
}
