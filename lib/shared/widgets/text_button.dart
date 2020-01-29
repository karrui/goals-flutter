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
      return Theme.of(context).buttonColor;
    }
    if (widget.onPressed == null) {
      return Theme.of(context).disabledColor;
    }

    return Theme.of(context).textTheme.subtitle.color;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        widget.text,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(color: color, fontSize: 14),
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
