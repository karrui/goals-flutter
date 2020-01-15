import 'package:flutter/cupertino.dart';
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
            onPressed: _showDeleteDialog,
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          )
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog() async {
    setState(() {
      _isLoading = true;
    });
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text("Delete goal"),
        content: Text("Are you sure you want to delete this goal?"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              setState(() {
                _isLoading = false;
              });
              return null;
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text("Delete"),
            onPressed: () async {
              Navigator.of(ctx, rootNavigator: true).pop();
              await db.deleteGoal(widget.goal.id);
              Navigator.pop(context);
            },
          ),
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
