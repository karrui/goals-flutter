import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/goal_model.dart';
import '../models/contribution_model.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Stream<GoalModel> streamCurrentGoal(String goalId) {
    return _db
        .collection('goals')
        .document(goalId)
        .snapshots()
        .map((doc) => GoalModel.fromFirestore(doc));
  }

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

  /// Returns a stream of a all contributions of the goal with its [goalId]
  Stream<List<ContributionModel>> streamContributions(String goalId) {
    return _db
        .collection('goals')
        .document(goalId)
        .collection('contributions')
        .snapshots()
        .map((list) => list.documents
            .map((doc) => ContributionModel.fromFirestore(doc))
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
      final newGoalContribRef =
          newGoalRef.collection('contributions').document();
      batch.setData(newGoalContribRef, {
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

  Future<void> addTransactionToGoal({
    @required String goalId,
    @required double amount,
    @required ContributionType type,
    @required FirebaseUser user,
    String description,
  }) {
    final batch = _db.batch();
    final goalRef = _db.collection('goals').document(goalId);

    batch.updateData(goalRef, {
      "currentAmount":
          FieldValue.increment(type == ContributionType.ADD ? amount : -amount),
      "lastUpdated": DateTime.now(),
    });

    final newGoalContribRef = goalRef.collection('contributions').document();
    batch.setData(newGoalContribRef, {
      'amount': amount,
      'createdAt': DateTime.now(),
      'description': description,
      'createdByName': user.displayName != null ? user.displayName : user.email,
      'uid': user.uid,
      'type': type == ContributionType.ADD ? 'add' : 'withdraw',
    });

    return batch.commit();
  }

  Future<void> deleteGoal(String goalId) {
    _db
        .collection('goals')
        .document(goalId)
        .collection('contributions')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    return _db.collection('goals').document(goalId).delete();
  }
}
