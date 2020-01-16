import 'package:flutter/material.dart';

import '../../../models/contributor_model.dart';
import '../../../shared/decorations/squircle_icon_button_box_decoration.dart';
import '../../../utils/number_util.dart';

class Contributor extends StatelessWidget {
  final ContributorModel contributor;

  Contributor({this.contributor});

  @override
  Widget build(BuildContext context) {
    _buildContributionAmount() {
      var totalContributionString =
          convertDoubleToCurrencyString(contributor.totalContribution.abs());
      return (contributor.totalContribution < 0)
          ? Text(
              '- \$$totalContributionString',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).errorColor,
              ),
            )
          : Text(
              '+ \$$totalContributionString',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme.of(context).indicatorColor,
              ),
            );
    }

    return Container(
      decoration: squircleIconButtonBoxDecorationDepressed(context).copyWith(
          color: Theme.of(context)
              .primaryColorDark
              .withOpacity(0.15)
              .withBlue(210)),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              contributor.displayName,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: _buildContributionAmount(),
          ),
        ],
      ),
    );
  }
}
