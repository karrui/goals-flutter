import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../dummy_data.dart';
import '../../widgets/inkless_icon_button.dart';
import 'widgets/jar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Current goals',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      InklessIconButton(
                        icon: FontAwesomeIcons.cog,
                        size: 25.0,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  children: dummyJars.map((jar) => Jar(jar: jar)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
