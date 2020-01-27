import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';

import '../../../models/contributor_model.dart';
import '../../../utils/number_util.dart';

class Contributor extends StatelessWidget {
  final ContributorModel contributor;

  Contributor({this.contributor});

  @override
  Widget build(BuildContext context) {
    _buildContributionAmount() {
      var totalContributionString =
          convertDoubleToCurrencyString(contributor.totalContribution.abs());

      if (contributor.totalContribution == 0) {
        return Text(
          '\$$totalContributionString',
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).primaryColorDark,
          ),
        );
      }
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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: ClayContainer(
        emboss: true,
        color: Theme.of(context).primaryColor,
        borderRadius: 10,
        spread: 1,
        depth: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
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
        ),
      ),
    );
  }
}
