import 'package:flutter/material.dart';

import '../shared/neumorphism/button_box_decoration.dart';

class SquircleIconButton extends StatefulWidget {
  final double height;
  final double width;
  final double iconSize;
  final IconData iconData;
  final Function onPressed;

  SquircleIconButton({
    this.height = 40.0,
    this.width = 40.0,
    this.iconSize = 15.0,
    @required this.iconData,
    @required this.onPressed,
  });

  @override
  _SquircleIconButtonState createState() => _SquircleIconButtonState();
}

class _SquircleIconButtonState extends State<SquircleIconButton> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: _isTapDown
            ? buttonBoxDecorationDepressed(context)
            : buttonBoxDecoration(context),
        child: Icon(
          widget.iconData,
          size: widget.iconSize,
          color: _isTapDown
              ? Theme.of(context).buttonColor
              : Theme.of(context).textTheme.button.color,
        ),
      ),
      onTap: () {
        widget.onPressed();
        setState(() {
          _isTapDown = false;
        });
      },
      onTapDown: (_) {
        setState(() {
          _isTapDown = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapDown = false;
        });
      },
    );
  }
}