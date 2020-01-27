import 'package:flutter/material.dart';
import 'package:goals_flutter/shared/decorations/squircle_button_box_decoration.dart';

class StaticSquircleButton extends StatelessWidget {
  final double height;
  final double width;
  final bool isActive;
  final Widget child;

  StaticSquircleButton({
    this.height = 40.0,
    this.width = double.infinity,
    this.isActive = false,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: isActive
          ? squircleButtonBoxDecorationDepressed(context)
          : squircleButtonBoxDecoration(context),
      child: Center(
        child: child,
      ),
    );
  }
}
