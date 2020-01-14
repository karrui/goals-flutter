import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goals_flutter/shared/neumorphism/button_box_decoration.dart';

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
        decoration: _isTapDown
            ? buttonBoxDecorationDepressed(context)
            : buttonBoxDecoration(context),
        child: Icon(
          FontAwesomeIcons.plus,
          size: 15.0,
          color: Theme.of(context).textTheme.button.color,
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
