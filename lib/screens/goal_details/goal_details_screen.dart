import 'package:flutter/material.dart';

import '../../models/goal_model.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalModel goal;

  GoalDetailsScreen({this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(widget.goal.name),
          Text(widget.goal.currentAmount.toString())
        ],
      ),
    );
  }
}

class GoalDetailsArguments {
  final GoalModel goal;

  GoalDetailsArguments(this.goal);
}
