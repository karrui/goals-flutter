import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/contributor_model.dart';
import '../../../providers/theme.dart';
import '../../../services/database.dart';
import '../../../shared/route_constants.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../utils/number_util.dart';

class Contributor extends StatefulWidget {
  final ContributorModel contributor;
  final String goalId;
  final bool isOwner;
  final bool canRemove;

  Contributor({
    @required this.contributor,
    @required this.goalId,
    this.isOwner = true,
    this.canRemove = false,
  });

  @override
  _ContributorState createState() => _ContributorState();
}

class _ContributorState extends State<Contributor> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    _buildContributionAmount() {
      var totalContributionString = convertDoubleToCurrencyString(
          widget.contributor.totalContribution.abs());

      if (widget.contributor.totalContribution == 0) {
        return Text(
          '\$$totalContributionString',
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).primaryColorDark,
          ),
        );
      }
      return (widget.contributor.totalContribution < 0)
          ? Text(
              '- \$$totalContributionString',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).errorColor,
              ),
            )
          : Text(
              '+ \$$totalContributionString',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).indicatorColor,
              ),
            );
    }

    _showRemoveUserActionSheet() {
      return showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                child: Text(
                  'Remove user from goal',
                ),
                onPressed: () {
                  DatabaseService().leaveGoal(
                      widget.goalId, widget.contributor.uid,
                      isOwnerRemove: true);
                  // Pop until home screen, since currentGoal does not update due to wonky architecture.
                  Navigator.popUntil(context, ModalRoute.withName(splashRoute));
                },
              ),
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

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isTapDown = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isTapDown = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isTapDown = false;
        });
      },
      onTap: () {
        if (widget.canRemove) {
          _showRemoveUserActionSheet();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        child: ClayContainer(
          emboss: !widget.canRemove || _isTapDown,
          color: Theme.of(context).backgroundColor,
          borderRadius: 10,
          spread: !widget.canRemove ? 1 : themeProvider.isDarkTheme ? 4 : 5,
          depth: themeProvider.isDarkTheme ? 8 : 10,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Avatar(
                      height: 30,
                      width: 30,
                      imageUrl: widget.contributor.photoUrl,
                    ),
                    widget.isOwner
                        ? Positioned(
                            bottom: 0,
                            right: 2,
                            child: Icon(
                              FontAwesomeIcons.crown,
                              color: Color(0xFFF8B632),
                              size: 10,
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.contributor.displayName,
                        style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                      if (widget.isOwner)
                        Text(
                          "(Owner)",
                          style: Theme.of(context).textTheme.overline.copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 12),
                        ),
                      if (widget.contributor.email.isNotEmpty)
                        Text(
                          widget.contributor.email,
                          style: Theme.of(context).textTheme.overline.copyWith(
                              color: Theme.of(context).primaryColorDark),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildContributionAmount(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
