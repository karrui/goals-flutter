import 'package:flutter/material.dart';

import 'screens/auth/auth_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'shared/constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authRoute:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case signInRoute:
        return MaterialPageRoute(
            builder: (_) => SignInScreen(), settings: settings);
      case signUpRoute:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case settingsRoute:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
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
