import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../utils/user_util.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  Future<void> _changeProfilePicture(ImageSource source) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(
        source: source, imageQuality: 60, maxHeight: 800, maxWidth: 800);
    if (image == null) return;
    var croppedImage = await _cropImage(image);
    if (croppedImage == null) return;
    // Upload image to Firebase.
    var user = Provider.of<FirebaseUser>(context, listen: false);
    await UserUtil.updateUserProfile(user, newProfileImage: croppedImage);
    await FirebaseUserReloader.reloadCurrentUser();
  }

  Future<File> _cropImage(File image) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.circle,
    );

    return cropped;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 3,
      right: 3,
      child: GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (_) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text("Camera", style: TextStyle(color: Colors.blue)),
                    onPressed: () => _changeProfilePicture(ImageSource.camera),
                  ),
                  CupertinoActionSheetAction(
                    child: Text("Choose Photo",
                        style: TextStyle(color: Colors.blue)),
                    onPressed: () => _changeProfilePicture(ImageSource.gallery),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  isDefaultAction: true,
                  child: Text("Cancel", style: TextStyle(color: Colors.blue)),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.camera_alt,
          size: 20,
          color: Theme.of(context).buttonColor,
        ),
      ),
    );
  }
}
