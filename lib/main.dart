import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/theme.dart';
import 'router.dart';
import 'screens/splash_screen.dart';
import 'shared/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _getCurrentAppTheme();
  }

  _getCurrentAppTheme() async {
    themeProvider.isDarkTheme = await themeProvider.themePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => themeProvider,
        ),
        StreamProvider<FirebaseUser>(
          create: (_) => FirebaseAuth.instance.onAuthStateChanged,
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, _, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData(themeProvider.isDarkTheme, context),
          title: 'Goals',
          home: SplashScreen(),
          onGenerateRoute: Router.generateRoute,
        );
      }),
    );
  }
}
