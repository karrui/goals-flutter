import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../services/auth.dart';
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
          icon: Icon(FontAwesomeIcons.solidEnvelope),
          labelText: "Email address",
          hintText: "hello@example.com",
        ),
        controller: emailInputController,
        validator: emailValidator,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Form(
      key: _passwordFormKey,
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
          icon: Icon(FontAwesomeIcons.lock),
          labelText: "Password",
        ),
        controller: passwordInputController,
        validator: passwordValidator,
      ),
    );
  }

  Widget _showSignUpButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(48.0, 26.0, 48.0, 6.0),
      child: ProgressButton(
        progressWidget: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        defaultWidget: Text(
          "Sign up",
          style: TextStyle(color: Colors.white),
        ),
        borderRadius: 30.0,
        onPressed: isSignUpButtonEnabled ? () => _handleSignUp : null,
        color: Colors.grey[900],
      ),
    );
  }

  Widget _showErrorMessage(String errorMessage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.redAccent),
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
        isSignUpButtonEnabled = false;
      });
      await AuthService().signUpWithEmailAndPassword(
          emailInputController.text, passwordInputController.text);
      // Required to trigger navigation since this screen is stacked on the main screen that changes.
      Navigator.pop(context);
    } on PlatformException catch (error) {
      setState(() {
        _errorMessage = generateAuthErrorMessage(error);
        isSignUpButtonEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up with email"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showEmailInput(),
              _showPasswordInput(),
              _showSignUpButton(context),
              _showErrorMessage(_errorMessage),
            ],
          ),
        ),
      ),
    );
  }
}
