import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/history_model.dart';
import 'history.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var histories = Provider.of<List<HistoryModel>>(context);

    return ListView.builder(
      itemCount: histories != null ? histories.length : 0,
      itemBuilder: (ctx, index) {
        return History(history: histories[index]);
      },
    );
  }
}
