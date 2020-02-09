import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/loading_state.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/nav_blocker.dart';
import 'widgets/account_settings_form.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var _loadingState = Provider.of<LoadingState>(context);

    _showAppBar() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SquircleIconButton(
              enabled: !_loadingState.isLoading,
              iconData: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
              iconSize: 24.0,
              height: 50.0,
              width: 50.0,
            ),
            Text(
              "Edit Account",
              style: Theme.of(context).textTheme.subtitle,
            ),
            SizedBox(
              height: 50.0,
              width: 50.0,
            ),
          ],
        ),
      );
    }

    return NavBlocker(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: AccountSettingsForm(user: user),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
