import 'package:flutter/material.dart';

import '../../shared/neumorphism/squircle_icon_button_box_decoration.dart';

class SquircleIconButton extends StatefulWidget {
  final double height;
  final double width;
  final double iconSize;
  final Color iconColor;
  final IconData iconData;
  final Function onPressed;
  final bool enabled;

  SquircleIconButton({
    this.height = 40.0,
    this.width = 40.0,
    this.iconSize = 15.0,
    this.iconColor,
    this.enabled = true,
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
    Color _getIconColor() {
      if (!widget.enabled) {
        return Theme.of(context).disabledColor;
      }

      if (_isTapDown) {
        return Theme.of(context).buttonColor;
      }

      if (widget.iconColor != null) {
        return widget.iconColor;
      }
      return Theme.of(context).textTheme.button.color;
    }

    BoxDecoration _getDecoration() {
      if (!widget.enabled) {
        return null;
      }

      return _isTapDown
          ? squircleIconButtonBoxDecorationDepressed(context)
          : squircleIconButtonBoxDecoration(context);
    }

    return GestureDetector(
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: _getDecoration(),
        child: Icon(
          widget.iconData,
          size: widget.iconSize,
          color: _getIconColor(),
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
