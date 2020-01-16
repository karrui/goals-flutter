import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import 'contributors_page.dart';
import 'contributions_page.dart';

class ContributionPageViews extends StatefulWidget {
  @override
  _ContributionPageViewsState createState() => _ContributionPageViewsState();
}

class _ContributionPageViewsState extends State<ContributionPageViews> {
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
                ContributionsPage(),
                ContributorsPage(),
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
