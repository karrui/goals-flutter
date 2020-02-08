import 'package:flutter/material.dart';

import '../../../shared/widgets/buttons/squircle_text_button.dart';

class GoalTypeModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                "Choose goal type",
                style: Theme.of(context).textTheme.subtitle,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            SquircleTextButton(
              text: "Goal with target amount",
              onPressed: () {},
            ),
            SizedBox(
              height: 15,
            ),
            SquircleTextButton(
              text: "Open goal",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
