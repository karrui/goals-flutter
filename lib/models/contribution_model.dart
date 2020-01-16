import 'package:cloud_firestore/cloud_firestore.dart';

class ContributionModel {
  final String id;
  final double amount;
  final String description;
  final DateTime createdAt;
  final ContributionType type;
  final String createdByName;
  final String uid;

  ContributionModel({
    this.id,
    this.amount,
    this.description,
    this.createdAt,
    this.type,
    this.createdByName,
    this.uid,
  });

  factory ContributionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return ContributionModel._fromMap(data, doc.documentID);
  }

  toJson() {
    return {
      "amount": amount,
      "description": description,
      "createdAt": createdAt,
      "type": type,
      "createdByName": createdByName,
      "uid": uid,
    };
  }

  ContributionModel._fromMap(Map snapshot, String id)
      : id = id ?? '',
        amount = snapshot['amount'] + .0 ?? 0.0,
        description = snapshot['description'] ?? '',
        createdAt = snapshot['createdAt'].toDate() ?? DateTime.now(),
        type = snapshot['type'] == 'add'
            ? ContributionType.ADD
            : ContributionType.WITHDRAW ?? ContributionType.ADD,
        createdByName = snapshot['createdByName'] ?? '',
        uid = snapshot['uid'] ?? '';
}

enum ContributionType {
  ADD,
  WITHDRAW,
}
