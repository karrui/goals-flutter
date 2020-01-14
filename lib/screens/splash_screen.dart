import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_screen.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    bool loggedIn = user != null;

    return Container(
      child: loggedIn ? HomeScreen() : AuthScreen(),
    );
  }
}
