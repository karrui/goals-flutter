import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/theme.dart';
import '../../services/auth.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../utils/notification_util.dart';
import 'utils/form_validator.dart';
import 'utils/generate_auth_error_message.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  String _errorMessage = "";
  bool isSignInButtonEnabled = false;

  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  TextEditingController emailInputController;
  TextEditingController passwordInputController;
  bool hasBlurredEmailInput;

  @override
  void initState() {
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    emailInputController = TextEditingController();
    passwordInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Widget _showEmailInput() {
    return Form(
      key: _emailFormKey,
      child: Container(
        height: 80.0,
        child: TextFormField(
          autofocus: true,
          autocorrect: false,
          focusNode: emailFocusNode,
          onFieldSubmitted: (_) {
            setState(() {
              hasBlurredEmailInput = true;
            });
            _emailFormKey.currentState.validate();
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
          onChanged: (_) {
            if (_errorMessage != "") {
              setState(() {
                _errorMessage = "";
              });
            }
            if (hasBlurredEmailInput) {
              _emailFormKey.currentState.validate();
            }
            if (passwordInputController.text.length > 0) {
              setState(() {
                isSignInButtonEnabled = _emailFormKey.currentState.validate() &&
                    _passwordFormKey.currentState.validate();
              });
            }
          },
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: "Email address",
            hintText: "hello@example.com",
          ),
          controller: emailInputController,
          validator: emailValidator,
        ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Form(
      key: _passwordFormKey,
      child: Container(
        height: 80.0,
        child: TextFormField(
          focusNode: passwordFocusNode,
          onTap: () {
            setState(() {
              hasBlurredEmailInput = true;
            });
            _emailFormKey.currentState.validate();
          },
          onChanged: (_) {
            if (_errorMessage != "") {
              setState(() {
                _errorMessage = "";
              });
            }
            setState(() {
              isSignInButtonEnabled = _emailFormKey.currentState.validate() &&
                  _passwordFormKey.currentState.validate();
            });
          },
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "correct horse battery staple",
          ),
          controller: passwordInputController,
          validator: passwordValidator,
        ),
      ),
    );
  }

  Widget _showSignInButton(BuildContext context, Map arguments) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return SquircleIconButton(
      width: double.infinity,
      text: "Sign in",
      textColor: themeProvider.isDarkTheme ? null : Colors.white,
      iconColor: themeProvider.isDarkTheme ? null : Colors.white,
      backgroundColor:
          themeProvider.isDarkTheme ? null : Theme.of(context).primaryColorDark,
      enabled: isSignInButtonEnabled,
      onPressed: isSignInButtonEnabled ? () => _handleSignIn(arguments) : null,
    );
  }

  Widget _showErrorMessage(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Future<void> _handleSignIn(Map arguments) async {
    if (_errorMessage != "") {
      setState(() {
        _errorMessage = "";
      });
    }
    try {
      setState(() {
        isSignInButtonEnabled = false;
      });
      final result = await AuthService().signInWithEmailAndPassword(
          emailInputController.text, passwordInputController.text);
      if (arguments != null) {
        if (emailInputController.text == arguments['oldEmail']) {
          await result.linkWithCredential(arguments['credential']);
          NotificationUtil.showSuccessToast("Successfully linked accounts.");
        } else {
          NotificationUtil.showFailureToast(
              "Logged in email address does not match, no linking of accounts was done.");
        }
      }

      // Required to trigger navigation since this screen is stacked on the main screen that changes.
      Navigator.pop(context);
    } on PlatformException catch (error) {
      setState(() {
        _errorMessage = generateAuthErrorMessage(error);
        isSignInButtonEnabled = true;
      });
    }
  }

  Widget _showAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SquircleIconButton(
            iconData: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If arguments were passed in due to merging of providers, we process after signing in.
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _showAppBar(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Sign in",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _showEmailInput(),
                  _showPasswordInput(),
                  SizedBox(
                    height: 25.0,
                  ),
                  _showSignInButton(context, arguments),
                  _showErrorMessage(_errorMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
