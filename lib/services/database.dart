import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:goals_flutter/models/goal_model.dart';
import 'package:goals_flutter/models/history_model.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  /// Returns a stream of a all [GoalModel]s that [user] can access.
  Stream<List<GoalModel>> streamGoals(FirebaseUser user) {
    return _db
        .collection('goals')
        .where('usersWithAccess', arrayContainsAny: [user.uid])
        .snapshots()
        .map((list) =>
            list.documents.map((doc) => GoalModel.fromFirestore(doc)).toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  /// Returns a stream of a all histories of the goal with its [goalId]
  Stream<List<HistoryModel>> streamHistories(String goalId) {
    return _db
        .collection('goals')
        .document(goalId)
        .collection('history')
        .snapshots()
        .map((list) => list.documents
            .map((doc) => HistoryModel.fromFirestore(doc))
            .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  Future<void> createGoal({
    @required String name,
    @required FirebaseUser user,
    @required double startingAmount,
    @required double goalAmount,
  }) {
    final batch = _db.batch();
    final newGoalRef = _db.collection('goals').document();
    batch.setData(newGoalRef, {
      'name': name,
      'currentAmount': startingAmount,
      'goalAmount': goalAmount,
      'owner': user.uid,
      'usersWithAccess': [user.uid],
      'createdAt': DateTime.now(),
      'lastUpdated': DateTime.now(),
    });
    if (startingAmount > 0) {
      final newGoalHistoryRef = newGoalRef.collection('history').document();
      batch.setData(newGoalHistoryRef, {
        'amount': startingAmount,
        'createdAt': DateTime.now(),
        'description': 'Starting amount',
        'createdByName':
            user.displayName != null ? user.displayName : user.email,
        'uid': user.uid,
        'type': 'add',
      });
    }

    return batch.commit();
  }

  Future<void> deleteGoal(String goalId) {
    return _db.collection('goals').document(goalId).delete();
  }
}
