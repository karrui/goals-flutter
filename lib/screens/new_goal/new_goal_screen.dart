import 'package:flutter/material.dart';

import '../../shared/widgets/app_nav_bar.dart';
import 'add_goal_form.dart';

class NewGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppNavBar(
              title: "New goal",
            ),
            Expanded(
              child: AddGoalForm(),
            ),
          ],
        ),
      ),
    );
  }
}
