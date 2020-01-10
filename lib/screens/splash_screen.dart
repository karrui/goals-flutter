import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'auth/auth_screen.dart';
import 'jars_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((currentUser) => {
          if (currentUser == null)
            {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: AuthScreen(),
                ),
              )
            }
          else
            {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: JarsScreen(),
                ),
              )
            }
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(),
      ),
    );
  }
}
