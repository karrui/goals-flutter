import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/current_goal.dart';
import '../../../providers/theme.dart';
import '../../../services/database.dart';
import '../../../shared/widgets/buttons/squircle_icon_button.dart';
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
    var themeProvider = Provider.of<ThemeProvider>(context);
    var user = Provider.of<FirebaseUser>(context);

    return Consumer<CurrentGoal>(builder: (context, currentGoal, _) {
      _handleOnPressed() async {
        if (_emailFormKey.currentState.validate()) {
          setState(() {
            _isLoading = true;
          });
          try {
            var newUserUid = await DatabaseService().shareGoal(
              sharedBy: user,
              goal: currentGoal.goal,
              email: emailInputController.value.text,
            );
            var currentContributors = currentGoal.goal.usersWithAccess;
            // Add new user's uid into current goal to update the contributor list.
            currentGoal.usersWithAccess = [...currentContributors, newUserUid];
            Navigator.pop(context);
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
      }

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
                style: Theme.of(context).textTheme.subtitle2,
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
              themeProvider.isDarkTheme
                  ? SquircleIconButton(
                      width: double.infinity,
                      enabled: !_isLoading,
                      text: "Send invite",
                      onPressed: _handleOnPressed,
                    )
                  : SquircleTextButton(
                      text: "Send invite",
                      enabled: !_isLoading,
                      onPressed: _handleOnPressed,
                    ),
            ],
          ),
        ),
      );
    });
  }
}
