import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme.dart';

class StaticSquircleButton extends StatelessWidget {
  final double height;
  final double width;
  final bool isActive;
  final bool enabled;
  final Widget child;

  StaticSquircleButton({
    this.height = 40.0,
    this.width,
    this.isActive = false,
    this.enabled = true,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return ClayContainer(
      height: height,
      width: width,
      emboss: isActive,
      child: Wrap(
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          child,
        ],
      ),
      color: !enabled
          ? Theme.of(context).disabledColor.withOpacity(0.15)
          : themeProvider.isDarkTheme
              ? Theme.of(context).backgroundColor
              : Theme.of(context).buttonColor,
      parentColor: Theme.of(context).backgroundColor,
      borderRadius: 15,
      depth: enabled ? 10 : 0,
      spread: 6,
    );
  }
}
