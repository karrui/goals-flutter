import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/theme.dart';

class SettingsListTile extends StatefulWidget {
  final String title;
  final Widget trailing;
  final Function onPressed;

  SettingsListTile({
    @required this.title,
    this.onPressed,
    this.trailing,
  });

  @override
  _SettingsListTileState createState() => _SettingsListTileState();
}

class _SettingsListTileState extends State<SettingsListTile> {
  bool _isTapDown = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      child: ClayContainer(
        emboss: _isTapDown,
        borderRadius: 15,
        color: Theme.of(context).backgroundColor,
        depth: 12,
        spread: themeProvider.isDarkTheme ? 4 : 5,
        child: ListTile(
          title: Text(widget.title),
          trailing: widget.trailing ?? null,
        ),
      ),
      onTap: () {
        if (widget.onPressed != null) {
          setState(() {
            _isTapDown = false;
          });
          widget.onPressed();
        }
      },
      onTapDown: (_) {
        if (widget.onPressed != null) {
          setState(() {
            _isTapDown = true;
          });
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null) {
          setState(() {
            _isTapDown = false;
          });
        }
      },
    );
  }
}
