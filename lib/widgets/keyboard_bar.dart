import 'package:flutter/material.dart';

import 'inkless_icon_button.dart';
import 'text_button.dart';

/// Loosely follows keyboard_actions package https://github.com/diegoveloper/flutter_keyboard_actions/blob/master/lib/keyboard_actions.dart for my own custom implementation
class KeyboardBar extends StatefulWidget {
  final List<FocusNode> focusNodes;
  KeyboardBar({this.focusNodes});

  @override
  _KeyboardBarState createState() => _KeyboardBarState();
}

class _KeyboardBarState extends State<KeyboardBar> with WidgetsBindingObserver {
  /// The currently focus nodes
  List<FocusNode> focusNodes;
  Map<int, FocusNode> _nodes = Map();
  FocusNode _currentNode;
  int _currentNodeIndex = 0;

  @override
  void didUpdateWidget(KeyboardBar oldWidget) {
    setFocusNodes(widget.focusNodes);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    setFocusNodes(widget.focusNodes);
    super.initState();
  }

  void setFocusNodes(List<FocusNode> newFocusNodes) {
    disposeConfig();
    focusNodes = newFocusNodes;
    for (int i = 0; i < focusNodes.length; i++) {
      _addNodeToMap(i, focusNodes[i]);
    }
    _startListeningFocus();
  }

  void _startListeningFocus() {
    _nodes.values.forEach((node) => node.addListener(_focusNodeListener));
  }

  void _stopListeningFocus() {
    _nodes.values.forEach((node) => node.removeListener(_focusNodeListener));
  }

  Future<Null> _focusNodeListener() async {
    _nodes.keys.forEach((key) {
      final currentNode = _nodes[key];
      if (currentNode.hasFocus) {
        setState(() {
          _currentNode = currentNode;
          _currentNodeIndex = key;
        });
        return;
      }
    });
  }

  /// Clear any existing configuration. Unsubscribe from focus listeners.
  void disposeConfig() {
    _stopListeningFocus();
    _clearAllFocusNode();
    focusNodes = null;
  }

  void _addNodeToMap(int index, FocusNode node) {
    _nodes[index] = node;
  }

  void _clearAllFocusNode() {
    _nodes = Map();
  }

  int get _previousNodeIndex {
    final nextNodeIndex = _currentNodeIndex - 1;
    return nextNodeIndex >= 0 ? nextNodeIndex : null;
  }

  int get _nextNodeIndex {
    final nextIndex = _currentNodeIndex + 1;
    return nextIndex < _nodes.length ? nextIndex : null;
  }

  _focusNextNode(FocusNode node, int nextIndex) async {
    _currentNode = node;
    _currentNodeIndex = nextIndex;
    // remove focus for unselected fields
    _nodes.keys.forEach((key) {
      final currentNode = _nodes[key];
      if (currentNode != null && currentNode != _currentNode) {
        currentNode.unfocus();
      }
    });
    FocusScope.of(context).requestFocus(_currentNode);
  }

  _onTapUp() {
    if (_previousNodeIndex != null) {
      final currentNode = _nodes[_previousNodeIndex];
      _focusNextNode(currentNode, _previousNodeIndex);
    }
  }

  _onTapDown() {
    if (_nextNodeIndex != null) {
      final currentNode = _nodes[_nextNodeIndex];
      _focusNextNode(currentNode, _nextNodeIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          InklessIconButton(
            size: 30,
            icon: Icons.expand_less,
            onPressed: _previousNodeIndex != null ? _onTapUp : null,
          ),
          InklessIconButton(
            size: 30,
            icon: Icons.expand_more,
            onPressed: _nextNodeIndex != null ? _onTapDown : null,
          ),
          Spacer(),
          TextButton(
            text: "Next",
            onPressed: _nextNodeIndex != null ? _onTapDown : null,
          )
        ],
      ),
    );
  }
}
