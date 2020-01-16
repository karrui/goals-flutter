import 'package:flutter/material.dart';

import '../../../models/contributor_model.dart';

class Contributor extends StatelessWidget {
  final ContributorModel contributor;

  Contributor({@required this.contributor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(contributor.totalContribution.toString()),
    );
  }
}
