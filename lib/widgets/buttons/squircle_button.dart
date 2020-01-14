import 'package:flutter/material.dart';

import '../../shared/neumorphism/squircle_icon_button_box_decoration.dart';

class SquircleButton extends StatefulWidget {
  final double height;
  final double width;
  final Widget child;
  final Function onPressed;

  SquircleButton({
    this.height = 40.0,
    this.width = double.infinity,
    @required this.child,
    @required this.onPressed,
  });

  @override
  _SquircleButtonState createState() => _SquircleButtonState();
}

class _SquircleButtonState extends State<SquircleButton> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: _isTapDown
            ? squircleIconButtonBoxDecorationDepressed(context)
            : squircleIconButtonBoxDecoration(context),
        child: widget.child,
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
