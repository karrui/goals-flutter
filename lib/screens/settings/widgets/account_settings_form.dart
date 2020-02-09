import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';

import '../../../services/database.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/buttons/squircle_text_button.dart';
import 'image_capture.dart';

class AccountSettingsForm extends StatefulWidget {
  final FirebaseUser user;

  AccountSettingsForm({this.user});

  @override
  _AccountSettingsFormState createState() => _AccountSettingsFormState();
}

class _AccountSettingsFormState extends State<AccountSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController displayNameInputController;
  TextEditingController emailInputController;

  @override
  void initState() {
    super.initState();
    displayNameInputController =
        TextEditingController(text: widget.user.displayName);
    emailInputController = TextEditingController(text: widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
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
                      child: Avatar(
                        imageUrl: widget.user.photoUrl,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    ImageCapture(),
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
                          enabled: !_isLoading,
                          autofocus: true,
                          autocorrect: false,
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Display Name",
                            hintText: "Superpringles",
                          ),
                          controller: displayNameInputController,
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
            enabled: !_isLoading,
            text: "Save changes",
            onPressed: _handleOnPressed,
          ),
        ),
      ],
    );
  }

  _handleOnPressed() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      var newName = displayNameInputController.value.text.trim();
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = newName;
      await widget.user.updateProfile(userUpdateInfo);
      await DatabaseService().updateUserDisplayName(widget.user.uid, newName);
      await FirebaseUserReloader.reloadCurrentUser();
      Navigator.pop(context);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
