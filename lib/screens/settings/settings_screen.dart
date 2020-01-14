import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme.dart';
import '../../services/auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
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
            )
          ],
        ));
  }
}
