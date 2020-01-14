import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String id;
  final String name;
  final String owner;
  final List<String> usersWithAccess;
  final double currentAmount;
  final double goalAmount;
  final DateTime createdAt;
  final DateTime lastUpdated;

  GoalModel({
    this.id,
    this.name,
    this.owner,
    this.usersWithAccess,
    this.currentAmount,
    this.goalAmount,
    this.createdAt,
    this.lastUpdated,
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return GoalModel(
        id: doc.documentID,
        name: data['name'] ?? '',
        owner: data['owner'] ?? '',
        usersWithAccess: data['usersWithAccess'].cast<String>() ?? [],
        currentAmount: data['currentAmount'] + .0 ?? 0,
        goalAmount: data['goalAmount'] + .0 ?? 0,
        createdAt: data['createdAt'].toDate() ?? DateTime.now(),
        lastUpdated: data['lastUpdated'].toDate() ?? DateTime.now());
  }

  toJson() {
    return {
      "name": name,
      "owner": owner,
      "usersWithAccess": usersWithAccess,
      "currentAmount": currentAmount,
      "goalAmount": goalAmount,
      "createdAt": createdAt,
      "lastUpdated": lastUpdated,
    };
  }
}
