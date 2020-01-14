import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import '../../../shared/constants.dart';
import '../../goal_details/goal_details_screen.dart';
import 'goal.dart';

class GoalsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goals = Provider.of<List<GoalModel>>(context);
    return goals != null
        ? ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Hero(
                  tag: goals[index].id,
                  child: Goal(
                    goal: goals[index],
                  ),
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  goalDetailsRoute,
                  arguments: GoalDetailsArguments(goal: goals[index]),
                ),
              );
            },
          )
        : Container();
  }
}
