import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants.dart';
import '../../dummy_data.dart';
import 'widgets/jar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.cog),
            onPressed: () => Navigator.pushNamed(context, settingsRoute),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: dummyJars
              .map((jar) => Jar(
                    jar: jar,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
