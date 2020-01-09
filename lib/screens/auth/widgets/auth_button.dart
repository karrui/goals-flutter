import 'package:flutter/material.dart';

import '../../../widgets/rounded_button.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onPressed;
  final Color backgroundColor;

  AuthButton({
    @required this.text,
    @required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(48.0, 6, 48.0, 6.0),
      child: SizedBox(
        height: 40.0,
        child: RoundedButton(
          text: text,
          icon: icon,
          color: Colors.white,
          backgroundColor: backgroundColor,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
