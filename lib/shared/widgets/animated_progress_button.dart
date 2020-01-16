import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

import 'icon_button_row.dart';

class AnimatedProgressButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final IconData iconData;
  final Color color;
  final Color backgroundColor;
  final bool enabled;
  final EdgeInsets padding;

  AnimatedProgressButton({
    @required this.text,
    @required this.onPressed,
    this.iconData,
    this.color = Colors.white,
    this.backgroundColor = Colors.blue,
    this.enabled = true,
    this.padding = const EdgeInsets.fromLTRB(48.0, 6, 48.0, 6.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        child: ProgressButton(
          progressWidget: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          defaultWidget: IconButtonRow(
            text: text,
            color: color,
            iconData: iconData,
          ),
          borderRadius: 30.0,
          onPressed: enabled ? onPressed : null,
          color: backgroundColor,
        ),
      ),
    );
  }
}
