import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../services/database.dart';
import '../../shared/constants.dart';
import '../../widgets/animated_progress_button.dart';
import '../../widgets/inkless_icon_button.dart';
import 'add_goal_form.dart';
import 'widgets/goals_list.dart';

class HomeScreen extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

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
          child: GoalsList(),
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
                AddGoalForm(),
              ],
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

    return StreamProvider<List<GoalModel>>(
      create: (_) => db.streamGoals(user),
      child: Scaffold(
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
      ),
    );
  }
}
