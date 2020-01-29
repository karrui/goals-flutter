import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';

class NMCheckbox extends StatelessWidget {
  final bool isChecked;
  NMCheckbox({this.isChecked = false});

  _buildCheckmark(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      child: Center(
        child: isChecked
            ? Icon(
                Icons.check,
                color: Theme.of(context).primaryColorLight,
                size: 15,
              )
            : Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClayContainer(
          color:
              isChecked ? Color(0xFF686DE0) : Theme.of(context).backgroundColor,
          curveType: isChecked ? CurveType.concave : CurveType.none,
          emboss: true,
          height: 20,
          width: 20,
          borderRadius: 10,
          spread: 0,
          depth: 25,
        ),
        _buildCheckmark(context),
      ],
    );
  }
}
