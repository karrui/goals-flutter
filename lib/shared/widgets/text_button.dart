import 'package:flutter/material.dart';

class TextButton extends StatefulWidget {
  final String text;
  final Function onPressed;

  TextButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  _TextButtonState createState() => _TextButtonState();
}

class _TextButtonState extends State<TextButton> {
  bool _isTapDown = false;

  Color get color {
    if (_isTapDown) {
      return Theme.of(context).accentColor;
    }
    if (widget.onPressed == null) {
      return Colors.grey;
    }

    return Theme.of(context).textTheme.title.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        widget.text,
        style: TextStyle(color: color),
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