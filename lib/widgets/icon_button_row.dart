import 'package:flutter/material.dart';

class IconButtonRow extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;

  IconButtonRow({this.iconData, this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconData != null
              ? Icon(
                  iconData,
                  size: 20.0,
                  color: color,
                )
              : SizedBox(
                  width: 20.0,
                ),
          Text(
            this.text,
            style: TextStyle(color: color),
          ),
          // Spacer to make button text centered with logo
          SizedBox(
            width: 20.0,
          ),
        ],
      ),
    );
  }
}
