import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import 'utils/form_validator.dart';
import 'widgets/auth_button.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

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
      child: TextFormField(
        autofocus: true,
        focusNode: emailFocusNode,
        onFieldSubmitted: (_) {
          setState(() {
            hasBlurredEmailInput = true;
          });
          _emailFormKey.currentState.validate();
          FocusScope.of(context).requestFocus(passwordFocusNode);
        },
        onChanged: (_) {
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
          setState(() {
            isSignInButtonEnabled = _emailFormKey.currentState.validate() &&
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

  Widget _showSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: AuthButton(
        text: 'Sign in',
        backgroundColor: Colors.grey[900],
        onPressed: isSignInButtonEnabled
            ? () => Provider.of<Auth>(context, listen: false)
                .signInWithEmailAndPassword(
                    emailInputController.text, passwordInputController.text)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign in with email"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _showEmailInput(),
              _showPasswordInput(),
              _showSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
