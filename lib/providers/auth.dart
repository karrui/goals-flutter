import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> get user {
    return _auth.currentUser();
  }

  Future<FirebaseUser> signInWithGoogle() async {
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

    final result = await _auth.signInWithCredential(credential);
    notifyListeners();
    return result.user;
  }

  Future<FirebaseUser> signInWithFacebook() async {
    final facebookSignIn = FacebookLogin();
    final facebookSignInResult = await facebookSignIn.logIn(['email']);

    if (facebookSignInResult.status == FacebookLoginStatus.loggedIn) {
      final accessToken = facebookSignInResult.accessToken.token;
      final credential =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      final result = await _auth.signInWithCredential(credential);
      notifyListeners();
      return result.user;
    }
    return null;
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
