import 'package:flutter/material.dart';

class JarModel {
  final String id;
  final String name;
  final String owner;
  final List<String> sharedTo;
  final double goalAmount;
  final double currentAmount;
  final DateTime lastUpdated;

  const JarModel({
    @required this.id,
    @required this.name,
    @required this.owner,
    @required this.sharedTo,
    @required this.goalAmount,
    @required this.currentAmount,
    @required this.lastUpdated,
  });
}
