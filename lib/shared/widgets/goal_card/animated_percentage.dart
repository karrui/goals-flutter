import 'package:flutter/material.dart';
import '../../../utils/number_util.dart';

/// Retrieved and modified from https://gist.github.com/Nolence/b7d43cd9ad25d614f52aba2c74a597fd
class AnimatedPercentage extends ImplicitlyAnimatedWidget {
  final double percentage;

  AnimatedPercentage({
    Key key,
    @required this.percentage,
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
      textAlign: TextAlign.start,
      text: TextSpan(
        style: Theme.of(context).textTheme.overline,
        children: <TextSpan>[
          TextSpan(text: "You have reached "),
          TextSpan(
            text: NumberUtil.convertDoubleToPercentString(
                _percentage.evaluate(animation)),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: " of your goal.")
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
