import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:clay_containers/widgets/clay_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme.dart';

class SquircleIconButton extends StatefulWidget {
  final double height;
  final double width;
  final double iconSize;
  final String text;
  final Color iconColor;
  final double borderRadius;
  final IconData iconData;
  final Function onPressed;
  final bool enabled;
  final bool isActive;
  final MainAxisAlignment alignment;

  SquircleIconButton({
    this.height = 40.0,
    this.width = 40.0,
    this.iconSize = 15.0,
    this.text = "",
    this.iconColor,
    this.borderRadius = 15.0,
    this.enabled = true,
    this.isActive = false,
    this.alignment = MainAxisAlignment.center,
    this.iconData,
    @required this.onPressed,
  });

  @override
  _SquircleIconButtonState createState() => _SquircleIconButtonState();
}

class _SquircleIconButtonState extends State<SquircleIconButton> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    Color _getIconColor() {
      if (!widget.enabled) {
        return Theme.of(context).disabledColor;
      }

      if (_isTapDown) {
        return Theme.of(context).buttonColor;
      }

      if (widget.iconColor != null) {
        return widget.iconColor;
      }
      return Theme.of(context).textTheme.button.color;
    }

    bool _isEmbossed() {
      if (!widget.enabled) {
        return false;
      }

      return _isTapDown || widget.isActive;
    }

    return GestureDetector(
      child: ClayContainer(
        height: widget.height,
        width: widget.width,
        borderRadius: widget.borderRadius,
        depth: widget.enabled ? 12 : 0,
        spread: themeProvider.isDarkTheme ? 4 : 5,
        color: Theme.of(context).primaryColor,
        emboss: _isEmbossed(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: widget.alignment,
            children: <Widget>[
              widget.iconData != null
                  ? Icon(
                      widget.iconData,
                      size: widget.iconSize,
                      color: _getIconColor(),
                    )
                  : Container(),
              if (widget.text.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                      left: widget.iconData != null ? 8.0 : 0.0),
                  child: ClayText(
                    widget.text,
                    color: Theme.of(context).primaryColorDark,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontWeight: FontWeight.w600),
                    parentColor: Theme.of(context).primaryColor,
                    emboss: true,
                    spread: 1,
                    depth: 6,
                  ),
                )
            ],
          ),
        ),
      ),
      onTap: () {
        if (widget.enabled) {
          widget.onPressed();
          setState(() {
            _isTapDown = false;
          });
        }
      },
      onTapDown: (_) {
        if (widget.enabled) {
          setState(() {
            _isTapDown = true;
          });
        }
      },
      onTapCancel: () {
        if (widget.enabled) {
          setState(() {
            _isTapDown = false;
          });
        }
      },
    );
  }
}
