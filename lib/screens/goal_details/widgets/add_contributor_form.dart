import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/current_goal.dart';
import '../../../services/database.dart';
import '../../../shared/route_constants.dart';
import '../../../shared/widgets/buttons/squircle_text_button.dart';
import '../../auth/utils/form_validator.dart';

class AddContributorForm extends StatefulWidget {
  @override
  _AddContributorFormState createState() => _AddContributorFormState();
}

class _AddContributorFormState extends State<AddContributorForm> {
  final _emailFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController emailInputController;

  @override
  void initState() {
    emailInputController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentGoal>(
      builder: (context, currentGoal, _) => Form(
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
                  autocorrect: false,
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
              SquircleTextButton(
                enabled: !_isLoading,
                text: "Send Invite",
                onPressed: () async {
                  if (_emailFormKey.currentState.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await DatabaseService().shareGoal(
                        goalId: currentGoal.goal.id,
                        email: emailInputController.value.text,
                      );
                      // Pop until home screen, since currentGoal does not update due to wonky architecture.
                      Navigator.popUntil(
                          context, ModalRoute.withName(splashRoute));
                      setState(() {
                        _isLoading = false;
                      });
                    } catch (error) {
                      Navigator.pop(context);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
