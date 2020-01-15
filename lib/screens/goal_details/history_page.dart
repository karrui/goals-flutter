import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/history_model.dart';
import '../../shared/neumorphism/card_box_decoration.dart';
import 'history.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var histories = Provider.of<List<HistoryModel>>(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
        decoration: cardBoxDecoration(context),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: histories != null ? histories.length : 0,
          itemBuilder: (ctx, index) {
            return History(history: histories[index]);
          },
          separatorBuilder: (ctx, index) {
            return Divider(
              color: Theme.of(context).primaryColorDark.withOpacity(0.2),
              thickness: 1,
              height: 0,
            );
          },
        ),
      ),
    );
  }
}
