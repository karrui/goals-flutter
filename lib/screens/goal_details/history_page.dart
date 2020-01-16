import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/history_model.dart';
import 'history.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var histories = Provider.of<List<HistoryModel>>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              "Transactions",
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: histories.length,
            itemBuilder: (ctx, index) {
              return History(history: histories[index]);
            },
          ),
        ),
      ],
    );
  }
}
