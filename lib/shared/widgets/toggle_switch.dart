import 'package:clay_containers/clay_containers.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';

class ToggleSwitch extends StatelessWidget {
  final bool isToggled;

  ToggleSwitch({this.isToggled = false});

  @override
  Widget build(BuildContext context) {
    var tween = MultiTrackTween([
      Track("paddingLeft")
          .add(Duration(milliseconds: 300), Tween(begin: 0.0, end: 30.0)),
      Track("paddingRight")
          .add(Duration(milliseconds: 300), Tween(begin: 30.0, end: 0.0)),
      Track("color").add(
          Duration(milliseconds: 300),
          ColorTween(
              begin: Color(0xFFF4FAFF), end: Theme.of(context).indicatorColor)),
    ]);

    Widget _buildToggle(context, animation) {
      return ClayContainer(
        width: 64,
        height: 32,
        emboss: true,
        color: animation['color'],
        borderRadius: 10,
        parentColor: Theme.of(context).backgroundColor,
        spread: 1,
        depth: 40,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          padding: EdgeInsets.only(
              left: animation["paddingLeft"], right: animation["paddingRight"]),
          child: ClayContainer(
            spread: 0.2,
            depth: 30,
            parentColor: animation['color'],
            color: Theme.of(context).backgroundColor,
            borderRadius: 8,
          ),
        ),
      );
    }

    return ControlledAnimation(
      playback: isToggled ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
      startPosition: isToggled ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildToggle,
    );
  }
}
