import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/contribution_model.dart';
import '../models/goal_model.dart';
import '../models/user_model.dart';
import '../utils/notification_util.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  // FCMToken handlers
  /// Save [user]'s current fcm [token] to the database
  Future<void> saveDeviceToken(
      {@required String userId, @required String token}) async {
    if (token == null) return;

    // Save token to Firestore
    return _db
        .collection('users')
        .document(userId)
        .collection('tokens')
        .document(token)
        .setData({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    });
  }
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

  Stream<Map<String, UserModel>> streamUidsToPhotoUrlsMap(List<String> uids) {
    return _db
        .collection('users')
        .where('uid', whereIn: uids)
        .snapshots()
        .map((list) => list.documents.fold(
              <String, UserModel>{},
              (Map<String, UserModel> acc, currentUserData) {
                acc[currentUserData.data['uid']] =
                    UserModel.fromFirestore(currentUserData);
                return acc;
              },
            ));
  }

  Future<void> updateUser(String userId, UserUpdateInfo userUpdateInfo) {
    final userRef = _db.collection('users').document(userId);
    var updateInfo = <String, String>{};
    if (userUpdateInfo.displayName != null) {
      updateInfo['displayName'] = userUpdateInfo.displayName;
    }
    if (userUpdateInfo.photoUrl != null) {
      updateInfo['photoUrl'] = userUpdateInfo.photoUrl;
    }
    return userRef.updateData(updateInfo);
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
        'uid': user.uid,
        'type': 'add',
      });
    }

    return batch.commit();
  }

  Future<void> editGoal({
    @required String goalId,
    @required String newGoalName,
    @required double newGoalAmount,
  }) {
    final goalRef = _db.collection('goals').document(goalId);

    return goalRef.updateData({
      "name": newGoalName,
      "goalAmount": newGoalAmount,
    });
  }

  Future<String> shareGoal({
    @required String email,
    @required String goalId,
  }) async {
    var userSnapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
    if (userSnapshot.documents.isEmpty) {
      NotificationUtil.showFailureToast("User with email not found.");
      return Future.error("User not found");
    }
    var user = UserModel.fromFirestore(userSnapshot.documents[0]);

    final goalRef = _db.collection('goals').document(goalId);

    await goalRef.updateData({
      'usersWithAccess': FieldValue.arrayUnion([user.uid])
    });
    NotificationUtil.showSuccessToast("User added to goal!");
    return user.uid;
  }

  Future<void> addContributionToGoal({
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

  Future<void> leaveGoal(String goalId, String userId,
      {bool isOwnerRemove = false}) async {
    await _db.collection('goals').document(goalId).updateData({
      "usersWithAccess": FieldValue.arrayRemove([userId])
    });

    if (isOwnerRemove) {
      NotificationUtil.showSuccessToast("User removed from goal");
    } else {
      NotificationUtil.showSuccessToast("Goal left");
    }

    return;
  }

  Future<void> deleteContributions(
      String goalId, Map<String, ContributionModel> contributions) {
    final batch = _db.batch();
    final goalRef = _db.collection('goals').document(goalId);
    final CollectionReference contributionRef =
        goalRef.collection('contributions');

    var amountDelta = 0.0;

    for (var entry in contributions.entries) {
      batch.delete(contributionRef.document(entry.key));

      // Reverse the amount since contribution is being deleted.
      amountDelta += entry.value.type == ContributionType.ADD
          ? -entry.value.amount
          : entry.value.amount;
    }

    batch.updateData(goalRef, {
      "currentAmount": FieldValue.increment(amountDelta),
      "lastUpdated": DateTime.now(),
    });

    return batch.commit();
  }
}
