import 'package:flutter/material.dart';

class InklessIconButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final Function onPressed;

  InklessIconButton({this.icon, this.size = 25, this.onPressed});

  @override
  _InklessIconButtonState createState() => _InklessIconButtonState();
}

class _InklessIconButtonState extends State<InklessIconButton> {
  bool _isTapDown = false;

  Color get color {
    if (_isTapDown) {
      return Theme.of(context).accentColor;
    }
    if (widget.onPressed == null) {
      return Colors.grey;
    }

    return Theme.of(context).iconTheme.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(widget.icon, size: widget.size, color: color),
      ),
      onTap: () {
        setState(() {
          _isTapDown = false;
        });
        widget.onPressed();
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
