import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import './widgets/auth_button.dart';
import '../../constants.dart';
import '../../providers/auth.dart';
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
  var _areButtonsDisabled = false;

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
    final authProvider = Provider.of<Auth>(context, listen: false);
    final result = await authProvider.signInWithGoogle(context);

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
    final authProvider = Provider.of<Auth>(context, listen: false);
    final result = await authProvider.signInWithFacebook(context);

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
        AuthButton(
          text: 'Sign in with Google',
          icon: FontAwesomeIcons.google,
          onPressed: _areButtonsDisabled
              ? null
              : () => _handleSignInWithGoogle(context),
        ),
        AuthButton(
          text: 'Sign in with Facebook',
          icon: FontAwesomeIcons.facebookF,
          backgroundColor: Color(0xFF3b5998),
          onPressed: _areButtonsDisabled
              ? null
              : () => _handleSignInWithFacebook(context),
        ),
        AuthButton(
          text: 'Sign in with email',
          icon: FontAwesomeIcons.solidEnvelope,
          backgroundColor: Colors.grey[900],
          onPressed: _areButtonsDisabled
              ? null
              : () => _handleSignInWithEmail(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.0,
              child: TextButton(
                onPressed: _areButtonsDisabled
                    ? null
                    : () => _handleSignUpWithEmail(context),
                text: "Sign up with email",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
