import 'package:flutter/material.dart';

class Jar {
  final String id;
  final String name;
  final Set owners;

  const Jar({
    @required this.id,
    @required this.name,
    @required this.owners,
  });
}
