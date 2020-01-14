import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../services/database.dart';
import '../../shared/route_constants.dart';
import '../../widgets/buttons/squircle_text_button.dart';
import '../../widgets/buttons/squircle_icon_button.dart';
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
              style: Theme.of(context).textTheme.title,
            ),
            SquircleIconButton(
              iconData: Icons.settings,
              onPressed: () => Navigator.pushNamed(context, settingsRoute),
              iconSize: 24.0,
              height: 50.0,
              width: 50.0,
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
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
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
      return Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
            child: SquircleTextButton(
              text: "Add new goal",
              onPressed: _showAddGoalModalSheet,
            ),
          ),
        ],
      );
    }

    return StreamProvider<List<GoalModel>>(
      create: (_) => db.streamGoals(user),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
