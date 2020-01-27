import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/contribution_model.dart';
import '../../../utils/number_util.dart';

class Contribution extends StatelessWidget {
  final ContributionModel contribution;

  Contribution({this.contribution});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: ClayContainer(
        color: Theme.of(context).primaryColor,
        borderRadius: 10,
        spread: 5,
        depth: 10,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          contribution.createdByName,
                          style: Theme.of(context).textTheme.overline,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Text(
                            contribution.description,
                            style: Theme.of(context).textTheme.title.copyWith(
                                fontSize: 16.0, fontWeight: FontWeight.normal),
                          ),
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
