import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'router.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Goals',
          theme: ThemeData(
            primaryColor: Color(0xFF6981EC),
            // Middle gradient color when needed
            // #65C7F7
            accentColor: Color(0xFF9CECFB),
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          home: FutureBuilder<FirebaseUser>(
            future: authData.user,
            builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return HomeScreen();
                  }
                  return AuthScreen();
                default:
                  // Loading, return empty container
                  return Scaffold(
                    body: Center(
                      child: Container(),
                    ),
                  );
              }
            },
          ),
          onGenerateRoute: Router.generateRoute,
        ),
      ),
    );
  }
}
