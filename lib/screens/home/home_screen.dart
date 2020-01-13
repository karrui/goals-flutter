import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goals_flutter/screens/home/add_goal_form.dart';
import 'package:goals_flutter/widgets/rounded_button.dart';

import '../../widgets/inkless_icon_button.dart';
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
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0,
                      MediaQuery.of(context).viewInsets.bottom + 20.0),
                  child: AddGoalForm(),
                ),
              ],
            ),
          );
        },
      );
    }

    _showAddGoalButton() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: RoundedButton(
          text: "hello",
          onPressed: _showAddGoalModalSheet,
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
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
