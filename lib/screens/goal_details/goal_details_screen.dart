import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/add_contribution_sliding_up_panel.dart';
import '../../models/contribution_model.dart';
import '../../models/contributor_model.dart';
import '../../providers/current_goal.dart';
import '../../services/database.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/goal_card/goal_card.dart';
import 'contribution_page_views.dart';

class GoalDetailsScreen extends StatefulWidget {
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
            iconData: Icons.more_horiz,
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
    final goal = Provider.of<CurrentGoal>(context, listen: false).goal;
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
              db.deleteGoal(goal.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goal = Provider.of<CurrentGoal>(context).goal;
    return MultiProvider(
      providers: [
        StreamProvider<List<ContributionModel>>(
          initialData: [],
          create: (_) => db.streamContributions(goal.id),
        ),
        ProxyProvider<List<ContributionModel>, List<ContributorModel>>(
          update: (ctx, contributionList, _) =>
              ContributorModel.fromContributionList(contributionList),
        )
      ],
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: AddContributionSlidingUpPanel(
          goal: goal,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _showAppBar(),
                Hero(
                  tag: goal.id,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: StreamBuilder(
                      stream: db.streamCurrentGoal(goal.id),
                      builder: (_, snapshot) => GoalCard(
                        goal: snapshot.hasData ? snapshot.data : goal,
                        showAddButton: false,
                      ),
                    ),
                  ),
                ),
                ContributionPageViews(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
