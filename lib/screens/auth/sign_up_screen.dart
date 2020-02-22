import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../routes/constants.dart';
import '../../services/auth.dart';
import '../../shared/widgets/app_nav_bar.dart';
import '../../shared/widgets/buttons/squircle_text_button.dart';
import 'utils/form_validator.dart';
import 'utils/generate_auth_error_message.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  String _errorMessage = "";
  bool isSignUpButtonEnabled = false;
  bool isLoading = false;

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
                isSignUpButtonEnabled = _emailFormKey.currentState.validate() &&
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
              isSignUpButtonEnabled = _emailFormKey.currentState.validate() &&
                  _passwordFormKey.currentState.validate();
            });
          },
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            labelText: "Password",
            hintText: "Password should be at least 6 characters",
          ),
          controller: passwordInputController,
          validator: passwordValidator,
        ),
      ),
    );
  }

  Widget _showSignUpButton(BuildContext context) {
    return SquircleTextButton(
      text: "Sign in",
      onPressed: isSignUpButtonEnabled ? () => _handleSignUp() : null,
      enabled: !isLoading && isSignUpButtonEnabled,
      showLoading: isSignUpButtonEnabled && isLoading,
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

  Future<void> _handleSignUp() async {
    if (_errorMessage != "") {
      setState(() {
        _errorMessage = "";
      });
    }
    try {
      setState(() {
        isLoading = true;
      });
      await AuthService().signUpWithEmailAndPassword(
          emailInputController.text, passwordInputController.text);
      Navigator.pushNamedAndRemoveUntil(context, SPLASH_ROUTE, (_) => false);
    } on PlatformException catch (error) {
      setState(() {
        _errorMessage = generateAuthErrorMessage(error);
        isSignUpButtonEnabled = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppNavBar(
              title: "Sign up",
              disabled: isLoading,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _showEmailInput(),
                  _showPasswordInput(),
                  SizedBox(
                    height: 25.0,
                  ),
                  _showSignUpButton(context),
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
