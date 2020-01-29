import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../providers/theme.dart';
import '../../services/database.dart';
import '../../shared/route_constants.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/buttons/squircle_text_button.dart';
import '../../utils/modal_bottom_sheet.dart';
import 'add_goal_form.dart';
import 'widgets/goals_list.dart';

class HomeScreen extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    Widget _showAppBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Current goals',
              style: Theme.of(context).textTheme.title,
            ),
            SquircleIconButton(
              iconData: Icons.settings,
              onPressed: () => Navigator.pushNamed(context, settingsRoute),
              iconSize: 24.0,
              height: 50.0,
              width: 50.0,
            )
          ],
        ),
      );
    }

    _showGoalList() {
      return Expanded(
        child: Scrollbar(
          child: GoalsList(),
        ),
      );
    }

    _showAddGoalButton() {
      var themeProvider = Provider.of<ThemeProvider>(context);
      return Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20),
            child: themeProvider.isDarkTheme
                ? SquircleIconButton(
                    width: double.infinity,
                    text: "Add new goal",
                    onPressed: () =>
                        showModalBottomSheetWithChild(context, AddGoalForm()),
                  )
                : SquircleTextButton(
                    text: "Add new goal",
                    onPressed: () =>
                        showModalBottomSheetWithChild(context, AddGoalForm()),
                  ),
          ),
        ],
      );
    }

    return StreamProvider<List<GoalModel>>(
      initialData: [],
      create: (_) => db.streamGoals(user),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showAppBar(),
              _showGoalList(),
              _showAddGoalButton(),
            ],
          ),
        ),
      ),
    );
  }
}
