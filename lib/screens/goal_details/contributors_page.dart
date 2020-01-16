import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contributor_model.dart';
import 'widgets/contributor.dart';

class ContributorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var contributions = Provider.of<List<ContributorModel>>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              "Contributions",
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: contributions.length,
            itemBuilder: (ctx, index) {
              return Contributor(contributor: contributions[index]);
            },
          ),
        ),
      ],
    );
  }
}
