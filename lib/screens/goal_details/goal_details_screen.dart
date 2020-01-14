import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goals_flutter/widgets/goal_card/goal_card.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../models/history_model.dart';
import '../../services/database.dart';
import '../../widgets/inkless_icon_button.dart';
import 'history_list.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalModel goal;

  GoalDetailsScreen({this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<HistoryModel>>(
      create: (_) => db.streamHistories(widget.goal.id),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                  tag: widget.goal.id,
                  child: GoalCard(
                    goal: widget.goal,
                  ),
                ),
                // Appbar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 40.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InklessIconButton(
                        icon: Icons.arrow_back_ios,
                        size: 30.0,
                        onPressed: () => Navigator.pop(context),
                      ),
                      InklessIconButton(
                        icon: FontAwesomeIcons.trashAlt,
                        size: 25.0,
                        onPressed: () {
                          print("delete goal pressed");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            HistoryList(),
          ],
        ),
      ),
    );
  }
}

class GoalDetailsArguments {
  final GoalModel goal;

  GoalDetailsArguments({this.goal});
}
