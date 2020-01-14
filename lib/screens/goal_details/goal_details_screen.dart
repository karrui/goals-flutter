import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../models/history_model.dart';
import '../../services/database.dart';
import '../../widgets/buttons/squircle_icon_button.dart';
import '../../widgets/goal_card/goal_card.dart';
import 'history_list.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalModel goal;

  GoalDetailsScreen({this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final db = DatabaseService();

  Widget _showAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SquircleIconButton(
            iconData: Icons.arrow_back,
            onPressed: () => Navigator.pop(context),
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          ),
          SquircleIconButton(
            iconData: Icons.delete_outline,
            iconColor: Theme.of(context).errorColor,
            onPressed: () => print("delete pressed"),
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HistoryModel>>(
      create: (_) => db.streamHistories(widget.goal.id),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _showAppBar(),
              Hero(
                tag: widget.goal.id,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: GoalCard(
                    goal: widget.goal,
                    showAddButton: false,
                  ),
                ),
              ),
              HistoryList(),
              SquircleIconButton(
                iconData: FontAwesomeIcons.plus,
                onPressed: () => print("add transaction pressed"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalDetailsArguments {
  final GoalModel goal;

  GoalDetailsArguments({this.goal});
}
