import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Enable Feature'),
              trailing: Checkbox(
                value: true,
                onChanged: (val) {},
              ),
              onTap: () {},
            ),
            FlatButton(
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.pop(context);
              },
              child: Text("Logout"),
            )
          ],
        ));
  }
}
