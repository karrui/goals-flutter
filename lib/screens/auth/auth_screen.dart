import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './widgets/auth_button.dart';
import '../../constants.dart';
import '../../widgets/text_button.dart';

class AuthScreen extends StatelessWidget {
  void handleSignIn(BuildContext context) {
    Navigator.pushNamed(context, signInRoute);
  }

  void handleSignUp(BuildContext context) {
    Navigator.pushNamed(context, signUpRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Welcome to Goals!\nSign in to be able to share your goals for others to contribute.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AuthButton(
                  text: 'Sign in with Google',
                  icon: FontAwesomeIcons.google,
                  onPressed: () => print('signin google'),
                ),
                AuthButton(
                  text: 'Sign in with Facebook',
                  icon: FontAwesomeIcons.facebookF,
                  backgroundColor: Color(0xFF3b5998),
                  onPressed: () => print('signin facebook'),
                ),
                AuthButton(
                  text: 'Sign in with email',
                  icon: FontAwesomeIcons.solidEnvelope,
                  backgroundColor: Colors.grey[900],
                  onPressed: () => handleSignIn(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.0,
                      child: TextButton(
                        onPressed: () => handleSignUp(context),
                        text: "Sign up with email",
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                      child: TextButton(
                        onPressed: () => print('guest'),
                        text: "Continue as guest",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
