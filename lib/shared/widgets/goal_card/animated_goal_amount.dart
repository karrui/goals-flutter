import 'package:flutter/material.dart';
import '../../../utils/number_util.dart';

/// Retrieved and modified from https://gist.github.com/Nolence/b7d43cd9ad25d614f52aba2c74a597fd
class AnimatedGoalAmount extends ImplicitlyAnimatedWidget {
  final double currentAmount;
  final double goalAmount;
  final TextStyle primaryTextStyle;
  final TextStyle secondaryTextStyle;

  AnimatedGoalAmount({
    Key key,
    @required this.currentAmount,
    @required this.goalAmount,
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
      textAlign: TextAlign.start,
      text: TextSpan(
        style: Theme.of(context).textTheme.headline6,
        children: <TextSpan>[
          TextSpan(
            text: '\$ ',
          ),
          TextSpan(
            text: NumberUtil.convertDoubleToCurrencyString(
                _currentAmount.evaluate(animation)),
          ),
          if (widget.goalAmount != 0)
            TextSpan(
              text:
                  ' / \$${NumberUtil.convertDoubleToCurrencyString(widget.goalAmount)}',
              style: Theme.of(context).textTheme.subtitle2,
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
