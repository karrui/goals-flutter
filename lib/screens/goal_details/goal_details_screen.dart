import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/add_contribution_sliding_up_panel.dart';
import '../../models/contribution_model.dart';
import '../../models/contributor_model.dart';
import '../../models/goal_model.dart';
import '../../models/user_model.dart';
import '../../providers/current_goal.dart';
import '../../services/database.dart';
import '../../shared/route_constants.dart';
import '../../shared/widgets/app_nav_bar.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/goal_card/goal_card.dart';
import '../../utils/modal_bottom_sheet.dart';
import 'contribution_page_views.dart';
import 'widgets/edit_goal_form.dart';

class GoalDetailsScreen extends StatefulWidget {
  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  final db = DatabaseService();

  Future<void> _showActionSheet(GoalModel goal) async {
    final user = Provider.of<FirebaseUser>(context, listen: false);
    final isUserOwner = user.uid == goal.owner;

    _buildLeaveSheetAction() {
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
                        context, ModalRoute.withName(SPLASH_ROUTE));
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return CupertinoActionSheet(
          actions: <Widget>[
            if (isUserOwner)
              CupertinoActionSheetAction(
                child: const Text(
                  'Edit goal',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  showModalBottomSheetWithChild(
                      context,
                      EditGoalForm(
                        goal: goal,
                      ));
                },
              ),
            _buildLeaveSheetAction(),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var goal = Provider.of<CurrentGoal>(context).goal;
    return MultiProvider(
      providers: [
        StreamProvider<GoalModel>(
          initialData: goal,
          create: (_) => db.streamCurrentGoal(goal.id),
          catchError: (_, __) => goal,
        ),
        StreamProvider<List<ContributionModel>>(
          initialData: [],
          create: (_) => db.streamContributions(goal.id),
        ),
        StreamProvider<Map<String, UserModel>>.value(
          value: db.streamUidsToPhotoUrlsMap(goal.usersWithAccess),
          initialData: {},
        ),
        ProxyProvider2<List<ContributionModel>, Map<String, UserModel>,
            List<ContributorModel>>(
          update: (ctx, contributionList, userModelMap, _) =>
              ContributorModel.fromContributionList(
                  contributionList, userModelMap),
        ),
      ],
      child: Consumer<GoalModel>(
        builder: (ctx, streamedGoal, _) => Scaffold(
          resizeToAvoidBottomPadding: false,
          body: AddContributionSlidingUpPanel(
            goal: streamedGoal,
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  AppNavBar(
                    rightButton: SquircleIconButton(
                      iconData: Icons.more_horiz,
                      onPressed: () => _showActionSheet(streamedGoal),
                      iconSize: 24.0,
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: Hero(
                      tag: streamedGoal.id,
                      child: GoalCard(
                        goal: streamedGoal,
                        showAddButton: false,
                      ),
                    ),
                  ),
                  ContributionPageViews(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
