import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme.dart';
import '../../services/auth.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';

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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showAppBar(),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Enable Dark Theme'),
                    trailing: Checkbox(
                        value: themeProvider.isDarkTheme,
                        onChanged: (bool value) {
                          themeProvider.isDarkTheme = value;
                        }),
                    onTap: () {},
                  ),
                  FlatButton(
                    onPressed: () {
                      AuthService().logout();
                      Navigator.pop(context);
                    },
                    child: Text("Logout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
