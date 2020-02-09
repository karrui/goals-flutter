import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'static_squircle_button.dart';

class SquircleTextButton extends StatefulWidget {
  final double height;
  final double width;
  final bool enabled;
  final bool showLoading;
  final String text;
  final Function onPressed;

  SquircleTextButton({
    this.height = 40.0,
    this.width = double.infinity,
    this.enabled = true,
    this.showLoading = false,
    @required this.text,
    @required this.onPressed,
  });

  @override
  _SquircleTextButtonState createState() => _SquircleTextButtonState();
}

class _SquircleTextButtonState extends State<SquircleTextButton> {
  bool _isTapDown = false;

  _buildChild() {
    if (widget.showLoading && !widget.enabled) {
      return SpinKitThreeBounce(
        color: Theme.of(context).disabledColor,
        size: 20.0,
      );
    }

    return Text(
      widget.text,
      style: Theme.of(context).textTheme.subhead.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColorLight),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: StaticSquircleButton(
        height: widget.height,
        width: widget.width,
        isActive: _isTapDown,
        enabled: widget.enabled,
        child: _buildChild(),
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
