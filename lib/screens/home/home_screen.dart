import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/database.dart';
import '../../shared/constants.dart';
import '../../widgets/animated_progress_button.dart';
import '../../widgets/inkless_icon_button.dart';
import 'add_goal_form.dart';
import 'widgets/goal_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _showAppBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  onPressed: () => Navigator.pushNamed(context, settingsRoute),
                ),
              ],
            )
          ],
        ),
      );
    }

    _showGoalList() {
      return Expanded(
        child: Scrollbar(
          child: GoalList(),
        ),
      );
    }

    void _showAddGoalModalSheet() {
      final db = Provider.of<Database>(context, listen: false);
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Provider.value(
            value: db,
            child: SafeArea(
              child: Wrap(
                children: <Widget>[
                  AddGoalForm(),
                ],
              ),
            ),
          );
        },
      );
    }

    _showAddGoalButton() {
      return AnimatedProgressButton(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
        backgroundColor: Colors.grey[900],
        text: "Add new goal",
        onPressed: _showAddGoalModalSheet,
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _showAppBar(),
            _showGoalList(),
            _showAddGoalButton(),
          ],
        ),
      ),
    );
  }
}
