import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddTransactionButton extends StatefulWidget {
  @override
  _AddTransactionButtonState createState() => _AddTransactionButtonState();
}

class _AddTransactionButtonState extends State<AddTransactionButton> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: _isTapDown ? Color(0xFFD7DEFA) : Color(0xFFEEF1FD),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Icon(
          FontAwesomeIcons.plus,
          size: 15.0,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () {
        setState(() {
          _isTapDown = false;
        });
        print("add transaction clicked");
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
