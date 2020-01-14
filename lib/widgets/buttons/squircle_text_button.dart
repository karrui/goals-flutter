import 'package:flutter/material.dart';

import '../../shared/neumorphism/squircle_button_box_decoration.dart';

class SquircleTextButton extends StatefulWidget {
  final double height;
  final double width;
  final String text;
  final Function onPressed;

  SquircleTextButton({
    this.height = 40.0,
    this.width = double.infinity,
    @required this.text,
    @required this.onPressed,
  });

  @override
  _SquircleTextButtonState createState() => _SquircleTextButtonState();
}

class _SquircleTextButtonState extends State<SquircleTextButton> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: _isTapDown
            ? squircleButtonBoxDecorationDepressed(context)
            : squircleButtonBoxDecoration(context),
        child: Center(
          child: Text(
            widget.text,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Theme.of(context).primaryColor),
          ),
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
