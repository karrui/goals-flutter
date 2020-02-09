import 'package:flutter/widgets.dart';

/// Class that blocks backswipe navigation.
class NavBlocker extends StatelessWidget {
  final Widget child;

  NavBlocker({@required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Bugged, does not fire anyways. Only here to prevent backswipe
      onWillPop: () async => true,
      child: child,
    );
  }
}
