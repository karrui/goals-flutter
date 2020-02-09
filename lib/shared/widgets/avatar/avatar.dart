import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  Avatar({
    @required this.child,
    this.height = 60.0,
    this.width = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ClayContainer(
          height: height,
          width: width,
          borderRadius: 30,
          color: Theme.of(context).backgroundColor,
          depth: 8,
          spread: 5,
          child: Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              child: child),
        ),
      ],
    );
  }
}
