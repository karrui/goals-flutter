import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import 'add_transaction_page.dart';
import 'history_page.dart';

class TransactionAddPageViews extends StatefulWidget {
  @override
  _TransactionAddPageViewsState createState() =>
      _TransactionAddPageViewsState();
}

class _TransactionAddPageViewsState extends State<TransactionAddPageViews> {
  final PageController _controller = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _controller,
              children: <Widget>[
                HistoryPage(),
                AddTransactionPage(),
              ],
              onPageChanged: (index) {
                _currentPageNotifier.value = index;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: CirclePageIndicator(
              itemCount: 2,
              currentPageNotifier: _currentPageNotifier,
            ),
          ),
          SizedBox(
            height: 65.0,
          ),
        ],
      ),
    );
  }
}
