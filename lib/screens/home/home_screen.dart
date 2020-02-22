import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../services/database.dart';
import '../../shared/route_constants.dart';
import '../../shared/widgets/app_nav_bar.dart';
import '../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../shared/widgets/buttons/squircle_text_button.dart';
import 'widgets/goals_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final DatabaseService _db = DatabaseService();

  StreamSubscription<String> _tokenListener;

  @override
  void initState() {
    super.initState();
    initFcmListeners();
  }

  @override
  void dispose() {
    if (_tokenListener != null) {
      _tokenListener.cancel();
    }
    super.dispose();
  }

  initFcmListeners() {
    if (Platform.isIOS) {
      _getIosPermissions();
    }

    _tokenListener = _fcm.onTokenRefresh.listen((newToken) {
      _saveDeviceToken(newToken);
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken(String fcmToken) async {
    // Get the current user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) return;

    print("saving fcmToken $fcmToken and uid ${user.uid}");

    // Save it to Firestore
    if (fcmToken != null) {
      await _db.saveDeviceToken(userId: user.uid, token: fcmToken);
    }
  }

  void _getIosPermissions() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    _showGoalList() {
      return Expanded(
        child: Scrollbar(
          child: GoalsList(),
        ),
      );
    }

    _showAddGoalButton() {
      return Column(
        children: [
          SizedBox(
            height: 12.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
            child: SquircleTextButton(
              text: "Add new goal",
              onPressed: () => Navigator.pushNamed(context, NEW_GOAL_ROUTE),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppNavBar(
              title: "Current goals",
              canGoBack: false,
              rightButton: SquircleIconButton(
                iconData: Icons.settings,
                onPressed: () => Navigator.pushNamed(context, SETTINGS_ROUTE),
                iconSize: 24.0,
                height: 50.0,
                width: 50.0,
              ),
            ),
            _showGoalList(),
            _showAddGoalButton(),
          ],
        ),
      ),
    );
  }
}
