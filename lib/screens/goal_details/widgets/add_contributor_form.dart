import 'package:flutter/material.dart';

import '../../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../auth/utils/form_validator.dart';

class AddContributorForm extends StatefulWidget {
  @override
  _AddContributorFormState createState() => _AddContributorFormState();
}

class _AddContributorFormState extends State<AddContributorForm> {
  final _emailFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;

  @override
  void initState() {
    emailInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _emailFormKey,
      child: Container(
        padding: EdgeInsets.only(
            left: 25,
            top: 25,
            right: 25,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Invite someone to this goal!",
              style: Theme.of(context).textTheme.subtitle,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 100.0,
              child: TextFormField(
                autofocus: true,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email address",
                  hintText: "hello@example.com",
                ),
                controller: emailInputController,
                validator: emailValidator,
              ),
            ),
            SquircleIconButton(
              text: "Send Invite",
              onPressed: () {
                if (_emailFormKey.currentState.validate()) {
                  print("success");
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
