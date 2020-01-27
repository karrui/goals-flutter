import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../services/database.dart';
import '../../shared/widgets/buttons/squircle_text_button.dart';
import '../../shared/widgets/buttons/static_squircle_button.dart';

class AddGoalForm extends StatefulWidget {
  @override
  _AddGoalFormState createState() => _AddGoalFormState();
}

class _AddGoalFormState extends State<AddGoalForm> {
  final db = DatabaseService();

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
  bool _isLoading = false;

  @override
  void dispose() {
    _goalNameFocusNode.dispose();
    _startingAmountFocusNode.dispose();
    _goalAmountFocusNode.dispose();
    super.dispose();
  }

  _submitForm(FirebaseUser user) async {
    if (!_formKey.currentState.validate()) {
      return null;
    }

    setState(() {
      _isLoading = true;
    });

    db.createGoal(
      name: _goalNameTextController.value.text,
      startingAmount: _startingAmountTextController.numberValue,
      goalAmount: _goalAmountTextController.numberValue,
      user: user,
    );
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    Widget loadingWidget = SpinKitThreeBounce(
      color: Theme.of(context).primaryColor,
      size: 20.0,
    );

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
                  'New goal',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            // Goal card
            Container(
              padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 20.0),
              constraints: BoxConstraints(maxHeight: 300),
              width: double.infinity,
              child: ClayContainer(
                color: Theme.of(context).primaryColor,
                borderRadius: 25,
                depth: 10,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 80.0,
                          child: TextFormField(
                            enabled: !_isLoading,
                            focusNode: _goalNameFocusNode,
                            autocorrect: true,
                            textInputAction: TextInputAction.next,
                            controller: _goalNameTextController,
                            maxLines: null,
                            autofocus: true,
                            style: Theme.of(context).textTheme.body2,
                            cursorColor: Theme.of(context).cursorColor,
                            onChanged: (_) {
                              if (_hasErrorOccured) {
                                _formKey.currentState.validate();
                              }
                            },
                            validator: (val) => val.isEmpty ? "Required" : null,
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "GOAL NAME",
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
                                      enabled: !_isLoading,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("/"),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 90.0,
                                child: TextFormField(
                                  enabled: !_isLoading,
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isLoading
                  ? StaticSquircleButton(
                      child: loadingWidget,
                      isActive: false,
                    )
                  : SquircleTextButton(
                      text: "Add goal",
                      onPressed: _isLoading ? null : () => _submitForm(user),
                    ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
