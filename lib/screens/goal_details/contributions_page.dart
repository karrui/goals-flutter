import 'package:flutter/material.dart';
import 'package:goals_flutter/shared/widgets/buttons/squircle_icon_button.dart';
import 'package:provider/provider.dart';

import '../../models/contribution_model.dart';
import './widgets/contribution.dart';

class ContributionsPage extends StatefulWidget {
  @override
  _ContributionsPageState createState() => _ContributionsPageState();
}

class _ContributionsPageState extends State<ContributionsPage> {
  bool _isDeleteMode;
  Set<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _isDeleteMode = false;
    _selectedItems = Set();
  }

  @override
  Widget build(BuildContext context) {
    var contributions = Provider.of<List<ContributionModel>>(context);

    _buildActionButtons() {
      if (_isDeleteMode) {
        return [
          SquircleIconButton(
            height: 25,
            width: 35,
            borderRadius: 10,
            enabled: _selectedItems.isNotEmpty,
            iconData: Icons.delete,
            iconColor: Theme.of(context).errorColor,
            onPressed: () {},
          ),
          SizedBox(
            width: 10.0,
          ),
          SquircleIconButton(
            height: 25,
            width: 35,
            borderRadius: 10,
            iconData: Icons.undo,
            onPressed: () {
              setState(() {
                _isDeleteMode = false;
                _selectedItems = Set();
              });
            },
          ),
        ];
      }
      return [
        SquircleIconButton(
          height: 25,
          width: 35,
          borderRadius: 10,
          iconData: Icons.edit,
          onPressed: () {
            setState(() {
              _isDeleteMode = true;
            });
          },
        ),
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.only(
                left: 36.0, right: 20.0, top: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _isDeleteMode
                      ? "${_selectedItems.length} selected"
                      : "Contributions",
                  style: Theme.of(context).textTheme.subhead,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Row(
                  children: <Widget>[
                    ..._buildActionButtons(),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: contributions.length,
            itemBuilder: (ctx, index) {
              return Contribution(
                contribution: contributions[index],
                showCheckBox: _isDeleteMode,
                onCheckItem: (id) {
                  setState(() {
                    if (!_isDeleteMode) {
                      _isDeleteMode = true;
                    }
                    if (_selectedItems.contains(id)) {
                      _selectedItems.remove(id);
                    } else {
                      _selectedItems.add(id);
                    }
                  });
                },
                isSelected: _selectedItems.contains(contributions[index].id),
              );
            },
          ),
        ),
      ],
    );
  }
}
