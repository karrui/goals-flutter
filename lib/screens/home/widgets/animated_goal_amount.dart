import 'package:flutter/material.dart';
import 'package:goals_flutter/utils/number_util.dart';

/// Retrieved and modified from https://gist.github.com/Nolence/b7d43cd9ad25d614f52aba2c74a597fd
class AnimatedGoalAmount extends ImplicitlyAnimatedWidget {
  final double currentAmount;
  final double totalAmount;
  final TextStyle primaryTextStyle;
  final TextStyle secondaryTextStyle;

  AnimatedGoalAmount({
    Key key,
    @required this.currentAmount,
    @required this.totalAmount,
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

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedGoalAmount> {
  Tween<double> _currentAmount;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.end,
      text: TextSpan(
        style: TextStyle(
          color: Colors.black,
        ),
        children: <TextSpan>[
          // TODO: Allow user selectable locale currency
          TextSpan(
            text: '\$',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          TextSpan(
            text: convertDoubleToCurrencyString(
                _currentAmount.evaluate(animation)),
            style: widget.primaryTextStyle,
          ),
          TextSpan(
            text: ' / \$${convertDoubleToCurrencyString(widget.totalAmount)}',
          ),
        ],
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _currentAmount = visitor(
      _currentAmount,
      widget.currentAmount,
      (dynamic value) => Tween<double>(begin: value),
    );
  }
}
