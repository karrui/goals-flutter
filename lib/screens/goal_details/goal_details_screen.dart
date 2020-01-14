import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/goal_model.dart';
import '../../widgets/inkless_icon_button.dart';
import '../home/widgets/goal.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalModel goal;

  GoalDetailsScreen({this.goal});

  @override
  _GoalDetailsScreenState createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Hero(
                tag: widget.goal.id,
                child: Goal(
                  goal: widget.goal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  margin: EdgeInsets.all(0),
                  goalPadding: EdgeInsets.fromLTRB(35, 100, 35, 25),
                  showAddTransactionButton: false,
                  showBoxShadow: true,
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
          )
        ],
      ),
    );
  }
}

class GoalDetailsArguments {
  final GoalModel goal;

  GoalDetailsArguments({this.goal});
}
