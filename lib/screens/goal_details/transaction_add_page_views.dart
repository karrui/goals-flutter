import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../../widgets/buttons/squircle_icon_button.dart';
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

  Function _handleBottomActionClicked;
  int _currentPageIndex;
  String _currentPageTitle;

  @override
  void initState() {
    _readCurrentPageIndex();
    _currentPageNotifier.addListener(_handlePageChange);
    super.initState();
  }

  @override
  void dispose() {
    _currentPageNotifier.removeListener(_handlePageChange);
    super.dispose();
  }

  _handlePageChange() {
    setState(_readCurrentPageIndex);
  }

  _readCurrentPageIndex() {
    _currentPageIndex = _currentPageNotifier.value;
    if (_currentPageNotifier.value == 0) {
      _handleBottomActionClicked = _switchToAddTransactionPage;
      _currentPageTitle = "Transactions";
    } else {
      _handleBottomActionClicked = _switchToViewHistoryPage;
      _currentPageTitle = "Add transaction";
    }
  }

  _switchToAddTransactionPage() {
    _controller.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    print("switching to add transaction page");
  }

  _switchToViewHistoryPage() {
    print("switching to view history page");
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 36.0),
              child: Text(
                _currentPageTitle,
                style: Theme.of(context).textTheme.subhead,
                textAlign: TextAlign.start,
              ),
            ),
          ),
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
          _buildBottomActionButton(),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton() {
    return AnimatedContainer(
      width: _currentPageIndex == 0 ? 40.0 : 200.0,
      duration: Duration(milliseconds: 150),
      child: SquircleIconButton(
        width: double.infinity,
        iconData: FontAwesomeIcons.plus,
        onPressed: _handleBottomActionClicked,
      ),
    );
  }
}
