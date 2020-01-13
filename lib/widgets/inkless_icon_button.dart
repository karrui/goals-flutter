import 'package:flutter/material.dart';

import '../shared/constants.dart';

class InklessIconButton extends StatefulWidget {
  final IconData icon;
  final double size;

  InklessIconButton({this.icon, this.size = 25});

  @override
  _InklessIconButtonState createState() => _InklessIconButtonState();
}

class _InklessIconButtonState extends State<InklessIconButton> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        widget.icon,
        size: widget.size,
        color: _isTapDown ? Theme.of(context).primaryColor : Colors.black,
      ),
      onTap: () {
        setState(() {
          _isTapDown = false;
        });
        Navigator.pushNamed(context, settingsRoute);
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
