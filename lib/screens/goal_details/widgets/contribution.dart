import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/contribution_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../shared/widgets/checkbox/checkbox.dart';
import '../../../utils/number_util.dart';

class Contribution extends StatelessWidget {
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

  _buildCheckbox() {
    return Container(
      width: 40,
      height: 40,
      child: Center(
        child: NMCheckbox(
          isChecked: isSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showCheckBox ? () => onCheckItem(contribution) : null,
      onLongPress: () => onLongPress(contribution),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: ClayContainer(
          color: Theme.of(context).primaryColor,
          borderRadius: 10,
          spread: 5,
          depth: 10,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    showCheckBox
                        ? _buildCheckbox()
                        : Avatar(
                            height: 40,
                            width: 40,
                            imageUrl: createdByUser.photoUrl,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            createdByUser.displayName,
                            style: Theme.of(context).textTheme.overline,
                          ),
                          contribution.description.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4.0, bottom: 4.0),
                                  child: Text(
                                    contribution.description,
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
                                .format(contribution.createdAt),
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
                          color: contribution.type == ContributionType.ADD
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
    String currencyString = convertDoubleToCurrencyString(contribution.amount);
    if (contribution.type == ContributionType.ADD) {
      return '+\$ $currencyString';
    }
    return '-\$ $currencyString';
  }
}
