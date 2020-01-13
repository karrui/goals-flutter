import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/goal_model.dart';

class Database {
  static Firestore db = Firestore.instance;
  final String uid;

  Database({@required this.uid});

  final CollectionReference usersCollection = db.collection('users');
  final CollectionReference goalsCollection = db.collection('goals');

  void createJar({String name, double startingAmount, double goalAmount}) {
    final batch = db.batch();
    final newGoalRef = goalsCollection.document();
    batch.setData(newGoalRef, {
      'name': name,
      'currentAmount': startingAmount,
      'goalAmount': goalAmount,
      'owner': uid,
    });
    if (startingAmount > 0) {
      final newGoalHistoryRef = newGoalRef.collection('history').document();
      batch.setData(newGoalHistoryRef, {
        'amount': startingAmount,
        'createdAt': DateTime.now(),
        'description': 'Starting amount',
        'uid': uid,
        'type': 'add',
      });
    }

    batch.updateData(
        usersCollection.document(uid), {"jars.${newGoalRef.documentID}": true});
    batch.commit();
  }

  List<GoalModel> _goalListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data);
      return GoalModel(
        name: doc.data['name'],
        currentAmount: doc.data['currentAmount'] + .0,
        goalAmount: doc.data['goalAmount'] + .0,
        owner: doc.data['owner'],
        id: doc.documentID,
        lastUpdated: doc.data['lastUpdated'].toDate(),
      );
    }).toList();
  }

  Stream<List<GoalModel>> get jars {
    return goalsCollection
        .where("owner", isEqualTo: uid)
        .snapshots()
        .map(_goalListFromSnapshot);
  }
}
