import 'package:flutter/material.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/goal_details/goal_details_screen.dart';
import '../screens/new_goal/new_goal_screen.dart';
import '../screens/settings/account_settings_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash_screen.dart';
import './constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Some routes do not have settings because we don't want to restore state of the route, since they depend on prior data.
    switch (settings.name) {
      case SPLASH_ROUTE:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AUTH_ROUTE:
        return MaterialPageRoute(
            builder: (_) => AuthScreen(), settings: settings);
      case SIGN_IN_ROUTE:
        return MaterialPageRoute(
            builder: (_) => SignInScreen(), settings: settings);
      case SIGN_UP_ROUTE:
        return MaterialPageRoute(
            builder: (_) => SignUpScreen(), settings: settings);
      case SETTINGS_ROUTE:
        return MaterialPageRoute(
            builder: (_) => SettingsScreen(), settings: settings);
      case ACCOUNT_SETTINGS_ROUTE:
        return MaterialPageRoute(
            builder: (_) => AccountSettingsScreen(), settings: settings);
      case GOAL_DETAILS_ROUTE:
        return MaterialPageRoute(builder: (_) => GoalDetailsScreen());
      case NEW_GOAL_ROUTE:
        return MaterialPageRoute(builder: (_) => NewGoalScreen());
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
