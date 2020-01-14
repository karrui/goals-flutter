import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'router.dart';
import 'screens/splash_screen.dart';

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
            child: MultiProvider(
              providers: [
                StreamProvider<FirebaseUser>(
                  create: (_) => FirebaseAuth.instance.onAuthStateChanged,
                ),
              ],
              child: MaterialApp(
                title: 'Goals',
                theme: theme,
                home: SplashScreen(),
                onGenerateRoute: Router.generateRoute,
              ),
            ),
          );
        });
  }
}
