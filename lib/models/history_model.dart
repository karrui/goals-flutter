import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final double amount;
  final String description;
  final DateTime createdAt;
  final HistoryType type;
  final String createdByName;
  final String uid;

  HistoryModel({
    this.id,
    this.amount,
    this.description,
    this.createdAt,
    this.type,
    this.createdByName,
    this.uid,
  });

  factory HistoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return HistoryModel._fromMap(data, doc.documentID);
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

  HistoryModel._fromMap(Map snapshot, String id)
      : id = id ?? '',
        amount = snapshot['amount'] + .0 ?? 0.0,
        description = snapshot['description'] ?? '',
        createdAt = snapshot['createdAt'].toDate() ?? DateTime.now(),
        type = snapshot['type'] == 'add'
            ? HistoryType.ADD
            : HistoryType.WITHDRAW ?? HistoryType.ADD,
        createdByName = snapshot['createdByName'] ?? '',
        uid = snapshot['uid'] ?? '';
}

enum HistoryType {
  ADD,
  WITHDRAW,
}
