import 'package:flutter/material.dart';

import '../models/goal_model.dart';

class CurrentGoal extends ChangeNotifier {
  GoalModel _currentGoal;

  GoalModel get goal => _currentGoal;

  set goal(GoalModel newGoal) {
    _currentGoal = newGoal;
    notifyListeners();
  }
}
