import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

import '../../providers/current_goal.dart';
import '../../utils/modal_bottom_sheet.dart';
import '../../widgets/buttons/squircle_icon_button.dart';
import '../../widgets/modals/add_transaction_modal.dart';
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
          CirclePageIndicator(
            itemCount: 2,
            currentPageNotifier: _currentPageNotifier,
          ),
          SizedBox(
            height: 16.0,
          ),
          SquircleIconButton(
            iconData: FontAwesomeIcons.plus,
            onPressed: () => showModalBottomSheetWithChild(
                context,
                AddTransactionModal(
                    goal:
                        Provider.of<CurrentGoal>(context, listen: false).goal)),
          ),
        ],
      ),
    );
  }
}
