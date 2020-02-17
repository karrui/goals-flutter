import 'dart:io';

import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/loading_state.dart';
import '../../providers/theme.dart';
import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../shared/route_constants.dart';
import '../../shared/widgets/app_nav_bar.dart';
import '../../shared/widgets/avatar/networked_avatar.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/nav_blocker.dart';
import '../../shared/widgets/toggle_switch.dart';
import '../../utils/url_util.dart';
import '../../utils/user_util.dart';
import 'widgets/image_capture.dart';
import 'widgets/settings_list_tile.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    var _loadingState = Provider.of<LoadingState>(context);

    _launchUrl(String url) async {
      try {
        await UrlUtil.launchURL(url);
      } on PlatformException catch (_) {}
    }

    _onObtainImage(File image) async {
      if (image == null) return;
      _loadingState.isLoading = true;
      // Upload image to Firebase.
      var user = Provider.of<FirebaseUser>(context, listen: false);
      await UserUtil.updateUserProfile(user, newProfileImage: image);
      await FirebaseUserReloader.reloadCurrentUser();
      _loadingState.isLoading = false;
    }

    _showAccountDetails() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
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
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 65,
                          width: 65,
                          alignment: Alignment.topLeft,
                          child: NetworkedAvatar(
                            imageUrl: user.photoUrl,
                            isLoading: _loadingState.isLoading,
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
                        ImageCapture(
                          enabled: !_loadingState.isLoading,
                          onObtainImage: _onObtainImage,
                        ),
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
                      enabled: !_loadingState.isLoading,
                      iconData: Icons.navigate_next,
                      height: 25,
                      width: 35,
                      onPressed: () {
                        Navigator.pushNamed(context, ACCOUNT_SETTINGS_ROUTE);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    _showAppearanceDetails() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Appearance",
              style: Theme.of(context).textTheme.subtitle,
            ),
            SizedBox(
              height: 15,
            ),
            SettingsListTile(
              title: "Enable Dark Mode",
              trailing: GestureDetector(
                onTap: () {
                  themeProvider.isDarkTheme = !themeProvider.isDarkTheme;
                },
                child: ToggleSwitch(
                  isToggled: themeProvider.isDarkTheme,
                ),
              ),
            ),
          ],
        ),
      );
    }

    _showAboutDetails() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "About",
              style: Theme.of(context).textTheme.subtitle,
            ),
            SizedBox(
              height: 15,
            ),
            SettingsListTile(
              title: "Privacy Policy",
              trailing: Icon(Icons.navigate_next),
              onPressed: () => _launchUrl(PRIVACY_URL),
            ),
            SizedBox(
              height: 10,
            ),
            SettingsListTile(
              title: "Terms of Use",
              trailing: Icon(Icons.navigate_next),
              onPressed: () => _launchUrl(TERMS_URL),
            ),
          ],
        ),
      );
    }

    return NavBlocker(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppNavBar(
                title: "Settings",
                canGoBack: false,
                rightButton: SquircleIconButton(
                  enabled: !_loadingState.isLoading,
                  iconData: Icons.close,
                  onPressed: () => Navigator.pop(context),
                  iconSize: 24.0,
                  height: 50.0,
                  width: 50.0,
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    if (user != null) _showAccountDetails(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _showAppearanceDetails(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _showAboutDetails(),
                    SizedBox(
                      height: 40.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SquircleIconButton(
                        enabled: !_loadingState.isLoading,
                        text: "Logout",
                        onPressed: () {
                          AuthService().logout();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
