import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/user_util.dart';

class ImageCapture extends StatelessWidget {
  /// Function to call after image file has been obtained.
  final Function(File) onObtainImage;
  final bool enabled;

  ImageCapture({@required this.onObtainImage, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    Future<void> _changeProfilePicture(ImageSource source) async {
      Navigator.pop(context);
      var croppedImage = await UserUtil.getCroppedPicture(source);
      onObtainImage(croppedImage);
    }

    return Positioned(
      bottom: 3,
      right: 3,
      child: GestureDetector(
        onTap: () {
          if (!enabled) return;
          showCupertinoModalPopup(
            context: context,
            builder: (_) {
              return CupertinoActionSheet(
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: Text("Take Photo",
                        style: TextStyle(color: Colors.blue)),
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
          color: enabled
              ? Theme.of(context).buttonColor
              : Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
