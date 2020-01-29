import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme.dart';

class StaticSquircleButton extends StatelessWidget {
  final double height;
  final double width;
  final bool isActive;
  final Widget child;

  StaticSquircleButton({
    this.height = 40.0,
    this.width = double.infinity,
    this.isActive = false,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return ClayContainer(
      height: height,
      width: width,
      emboss: isActive,
      child: Center(child: child),
      color: themeProvider.isDarkTheme
          ? Theme.of(context).primaryColor
          : Theme.of(context).buttonColor,
      parentColor: Theme.of(context).primaryColor,
      borderRadius: 15,
      depth: 10,
      spread: 6,
    );
  }
}
