import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> get user {
    return _auth.currentUser();
  }

  Future<FirebaseUser> signInWithGoogle(BuildContext context) async {
    final googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    /// returns `null` if sign in is cancelled, so we do nothing
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    /// Since `@gmail` accounts are a trusted provider, it will replace any other sign ins without errors. See https://stackoverflow.com/questions/40766312/firebase-overwrites-signin-with-google-account.
    /// Preemptively check if user as already signed in with other providers.
    final httpClient = new HttpClient();
    final googleRequest = await httpClient.getUrl(Uri.parse(
        "https://www.googleapis.com/oauth2/v1/userinfo?access_token=${googleAuth.accessToken}"));
    final googleResponse = await googleRequest.close();
    final googleResponseJSON =
        json.decode((await googleResponse.transform(utf8.decoder).single));
    final email = googleResponseJSON["email"];
    // Now we have both credential and email that is required for linking
    final signInMethods =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email);
    if (signInMethods.length > 0) {
      return _showDialog(
          "Google", signInMethods[0], context, email, credential);
    }

    try {
      final result = await _auth.signInWithCredential(credential);
      notifyListeners();
      return result.user;
    } on PlatformException catch (error) {
      if (error.code != 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        throw error;
      }
      _showDialog("Google", signInMethods[0], context, email, credential);
    }
  }

  Future<FirebaseUser> signInWithFacebook(BuildContext context) async {
    final facebookSignIn = FacebookLogin();
    final FacebookLoginResult facebookSignInResult =
        await facebookSignIn.logIn(['email']);

    if (facebookSignInResult.status == FacebookLoginStatus.loggedIn) {
      final accessToken = facebookSignInResult.accessToken.token;
      final credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      try {
        final result = await _auth.signInWithCredential(credential);
        notifyListeners();
        return result.user;
      } on PlatformException catch (error) {
        if (error.code != 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
          throw error;
        }
        // Retrieve email that already exists in Firebase
        final httpClient = new HttpClient();
        final graphRequest = await httpClient.getUrl(Uri.parse(
            "https://graph.facebook.com/v2.12/me?fields=email&access_token=$accessToken"));
        final graphResponse = await graphRequest.close();
        final graphResponseJSON =
            json.decode((await graphResponse.transform(utf8.decoder).single));
        final email = graphResponseJSON["email"];
        // Now we have both credential and email that is required for linking
        final signInMethods = await FirebaseAuth.instance
            .fetchSignInMethodsForEmail(email: email);
        _showDialog("Facebook", signInMethods[0], context, email, credential);
      }
    }
    return null;
  }

  Future _showDialog(String failedSignInDisplayName, String signInMethod,
      BuildContext context, String oldEmail, AuthCredential credential) {
    String signInDisplayName;
    bool isEmailSignInMethod = false;
    Function signInFunction;

    switch (signInMethod) {
      case "google.com":
        signInDisplayName = "Google";
        signInFunction = signInWithGoogle;
        break;
      case "facebook.com":
        signInDisplayName = "Facebook";
        signInFunction = () => signInWithFacebook(context);
        break;
      case "password":
        signInDisplayName = "email";
        isEmailSignInMethod = true;
        signInFunction = () => Navigator.pushNamed(context, signInRoute,
            arguments: {'credential': credential, 'oldEmail': oldEmail});
        break;
      default:
        throw Exception("Invalid sign in method");
    }

    return showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Different sign up method found"),
            content: Text(
                "Sign in with your $signInDisplayName account first to also link $failedSignInDisplayName to your Goals account"),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    return;
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Continue"),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    final authResult = await signInFunction();
                    if (!isEmailSignInMethod && authResult.email == oldEmail) {
                      await authResult.linkWithCredential(credential);
                      final result =
                          await _auth.signInWithCredential(credential);
                      notifyListeners();
                      return result.user;
                    } else
                      return null;
                  }),
            ],
          );
        });
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();
    return result.user;
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    notifyListeners();
    return result.user;
  }

  Future logout() async {
    final result = await _auth.signOut();
    notifyListeners();
    return result;
  }
}
