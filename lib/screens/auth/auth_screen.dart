import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/auth.dart';
import '../../shared/route_constants.dart';
import '../../widgets/animated_progress_button.dart';
import '../../widgets/text_button.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(48.0, 24.0, 48.0, 6.0),
              child: Center(
                child: Text("Goals logo here"),
              ),
            ),
            SvgPicture.asset(
              'assets/images/signInSavings.svg',
              semanticsLabel: 'Sign In Savings Image',
              height: 250,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(48.0, 24.0, 48.0, 24.0),
                  child: Center(
                    child: Text(
                      'Welcome to Goals!\nSign in to start goals and to be able to share your goals for others to contribute.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AuthButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthButtons extends StatefulWidget {
  @override
  _AuthButtonsState createState() => _AuthButtonsState();
}

class _AuthButtonsState extends State<AuthButtons> {
  static AuthService _authService = AuthService();
  bool _areButtonsDisabled = false;

  void _handleSignInWithEmail(BuildContext context) {
    Navigator.pushNamed(context, signInRoute);
  }

  void _handleSignUpWithEmail(BuildContext context) {
    Navigator.pushNamed(context, signUpRoute);
  }

  void _handleSignInWithGoogle(BuildContext context) async {
    setState(() {
      _areButtonsDisabled = true;
    });

    final result = await _authService.signInWithGoogle(context);

    // Only set back to disabled if there were errors
    if (result == null) {
      setState(() {
        _areButtonsDisabled = false;
      });
    }
  }

  void _handleSignInWithFacebook(BuildContext context) async {
    setState(() {
      _areButtonsDisabled = true;
    });

    final result = await _authService.signInWithFacebook(context);

    // Only set back to disabled if there were errors
    if (result == null) {
      setState(() {
        _areButtonsDisabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedProgressButton(
          text: "Sign in with Google",
          backgroundColor: Colors.blue,
          iconData: FontAwesomeIcons.google,
          enabled: !_areButtonsDisabled,
          onPressed: () => _handleSignInWithGoogle(context),
        ),
        AnimatedProgressButton(
          text: 'Sign in with Facebook',
          iconData: FontAwesomeIcons.facebookSquare,
          backgroundColor: Color(0xFF3b5998),
          enabled: !_areButtonsDisabled,
          onPressed: () => _handleSignInWithFacebook(context),
        ),
        AnimatedProgressButton(
          text: 'Sign in with email',
          iconData: FontAwesomeIcons.solidEnvelope,
          backgroundColor: Colors.grey[900],
          enabled: !_areButtonsDisabled,
          onPressed: () => _handleSignInWithEmail(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextButton(
            text: "Sign up with email",
            onPressed: _areButtonsDisabled
                ? null
                : () => _handleSignUpWithEmail(context),
          ),
        ),
      ],
    );
  }
}
