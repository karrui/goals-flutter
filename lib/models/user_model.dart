import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;

  UserModel({
    this.uid,
    this.displayName,
    this.photoUrl,
    this.email,
  });

  String toString() {
    return 'uid: $uid, displayName: $displayName, photoUrl: $photoUrl, email: $email';
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return UserModel(
        uid: data['uid'],
        displayName: data['displayName'],
        photoUrl: data['photoUrl'],
        email: data['email']);
  }
}
