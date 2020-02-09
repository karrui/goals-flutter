import 'dart:io';

import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/loading_state.dart';
import '../../../shared/widgets/avatar/image_avatar.dart';
import '../../../shared/widgets/avatar/networked_avatar.dart';
import '../../../shared/widgets/buttons/squircle_text_button.dart';
import '../../../utils/user_util.dart';
import 'image_capture.dart';

class AccountSettingsForm extends StatefulWidget {
  final FirebaseUser user;

  AccountSettingsForm({this.user});

  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  File _currentImage;
  TextEditingController _displayNameInputController;

  @override
  void initState() {
    super.initState();
    _displayNameInputController =
        TextEditingController(text: widget.user.displayName);
  }

  _onObtainImage(File image) {
    setState(() {
      _currentImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _loadingState = Provider.of<LoadingState>(context);

    _handleOnPressed() async {
      _loadingState.isLoading = true;
      if (_formKey.currentState.validate()) {
        var newName = _displayNameInputController.value.text.trim();
        await UserUtil.updateUserProfile(widget.user,
            newDisplayName: newName, newProfileImage: _currentImage);
        await FirebaseUserReloader.reloadCurrentUser();
        Navigator.pop(context);
        _loadingState.isLoading = false;
      } else {
        _loadingState.isLoading = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClayContainer(
          borderRadius: 15,
          color: Theme.of(context).backgroundColor,
          depth: 10,
          spread: 1,
          emboss: true,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 65,
                      width: 65,
                      alignment: Alignment.topLeft,
                      child: _currentImage == null
                          ? NetworkedAvatar(
                              imageUrl: widget.user.photoUrl,
                            )
                          : ImageAvatar(
                              image: _currentImage,
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).backgroundColor,
                        size: 25,
                      ),
                    ),
                    ImageCapture(
                      onObtainImage: _onObtainImage,
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          enabled: !_loadingState.isLoading,
                          autofocus: true,
                          autocorrect: false,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Display Name",
                            hintText: "John Doe",
                            contentPadding: EdgeInsets.symmetric(vertical: 5),
                          ),
                          controller: _displayNameInputController,
                          validator: (val) =>
                              val.isEmpty ? "Name must not be empty" : null,
                        ),
                        TextFormField(
                          initialValue: widget.user.email,
                          enabled: false,
                          style: Theme.of(context).textTheme.overline.copyWith(
                              color: Theme.of(context).primaryColorDark),
                          decoration: InputDecoration(
                            labelText: "Email address",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SquircleTextButton(
            enabled: !_loadingState.isLoading,
            showLoading: true,
            text: "Save changes",
            onPressed: _handleOnPressed,
          ),
        ),
      ],
    );
  }
}
