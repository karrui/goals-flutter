import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color color;
  final IconData icon;
  final Function onPressed;

  RoundedButton({
    @required this.text,
    @required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.blue,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      color: backgroundColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.0,
              color: color,
            ),
            Text(
              this.text,
              style: TextStyle(color: color),
            ),
            // Spacer to make button text centered with logo
            Container(
              width: 24.0,
              height: 0.0,
            )
          ]),
      onPressed: onPressed,
    );
  }
}
