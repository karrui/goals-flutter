import 'package:flutter/material.dart';

import 'static_squircle_button.dart';

class SquircleTextButton extends StatefulWidget {
  final double height;
  final double width;
  final bool enabled;
  final String text;
  final Function onPressed;

  SquircleTextButton({
    this.height = 40.0,
    this.width = double.infinity,
    this.enabled = true,
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
      child: StaticSquircleButton(
        height: widget.height,
        width: widget.width,
        isActive: _isTapDown,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
      onTap: () {
        if (widget.enabled) {
          widget.onPressed();
          setState(() {
            _isTapDown = false;
          });
        }
      },
      onTapDown: (_) {
        if (widget.enabled) {
          setState(() {
            _isTapDown = true;
          });
        }
      },
      onTapCancel: () {
        if (widget.enabled) {
          setState(() {
            _isTapDown = false;
          });
        }
      },
    );
  }
}
