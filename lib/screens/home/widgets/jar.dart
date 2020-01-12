import 'package:flutter/material.dart';
import 'package:goals_flutter/models/jar.dart';

class Jar extends StatelessWidget {
  final JarModel jar;

  Jar({this.jar});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(jar.name),
                Text(jar.currentAmount.toString())
              ],
            ),
          ),
        )
      ],
    );
  }
}
