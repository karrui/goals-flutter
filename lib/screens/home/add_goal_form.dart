import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../../widgets/keyboard_bar.dart';
import '../../widgets/rounded_button.dart';

class AddGoalForm extends StatefulWidget {
  @override
  _AddGoalFormState createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _goalNameTextController = TextEditingController();
  final _startingAmountTextController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', leftSymbol: '\$ ');
  final _goalAmountTextController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', leftSymbol: '\$ ');

  final FocusNode _goalNameFocusNode = FocusNode();
  final FocusNode _startingAmountFocusNode = FocusNode();
  final FocusNode _goalAmountFocusNode = FocusNode();

  bool _hasErrorOccured = false;

  @override
  void dispose() {
    _goalNameFocusNode.dispose();
    _startingAmountFocusNode.dispose();
    _goalAmountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Text(
                  "New goal",
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            // Goal card
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              padding: EdgeInsets.fromLTRB(35, 15, 35, 5),
              margin: EdgeInsets.all(20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(1.0, 3.0),
                    blurRadius: 4.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 80.0,
                        child: TextFormField(
                          focusNode: _goalNameFocusNode,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          controller: _goalNameTextController,
                          maxLines: null,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 16.0,
                            letterSpacing: 1.5,
                          ),
                          onChanged: (_) {
                            if (_hasErrorOccured) {
                              _formKey.currentState.validate();
                            }
                          },
                          validator: (val) => val.isEmpty ? "Required" : null,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: "GOAL NAME",
                          ),
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_startingAmountFocusNode),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 90.0,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    focusNode: _startingAmountFocusNode,
                                    controller: _startingAmountTextController,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    textAlign: TextAlign.start,
                                    onChanged: (_) {
                                      if (_hasErrorOccured) {
                                        _formKey.currentState.validate();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: "INITIAL AMOUNT",
                                      labelStyle: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("/"),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 90.0,
                              child: TextFormField(
                                focusNode: _goalAmountFocusNode,
                                controller: _goalAmountTextController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                validator: (_) => _goalAmountTextController
                                            .numberValue <=
                                        _startingAmountTextController
                                            .numberValue
                                    ? "Goal must be higher than initial amount"
                                    : null,
                                onChanged: (_) {
                                  if (_hasErrorOccured) {
                                    _formKey.currentState.validate();
                                  }
                                },
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "GOAL AMOUNT",
                                    labelStyle: TextStyle(fontSize: 14),
                                    errorMaxLines: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundedButton(
                text: "Add goal",
                backgroundColor: Colors.grey[900],
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    setState(() {
                      _hasErrorOccured = true;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // Fake keyboard bar to move back and forth and press next
            KeyboardBar(focusNodes: [
              _goalNameFocusNode,
              _startingAmountFocusNode,
              _goalAmountFocusNode
            ]),
          ],
        ),
      ),
    );
  }
}
