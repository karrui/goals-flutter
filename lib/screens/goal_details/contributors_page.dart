import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contributor_model.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../utils/modal_bottom_sheet.dart';
import 'widgets/add_contributor_form.dart';
import 'widgets/contributor.dart';

class ContributorsPage extends StatelessWidget {
  _buildAddContributor(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          SquircleIconButton(
            alignment: MainAxisAlignment.start,
            width: double.infinity,
            iconSize: 25,
            iconData: Icons.add,
            text: "Add contributor",
            onPressed: () {
              print("Add contributor button clicked");
              showModalBottomSheetWithChild(context, AddContributorForm());
            },
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

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
            var contributorWidget = Contributor(
              contributor: contributors[index],
            );

            if (index != contributors.length - 1) {
              return contributorWidget;
            } else {
              return Column(
                children: <Widget>[
                  contributorWidget,
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildAddContributor(context)
                ],
              );
            }
          },
        )),
      ],
    );
  }
}
