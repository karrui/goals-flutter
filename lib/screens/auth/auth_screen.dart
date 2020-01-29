import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/theme.dart';
import '../../services/auth.dart';
import '../../shared/route_constants.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/text_button.dart';

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
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image(
                image: AssetImage('assets/images/signInSavings.png'),
                excludeFromSemantics: true,
              ),
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
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
          SquircleIconButton(
            alignment: MainAxisAlignment.spaceBetween,
            iconSize: 20,
            width: double.infinity,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            iconColor: Colors.white,
            text: "Sign in with Google",
            iconData: FontAwesomeIcons.google,
            enabled: !_areButtonsDisabled,
            onPressed: () => _handleSignInWithGoogle(context),
          ),
          SizedBox(
            height: 10.0,
          ),
          SquircleIconButton(
            alignment: MainAxisAlignment.spaceBetween,
            iconSize: 20,
            width: double.infinity,
            text: "Sign in with Facebook",
            backgroundColor: Color(0xFF3b5998),
            textColor: Colors.white,
            iconColor: Colors.white,
            iconData: FontAwesomeIcons.facebookSquare,
            enabled: !_areButtonsDisabled,
            onPressed: () => _handleSignInWithFacebook(context),
          ),
          SizedBox(
            height: 10.0,
          ),
          SquircleIconButton(
            alignment: MainAxisAlignment.spaceBetween,
            iconSize: 20,
            width: double.infinity,
            text: "Sign in with email",
            textColor: themeProvider.isDarkTheme ? null : Colors.white,
            iconColor: themeProvider.isDarkTheme ? null : Colors.white,
            backgroundColor: themeProvider.isDarkTheme
                ? null
                : Theme.of(context).primaryColorDark,
            iconData: FontAwesomeIcons.solidEnvelope,
            enabled: !_areButtonsDisabled,
            onPressed: () => _handleSignInWithEmail(context),
          ),
          SizedBox(
            height: 15.0,
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
      ),
    );
  }
}
