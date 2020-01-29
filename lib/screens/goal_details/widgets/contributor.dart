import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../models/contributor_model.dart';
import '../../../shared/widgets/avatar.dart';
import '../../../utils/number_util.dart';

class Contributor extends StatelessWidget {
  final ContributorModel contributor;
  final bool isOwner;

  Contributor({
    @required this.contributor,
    this.isOwner = true,
  });

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
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: ClayContainer(
        emboss: true,
        color: Theme.of(context).backgroundColor,
        borderRadius: 10,
        spread: 1,
        depth: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Avatar(
                    height: 30,
                    width: 30,
                    imageUrl: contributor.photoUrl,
                  ),
                  isOwner
                      ? Positioned(
                          bottom: 0,
                          right: 2,
                          child: Icon(
                            FontAwesomeIcons.crown,
                            color: Color(0xFFF8B632),
                            size: 10,
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contributor.displayName,
                      style: Theme.of(context).textTheme.title.copyWith(
                          fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                    if (isOwner)
                      Text(
                        "(Owner)",
                        style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 12),
                      ),
                    if (contributor.email.isNotEmpty)
                      Text(
                        contributor.email,
                        style: Theme.of(context).textTheme.overline.copyWith(
                            color: Theme.of(context).primaryColorDark),
                      ),
                  ],
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
