import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../models/history_model.dart';
import '../../services/database.dart';
import '../../widgets/buttons/squircle_icon_button.dart';
import '../../widgets/goal_card/goal_card.dart';
import 'transaction_add_page_views.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalModel goal;

  GoalDetailsScreen({this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final db = DatabaseService();

  bool _isLoading = false;

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
            enabled: !_isLoading,
            iconData: Icons.delete_outline,
            iconColor: Theme.of(context).errorColor,
            onPressed: _deleteGoal,
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          )
        ],
      ),
    );
  }

  _deleteGoal() async {
    setState(() {
      _isLoading = true;
    });
    await db.deleteGoal(widget.goal.id);
    Navigator.pop(context);
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
              TransactionAddPageViews(),
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
