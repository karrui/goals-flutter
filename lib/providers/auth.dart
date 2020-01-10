import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<FirebaseUser> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    /// returns `null` if sign in is cancelled, so we do nothing
    if (googleUser == null) {
      print("user cancelled");
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print(user);
    return user;
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final facebookSignIn = FacebookLogin();
    final facebookSignInResult = await facebookSignIn.logIn(['email']);

    switch (facebookSignInResult.status) {
      case FacebookLoginStatus.loggedIn:
        final accessToken = facebookSignInResult.accessToken.token;
        final credential =
            FacebookAuthProvider.getCredential(accessToken: accessToken);
        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;
        print(user);
        return user;
      default:
        return null;
    }
  }

  Future<void> logout() async {
    _auth.signOut();
  }
}
