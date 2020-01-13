import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import 'goal.dart';

class GoalList extends StatefulWidget {
  @override
  _GoalListState createState() => _GoalListState();
}

class _GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<GoalModel>>(context);

    return goals == null
        ? Container()
        : ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              return Goal(
                goal: goals[index],
              );
            },
          );
  }
}
