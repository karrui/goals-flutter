import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/contributor_model.dart';
import '../../providers/current_goal.dart';
import '../../shared/constants.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../utils/modal_bottom_sheet.dart';
import 'widgets/add_contributor_form.dart';
import 'widgets/contributor.dart';

class ContributorsPage extends StatelessWidget {
  final List<ContributorModel> contributors;

  ContributorsPage({this.contributors});

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
    var goal = Provider.of<CurrentGoal>(context).goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.only(
                left: 36.0, right: 20.0, top: 8.0, bottom: 8.0),
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
            var user = Provider.of<FirebaseUser>(context);
            var contributor = contributors[index];
            var ownerContributor = goal.owner == contributor.uid;
            var contributorWidget = Contributor(
              contributor: contributor,
              isOwner: ownerContributor,
              canRemove: goal.owner == user.uid &&
                  !ownerContributor &&
                  contributor.uid != userLeftContributorKey,
              goalId: goal.id,
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
