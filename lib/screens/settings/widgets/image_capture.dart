import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/user_util.dart';

class ImageCapture extends StatelessWidget {
  /// Function to call after image file has been obtained.
  final Function(File) onObtainImage;
  final bool enabled;

  ImageCapture({@required this.onObtainImage, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    _showEnablePermissionsDialog({@required bool isRequestCamera}) {
      return showPlatformDialog(
        context: context,
        builder: (ctx) => PlatformAlertDialog(
          title: Text(
            "Goals does not have access to your ${isRequestCamera ? 'camera' : 'photos'}. To enable access, tap Settings and turn on ${isRequestCamera ? 'Camera' : 'Photos'}.",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: Platform.isIOS ? "SF Pro Text" : null,
              fontSize: 17,
              letterSpacing: Platform.isIOS ? -0.41 : 0,
            ),
          ),
          actions: <Widget>[
            PlatformDialogAction(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            PlatformDialogAction(
                child: Text("Settings"),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await AppSettings.openAppSettings();
                }),
          ],
        ),
      );
    }

    Future<void> _changeProfilePicture(ImageSource source) async {
      Navigator.pop(context);

      try {
        var croppedImage = await UserUtil.getCroppedPicture(source);
        onObtainImage(croppedImage);
      } on PlatformException catch (err) {
        if (err.code == "camera_access_denied" ||
            err.code == "photo_access_denied") {
          _showEnablePermissionsDialog(
              isRequestCamera: err.code == "camera_access_denied");
        }
        print(err);
      }
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
