import 'package:flutter/material.dart';

import '../../../models/goal_model.dart';
import 'add_transaction_button.dart';
import 'animated_goal_amount.dart';
import 'animated_percentage.dart';

class Goal extends StatelessWidget {
  final GoalModel goal;

  Goal({this.goal});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(35, 25, 35, 25),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        goal.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    // This box is for a gap so that it will not eat into the add transaction button.
                    SizedBox(
                      width: 60.0,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 5.0),
                  child: AnimatedGoalAmount(
                    currentAmount: goal.currentAmount,
                    totalAmount: goal.goalAmount,
                    primaryTextStyle: const TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AnimatedPercentage(
                  percentage: goal.currentAmount / goal.goalAmount,
                  primaryTextStyle: TextStyle(color: Colors.black),
                  secondaryTextStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 40,
          top: 30,
          child: AddTransactionButton(),
        )
      ],
    );
  }
}
