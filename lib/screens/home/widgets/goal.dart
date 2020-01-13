import 'package:flutter/material.dart';

import '../../../models/goal_model.dart';
import '../../../utils/number_util.dart';
import 'add_transaction_button.dart';

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
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        // TODO: Allow user selectable locale currency
                        TextSpan(
                          text: '\$',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        TextSpan(
                          text:
                              convertDoubleToCurrencyString(goal.currentAmount),
                          style: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' / \$${convertDoubleToCurrencyString(goal.goalAmount)}',
                        ),
                      ],
                    ),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.end,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                    children: <TextSpan>[
                      TextSpan(text: "You are "),
                      TextSpan(
                          text: convertDoubleToPercentString(
                              goal.currentAmount / goal.goalAmount),
                          style: TextStyle(color: Colors.black)),
                      TextSpan(text: " of the way there!")
                    ],
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
