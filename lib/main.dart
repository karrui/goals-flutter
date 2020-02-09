import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_user_stream/firebase_user_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/goal_model.dart';
import 'providers/current_goal.dart';
import 'providers/loading_state.dart';
import 'providers/theme.dart';
import 'router.dart';
import 'screens/splash_screen.dart';
import 'services/database.dart';
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
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => themeProvider,
        ),
        StreamProvider<FirebaseUser>(
            create: (_) => FirebaseUserReloader.onAuthStateChangedOrReloaded),
        Consumer<FirebaseUser>(
          builder: (context, user, child) {
            return StreamProvider<List<GoalModel>>(
              initialData: [],
              create: (_) => DatabaseService().streamGoals(user),
              child: child,
            );
          },
        ),
        ChangeNotifierProvider<CurrentGoal>(
          create: (_) => CurrentGoal(),
        ),
        ChangeNotifierProvider<LoadingState>(
          create: (_) => LoadingState(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, _, child) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarBrightness:
              themeProvider.isDarkTheme ? Brightness.dark : Brightness.light,
        ));
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
