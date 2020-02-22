import 'package:flutter/material.dart';

import 'buttons/squircle_icon_button.dart';

class AppNavBar extends StatelessWidget {
  final SquircleIconButton rightButton;
  final String title;
  final bool canGoBack;
  final bool disabled;

  AppNavBar({
    this.rightButton,
    this.title = "",
    this.canGoBack = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (canGoBack)
            SquircleIconButton(
              enabled: !disabled,
              iconData: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              iconSize: 24.0,
              height: 50.0,
              width: 50.0,
            ),
          Text(
            title,
            style: canGoBack
                ? Theme.of(context).textTheme.subtitle2
                : Theme.of(context).textTheme.headline6,
          ),
          rightButton ??
              SizedBox(
                width: 50.0,
                height: 50.0,
              ),
        ],
      ),
    );
  }
}
