import 'package:flutter/material.dart';

import '../../models/history_model.dart';

class History extends StatelessWidget {
  final HistoryModel history;

  History({this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(history.createdByName),
          Text(history.amount.toString()),
          Text(history.description),
          Text(history.type == HistoryType.ADD ? "deposit" : "withdrawal"),
          Text(history.createdAt.toIso8601String())
        ],
      ),
    );
  }
}
