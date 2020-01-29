import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './widgets/add_contribution_sliding_up_panel.dart';
import '../../models/contribution_model.dart';
import '../../models/contributor_model.dart';
import '../../models/user_model.dart';
import '../../providers/current_goal.dart';
import '../../services/database.dart';
import '../../shared/route_constants.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/goal_card/goal_card.dart';
import 'contribution_page_views.dart';

class GoalDetailsScreen extends StatefulWidget {
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
            iconData: Icons.more_horiz,
            onPressed: _showActionSheet,
            iconSize: 24.0,
            height: 50.0,
            width: 50.0,
          )
        ],
      ),
    );
  }

  Future<void> _showActionSheet() async {
    final goal = Provider.of<CurrentGoal>(context, listen: false).goal;
    final user = Provider.of<FirebaseUser>(context, listen: false);

    _buildLeaveSheetAction() {
      var isUserOwner = user.uid == goal.owner;

      return CupertinoActionSheetAction(
        isDestructiveAction: true,
        child: Text(isUserOwner ? 'Delete goal' : 'Leave goal'),
        onPressed: () {
          Navigator.pop(context);
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => CupertinoAlertDialog(
                    title: Text(isUserOwner ? 'Delete goal' : 'Leave goal'),
                    content: Text(
                        "Are you sure you want to ${isUserOwner ? 'delete' : 'leave'} this goal?"),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                          return null;
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text(isUserOwner ? 'Delete' : 'Leave'),
                        onPressed: () {
                          isUserOwner
                              ? db.deleteGoal(goal.id)
                              : db.leaveGoal(goal.id, user.uid);
                          Navigator.popUntil(
                              context, ModalRoute.withName(splashRoute));
                        },
                      ),
                    ],
                  ));
        },
      );
    }

    return showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: const Text('Edit goal'),
                onPressed: () {},
              ),
              _buildLeaveSheetAction(),
              CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
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
        StreamProvider<Map<String, UserModel>>(
          initialData: {},
          create: (_) => db.streamUidToPhotoUrlMap(goal),
        ),
        ProxyProvider2<List<ContributionModel>, Map<String, UserModel>,
            List<ContributorModel>>(
          update: (ctx, contributionList, userModelMap, _) =>
              ContributorModel.fromContributionList(
                  contributionList, userModelMap),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16.0),
                  child: StreamBuilder(
                    stream: db.streamCurrentGoal(goal.id),
                    builder: (_, snapshot) => Hero(
                      tag: goal.id,
                      child: GoalCard(
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
