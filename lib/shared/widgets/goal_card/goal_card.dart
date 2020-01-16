import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/goal_model.dart';
import '../../../shared/decorations/card_box_decoration.dart';
import '../../../utils/modal_bottom_sheet.dart';
import '../add_transaction_form.dart';
import '../buttons/squircle_icon_button.dart';
import 'animated_goal_amount.dart';
import 'animated_percentage.dart';

class GoalCard extends StatelessWidget {
  final GoalModel goal;
  final bool showAddButton;

  GoalCard({
    @required this.goal,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: cardBoxDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  goal.name.toUpperCase(),
                  style: Theme.of(context).textTheme.body2,
                  maxLines: null,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              showAddButton
                  ? SquircleIconButton(
                      iconData: FontAwesomeIcons.plus,
                      onPressed: () => showModalBottomSheetWithChild(
                        context,
                        AddTransactionForm(
                          goal: goal,
                          onSubmitSuccess: Navigator.of(context).pop,
                        ),
                      ),
                    )
                  : SizedBox(
                      // Emulate button space for card height consistency.
                      height: 40.0,
                      width: 40.0,
                    ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            "Total Amount Saved",
            style: Theme.of(context).textTheme.overline,
          ),
          SizedBox(height: 4.0),
          AnimatedGoalAmount(
            currentAmount: goal.currentAmount,
            goalAmount: goal.goalAmount,
          ),
          SizedBox(height: 8.0),
          AnimatedPercentage(
            percentage: (goal.currentAmount / goal.goalAmount),
          ),
          SizedBox(
            height: 8.0,
          )
        ],
      ),
    );
  }
}
