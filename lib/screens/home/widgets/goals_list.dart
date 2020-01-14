import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import '../../../shared/route_constants.dart';
import '../../../widgets/goal_card/goal_card.dart';
import '../../goal_details/goal_details_screen.dart';

class GoalsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goals = Provider.of<List<GoalModel>>(context);
    return ListView.builder(
      itemCount: goals != null ? goals.length : 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Hero(
            tag: goals[index].id,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: GoalCard(
                goal: goals[index],
              ),
            ),
          ),
          onTap: () => Navigator.pushNamed(
            context,
            goalDetailsRoute,
            arguments: GoalDetailsArguments(goal: goals[index]),
          ),
        );
      },
    );
  }
}
