import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contributor_model.dart';
import 'widgets/contributor.dart';

class ContributorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var contributors = Provider.of<List<ContributorModel>>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 36.0),
            child: Text(
              "Contributors",
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: contributors.length,
            itemBuilder: (ctx, index) {
              return Contributor(contributor: contributors[index]);
            },
          ),
        ),
      ],
    );
  }
}
