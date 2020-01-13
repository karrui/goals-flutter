import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/goal_model.dart';
import 'providers/auth.dart';
import 'providers/database.dart';
import 'router.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/home/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.grey,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: theme.brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
            child: ChangeNotifierProvider(
              create: (_) => Auth(),
              child: Consumer<Auth>(
                builder: (ctx, authData, _) => MaterialApp(
                  title: 'Goals',
                  theme: theme,
                  home: FutureBuilder<FirebaseUser>(
                    future: authData.user,
                    builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            return MultiProvider(
                              providers: [
                                StreamProvider<List<GoalModel>>(
                                    create: (_) =>
                                        Database(uid: snapshot.data.uid).jars),
                                Provider<Database>(
                                  create: (_) =>
                                      Database(uid: snapshot.data.uid),
                                )
                              ],
                              child: HomeScreen(),
                            );
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
            ),
          );
        });
  }
}
