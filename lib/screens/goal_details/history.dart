import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/history_model.dart';
import '../../utils/number_util.dart';

class History extends StatelessWidget {
  final HistoryModel history;

  History({this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      history.createdByName,
                      style: Theme.of(context).textTheme.overline,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                      child: Text(
                        history.description,
                        style: Theme.of(context).textTheme.title.copyWith(
                            fontSize: 16.0, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().add_jm().format(history.createdAt),
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
                    color: history.type == HistoryType.ADD
                        ? Theme.of(context).indicatorColor
                        : Theme.of(context).errorColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _generateDisplayAmount() {
    String currencyString = convertDoubleToCurrencyString(history.amount);
    if (history.type == HistoryType.ADD) {
      return '+\$ $currencyString';
    }
    return '-\$ $currencyString';
  }
}
