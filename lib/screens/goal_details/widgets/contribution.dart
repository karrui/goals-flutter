import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/contribution_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/theme.dart';
import '../../../shared/constants.dart';
import '../../../shared/widgets/avatar/networked_avatar.dart';
import '../../../shared/widgets/checkbox/checkbox.dart';
import '../../../utils/number_util.dart';

class Contribution extends StatefulWidget {
  final ContributionModel contribution;
  final UserModel createdByUser;
  final Function onCheckItem;
  final Function onLongPress;
  final bool showCheckBox;
  final bool isSelected;

  Contribution({
    @required this.contribution,
    @required this.createdByUser,
    @required this.onCheckItem,
    @required this.onLongPress,
    this.showCheckBox = false,
    this.isSelected = false,
  });

  @override
  _ContributionState createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {
  bool _isEmbossed = false;

  _buildCheckbox() {
    return Container(
      width: 40,
      height: 40,
      child: Center(
        child: NMCheckbox(
          isChecked: widget.isSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: widget.showCheckBox
          ? () => widget.onCheckItem(widget.contribution)
          : null,
      onTapDown: (_) {
        setState(() {
          _isEmbossed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isEmbossed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isEmbossed = false;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _isEmbossed = false;
        });
      },
      onLongPress: () {
        setState(() {
          _isEmbossed = false;
        });
        widget.onLongPress(widget.contribution);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: ClayContainer(
          emboss: _isEmbossed,
          color: Theme.of(context).backgroundColor,
          borderRadius: 10,
          spread: themeProvider.isDarkTheme ? 4 : 5,
          depth: themeProvider.isDarkTheme ? 8 : 10,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.showCheckBox
                        ? _buildCheckbox()
                        : NetworkedAvatar(
                            height: 40,
                            width: 40,
                            imageUrl: widget.createdByUser?.photoUrl ??
                                defaultAvatarUrl,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            widget.createdByUser?.displayName ??
                                '[Unknown user]',
                            style: Theme.of(context).textTheme.overline,
                          ),
                          widget.contribution.description.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 4.0),
                                  child: Text(
                                    widget.contribution.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .title
                                        .copyWith(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.normal),
                                  ),
                                )
                              : SizedBox(
                                  height: 10.0,
                                ),
                          Text(
                            DateFormat.yMMMd()
                                .add_jm()
                                .format(widget.contribution.createdAt),
                            style: TextStyle(
                                fontSize: 11.0,
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.5)),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _generateDisplayAmount(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color:
                              widget.contribution.type == ContributionType.ADD
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).errorColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _generateDisplayAmount() {
    String currencyString =
        NumberUtil.convertDoubleToCurrencyString(widget.contribution.amount);
    if (widget.contribution.type == ContributionType.ADD) {
      return '+\$ $currencyString';
    }
    return '-\$ $currencyString';
  }
}
