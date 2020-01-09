import 'package:flutter/material.dart';
import 'package:goals_flutter/router.dart';

import './screens/auth/auth_screen.dart';
import 'router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),
      onGenerateRoute: Router.generateRoute,
    );
  }
}
