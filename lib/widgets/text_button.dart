import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  TextButton({
    @required this.text,
    @required this.onPressed,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return (new FlatButton(
      child: new Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(decoration: TextDecoration.underline, color: color),
      ),
      onPressed: onPressed,
    ));
  }
}
