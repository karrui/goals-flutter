import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './widgets/contribution.dart';
import '../../models/contribution_model.dart';
import '../../models/user_model.dart';
import '../../providers/current_goal.dart';
import '../../services/database.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  final db = DatabaseService();

  bool _isDeleteMode;
  Map<String, ContributionModel> _selectedItems;

  @override
  void initState() {
    super.initState();
    _isDeleteMode = false;
    _selectedItems = Map();
  }

  @override
  Widget build(BuildContext context) {
    final contributions = Provider.of<List<ContributionModel>>(context);
    final contributorsMap = Provider.of<Map<String, UserModel>>(context);
    final goal = Provider.of<CurrentGoal>(context, listen: false).goal;

    _buildActionButtons() {
      if (_isDeleteMode) {
        return [
          SquircleIconButton(
            height: 25,
            width: 35,
            borderRadius: 10,
            enabled: _selectedItems.isNotEmpty,
            iconData: Icons.delete,
            iconColor: Theme.of(context).errorColor,
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => CupertinoAlertDialog(
                  title: Text("Delete contributions"),
                  content: Text(
                      "Are you sure you want to delete the selected contributions?"),
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
                      child: Text("Delete"),
                      onPressed: () {
                        db.deleteContributions(goal.id, _selectedItems);
                        setState(() {
                          _isDeleteMode = false;
                          _selectedItems = Map();
                        });
                        // TODO: Add success/ error notification
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          SquircleIconButton(
            height: 25,
            width: 35,
            borderRadius: 10,
            iconData: Icons.undo,
            onPressed: () {
              setState(() {
                _isDeleteMode = false;
                _selectedItems = Map();
              });
            },
          ),
        ];
      }
      return [
        SquircleIconButton(
          height: 25,
          width: 35,
          borderRadius: 10,
          iconData: Icons.edit,
          enabled: contributions.isNotEmpty,
          onPressed: () {
            setState(() {
              _isDeleteMode = true;
            });
          },
        ),
      ];
    }

    _handleCheckItem(ContributionModel contribution) {
      setState(() {
        if (_selectedItems.containsKey(contribution.id)) {
          _selectedItems.remove(contribution.id);
        } else {
          _selectedItems[contribution.id] = contribution;
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.only(
                left: 36.0, right: 20.0, top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _isDeleteMode
                      ? "${_selectedItems.length} selected"
                      : "Contributions",
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Row(
                  children: <Widget>[
                    ..._buildActionButtons(),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: contributions.isNotEmpty
              ? ListView.builder(
                  itemCount: contributions.length,
                  itemBuilder: (ctx, index) {
                    var contribution = contributions[index];
                    return Contribution(
                      contribution: contribution,
                      createdByUser: contributorsMap[contribution.uid],
                      showCheckBox: _isDeleteMode,
                      onLongPress: (contribution) {
                        setState(() {
                          if (_isDeleteMode) {
                            setState(() {
                              _isDeleteMode = false;
                              _selectedItems = Map();
                            });
                          } else {
                            _isDeleteMode = true;
                          }
                        });
                        if (_isDeleteMode) {
                          _handleCheckItem(contribution);
                        }
                      },
                      onCheckItem: (contribution) =>
                          _handleCheckItem(contribution),
                      isSelected: _selectedItems.containsKey(contribution.id),
                    );
                  },
                )
              : Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 24.0),
                      child: ClayContainer(
                        emboss: true,
                        borderRadius: 10,
                        depth: 10,
                        spread: 10,
                        color: Theme.of(context).primaryColor,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "No contributions yet.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
