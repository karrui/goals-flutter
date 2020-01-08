import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../jar_item.dart';

class JarsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: ListView(
        children: DUMMY_JARS
            .map((jar) => JarItem(
                  name: jar.name,
                ))
            .toList(),
      ),
    );
  }
}
