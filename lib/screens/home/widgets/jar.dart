import 'package:flutter/material.dart';

class Jar extends StatelessWidget {
  final String name;

  Jar({this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Text(name),
          ),
        )
      ],
    );
  }
}
