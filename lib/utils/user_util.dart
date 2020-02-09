import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../services/database.dart';
import '../services/storage.dart';

class UserUtil {
  static Future<File> getCroppedPicture(ImageSource source) async {
    var image = await ImagePicker.pickImage(
        source: source, imageQuality: 60, maxHeight: 800, maxWidth: 800);
    if (image == null) return image;
    var cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.circle,
    );
    return cropped;
  }

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
