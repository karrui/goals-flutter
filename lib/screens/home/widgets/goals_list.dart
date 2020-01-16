import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import '../../../providers/current_goal.dart';
import '../../../shared/route_constants.dart';
import '../../../shared/widgets/goal_card/goal_card.dart';

class GoalsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<List<GoalModel>>(
      builder: (ctx, goals, child) => ListView.builder(
        itemCount: goals.length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
              child: Hero(
                tag: goals[index].id,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: GoalCard(
                    goal: goals[index],
                  ),
                ),
              ),
              onTap: () {
                Provider.of<CurrentGoal>(context, listen: false).goal =
                    goals[index];
                Navigator.pushNamed(context, goalDetailsRoute);
              });
        },
      ),
    );
  }
}
