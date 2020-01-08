import 'package:flutter/material.dart';

class JarItem extends StatelessWidget {
  final String name;

  JarItem({this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Text(name),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
    );
  }
}
