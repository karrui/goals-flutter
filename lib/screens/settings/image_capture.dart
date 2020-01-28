import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  Future _pickImage(ImageSource source) async {
    Navigator.pop(context);
    var image = await ImagePicker.pickImage(source: source);
    if (image == null) return;

    var croppedImage = await _cropImage(image);

    if (croppedImage == null) return;

    // Upload image to Firebase
  }

  Future<File> _cropImage(File image) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: image.path,
      cropStyle: CropStyle.circle,
    );

    return cropped;
  }

  _showActionSheet() {}

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
                    child: Text("Camera"),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  CupertinoActionSheetAction(
                    child: Text("Choose Photo"),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.camera_alt,
          size: 20,
        ),
      ),
    );
  }
}
