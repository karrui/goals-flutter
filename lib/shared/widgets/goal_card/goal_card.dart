import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import '../../../providers/theme.dart';
import '../../../utils/modal_bottom_sheet.dart';
import '../add_contribution_form.dart';
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
    var themeProvider = Provider.of<ThemeProvider>(context);
    return ClayContainer(
      color: Theme.of(context).backgroundColor,
      borderRadius: 25,
      spread: themeProvider.isDarkTheme ? 4 : 5,
      depth: themeProvider.isDarkTheme ? 8 : 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(
                    goal.name.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText1,
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
                          AddContributionForm(
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
            SizedBox(height: 8.0),
            Text(
              "Total Amount Saved",
              style: Theme.of(context).textTheme.overline,
            ),
            SizedBox(height: 4.0),
            AnimatedGoalAmount(
              currentAmount: goal.currentAmount,
              goalAmount: goal.goalAmount,
            ),
            SizedBox(height: 4.0),
            goal.goalAmount == 0
                ? Text("Open goal",
                    style: Theme.of(context).textTheme.overline.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .overline
                            .color
                            .withOpacity(0.5)))
                : AnimatedPercentage(
                    percentage: (goal.currentAmount / goal.goalAmount),
                  ),
          ],
        ),
      ),
    );
  }
}
