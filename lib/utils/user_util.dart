import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';

import '../services/database.dart';
import '../services/storage.dart';

class UserUtil {
  /// Helper method to update user's profile image and display name.
  static updateUserProfile(FirebaseUser user,
      {File newProfileImage, String newDisplayName}) async {
    // Early return if both optional params are missing.
    if (newProfileImage == null && newDisplayName == null) return;
    var newUserUpdateInfo = UserUpdateInfo();
    // Upload image to Firebase storage if profile image is given.
    if (newProfileImage != null) {
      var uploadedUrl =
          await StorageService().uploadProfileImage(newProfileImage, user.uid);
      newUserUpdateInfo.photoUrl = uploadedUrl;
    }

    if (newDisplayName != null) {
      newUserUpdateInfo.displayName = newDisplayName;
    }

    await user.updateProfile(newUserUpdateInfo);
    await DatabaseService().updateUser(user.uid, newUserUpdateInfo);

    await FirebaseUserReloader.reloadCurrentUser();
  }
}
