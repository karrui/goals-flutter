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
      builder: (ctx, goals, child) => goals.isNotEmpty
          ? ListView.builder(
              itemCount: goals.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                    child: Hero(
                      tag: goals[index].id,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
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
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Opacity(
                      opacity: 0.9,
                      child: Image(
                          image: AssetImage('assets/images/emptyGoals.png')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No goals yet",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(letterSpacing: 0.15),
                  ),
                ),
                Text("Add a goal and it will show up here.")
              ],
            ),
    );
  }
}
