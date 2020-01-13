import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import '../../../shared/constants.dart';
import '../../goal_details/goal_details_screen.dart';
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
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  goalDetailsRoute,
                  arguments: GoalDetailsArguments(goals[index]),
                ),
                child: Hero(
                  tag: goals[index].id,
                  // Prevents RenderFlex overflow if the child is of type Material, see https://stackoverflow.com/questions/56793821/hero-animation-producing-renderbox-overflow/56831537
                  child: Material(
                    type: MaterialType.transparency,
                    child: Goal(
                      goal: goals[index],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
