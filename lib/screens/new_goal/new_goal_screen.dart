import 'package:flutter/material.dart';

import '../../shared/widgets/buttons/squircle_icon_button.dart';
import 'add_goal_form.dart';

class NewGoalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _showAppBar() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SquircleIconButton(
              iconData: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              iconSize: 24.0,
              height: 50.0,
              width: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'New Goal',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            SizedBox(
              width: 50.0,
              height: 50.0,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showAppBar(),
            Expanded(
              child: AddGoalForm(),
            ),
          ],
        ),
      ),
    );
  }
}
