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
          child: Container(
            padding: const EdgeInsets.only(
                left: 36.0, right: 20.0, top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Contributors",
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: contributors.length,
          itemBuilder: (ctx, index) {
            var contributor = contributors[index];
            return Contributor(
              contributor: contributor,
            );
          },
        )),
      ],
    );
  }
}
