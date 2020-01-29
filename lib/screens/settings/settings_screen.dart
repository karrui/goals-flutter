import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme.dart';
import '../../services/auth.dart';
import '../../shared/widgets/avatar.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/toggle_switch.dart';
import 'account_settings_screen.dart';
import 'widgets/image_capture.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget _showAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Settings',
            style: Theme.of(context).textTheme.title,
          ),
          SquircleIconButton(
            iconData: Icons.close,
            onPressed: () => Navigator.pop(context),
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          )
        ],
      ),
    );
  }

  _showAccountDetails(FirebaseUser user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Account",
          style: Theme.of(context).textTheme.subtitle,
        ),
        SizedBox(
          height: 10,
        ),
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
                        imageUrl: user.photoUrl,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0.5,
                      child: Icon(
                        Icons.camera_alt,
                        color: Theme.of(context).backgroundColor,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.displayName,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.overline,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SquircleIconButton(
                  iconData: Icons.navigate_next,
                  height: 25,
                  width: 35,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AccountSettingsScreen()));
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _showAppearanceDetails(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          "Appearance",
          style: Theme.of(context).textTheme.subtitle,
        ),
        SizedBox(
          height: 10,
        ),
        ClayContainer(
          borderRadius: 15,
          color: Theme.of(context).backgroundColor,
          depth: 10,
          spread: 1,
          emboss: true,
          child: ListTile(
            title: Text('Enable Dark Mode'),
            trailing: GestureDetector(
              onTap: () {
                themeProvider.isDarkTheme = !themeProvider.isDarkTheme;
              },
              child: ToggleSwitch(
                isToggled: themeProvider.isDarkTheme,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showAppBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: ListView(
                  children: <Widget>[
                    user != null ? _showAccountDetails(user) : Container(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _showAppearanceDetails(themeProvider),
                    SizedBox(
                      height: 40.0,
                    ),
                    SquircleIconButton(
                      text: "Logout",
                      onPressed: () {
                        AuthService().logout();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
