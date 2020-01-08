import 'package:flutter/material.dart';

import './screens/jars_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JarsScreen(),
    );
  }
}
