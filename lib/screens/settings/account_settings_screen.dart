import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/loading_state.dart';
import '../../shared/widgets/app_nav_bar.dart';
import '../../shared/widgets/nav_blocker.dart';
import 'widgets/account_settings_form.dart';

class AccountSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var _loadingState = Provider.of<LoadingState>(context);

    return NavBlocker(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppNavBar(
                title: 'Edit Account',
                disabled: _loadingState.isLoading,
                canGoBack: true,
              ),
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
