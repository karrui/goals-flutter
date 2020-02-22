import 'package:flutter/material.dart';

import '../../shared/widgets/app_nav_bar.dart';

class TipJarScreen extends StatefulWidget {
  @override
  _TipJarScreenState createState() => _TipJarScreenState();
}

class _TipJarScreenState extends State<TipJarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppNavBar(
              title: 'Tip Jar',
              canGoBack: true,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: Container()),
          ],
        ),
      ),
    );
  }
}
