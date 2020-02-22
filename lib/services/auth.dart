import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

import '../shared/route_constants.dart';
import '../utils/notification_util.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider(providerId: 'apple.com');
        final credential = oAuthProvider.getCredential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _auth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        final updateUser = UserUpdateInfo();
        if (scopes.contains(Scope.fullName)) {
          updateUser.displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
        }
        updateUser.photoUrl = Gravatar(appleIdCredential.email)
            .imageUrl(defaultImage: GravatarImage.retro);
        await firebaseUser.updateProfile(updateUser);
        await FirebaseUserReloader.reloadCurrentUser();
        return firebaseUser;
      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
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
      _showDialog("Google", signInMethods[0], context, email, credential);
      return null;
    }

    try {
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } on PlatformException catch (error) {
      if (error.code != 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        throw error;
      }
      _showDialog("Google", signInMethods[0], context, email, credential);
      return null;
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
        signInFunction = () => Navigator.pushNamed(
              context,
              SIGN_IN_ROUTE,
              arguments: {'credential': credential, 'oldEmail': oldEmail},
            );
        break;
      default:
        throw Exception("Invalid sign in method");
    }

    return showDialog(
        context: context,
        barrierDismissible: false,
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
                    return null;
                  }),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Continue"),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    final authResult = await signInFunction();
                    if (!isEmailSignInMethod &&
                        authResult != null &&
                        authResult.email == oldEmail) {
                      await authResult.linkWithCredential(credential);
                      final result =
                          await _auth.signInWithCredential(credential);
                      NotificationUtil.showSuccessToast(
                          "Successfully linked accounts.");
                      return result.user;
                    } else {
                      if (authResult != null && authResult.email != oldEmail) {
                        NotificationUtil.showFailureToast(
                            "Logged in email address does not match, no linking of accounts was done.");
                      }
                      return null;
                    }
                  }),
            ],
          );
        });
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  Future<FirebaseUser> signUpWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    var currentUser = result.user;
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = email;
    userUpdateInfo.photoUrl =
        Gravatar(email).imageUrl(defaultImage: GravatarImage.retro);
    await currentUser.updateProfile(userUpdateInfo);
    await FirebaseUserReloader.reloadCurrentUser();
    return currentUser;
  }

  Future<void> logout() async {
    var user = await _auth.currentUser();
    var token = await FirebaseMessaging().getToken();
    await DatabaseService().deleteDeviceToken(userId: user.uid, token: token);
    final result = await _auth.signOut();
    return result;
  }
}
