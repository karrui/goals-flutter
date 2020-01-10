import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'router.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/jars_screen.dart';

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
            primarySwatch: Colors.blue,
          ),
          home: FutureBuilder<FirebaseUser>(
            future: authData.user,
            builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return JarsScreen();
              } else
                return AuthScreen();
            },
          ),
          onGenerateRoute: Router.generateRoute,
        ),
      ),
    );
  }
}
