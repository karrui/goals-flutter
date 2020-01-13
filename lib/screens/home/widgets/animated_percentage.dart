import 'package:flutter/material.dart';
import 'package:goals_flutter/utils/number_util.dart';

/// Retrieved and modified from https://gist.github.com/Nolence/b7d43cd9ad25d614f52aba2c74a597fd
class AnimatedPercentage extends ImplicitlyAnimatedWidget {
  final double percentage;
  final TextStyle primaryTextStyle;
  final TextStyle secondaryTextStyle;

  AnimatedPercentage({
    Key key,
    @required this.percentage,
    this.primaryTextStyle = const TextStyle(),
    this.secondaryTextStyle = const TextStyle(),
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedCountState();
  }
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedPercentage> {
  Tween<double> _percentage;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        style: widget.secondaryTextStyle,
        children: <TextSpan>[
          TextSpan(text: "You are "),
          TextSpan(
            text: convertDoubleToPercentString(_percentage.evaluate(animation)),
            style: widget.primaryTextStyle,
          ),
          TextSpan(text: " of the way there!")
        ],
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _percentage = visitor(
      _percentage,
      widget.percentage,
      (dynamic value) => Tween<double>(begin: value),
    );
  }
}
