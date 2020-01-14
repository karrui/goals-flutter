import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'screens/auth/auth_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/goal_details/goal_details_screen.dart';
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
      case goalDetailsRoute:
        final GoalDetailsArguments args = settings.arguments;
        return PageTransition(
            child: GoalDetailsScreen(goal: args.goal),
            type: PageTransitionType.fade,
            duration: Duration(milliseconds: 200));
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
