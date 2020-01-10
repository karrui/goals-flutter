import 'package:flutter/material.dart';

import 'constants.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/jars_screen.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => JarsScreen());
      case authRoute:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case signInRoute:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
