import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../models/goal_model.dart';
import '../../../providers/theme.dart';
import '../../../services/database.dart';
import '../../../shared/widgets/buttons/squircle_icon_button.dart';
import '../../../shared/widgets/buttons/squircle_text_button.dart';
import '../../../shared/widgets/buttons/static_squircle_button.dart';
import '../../../utils/number_util.dart';

class EditGoalForm extends StatefulWidget {
  final GoalModel goal;

  EditGoalForm({this.goal});

  @override
  _EditGoalFormState createState() => _EditGoalFormState();
}

class _EditGoalFormState extends State<EditGoalForm> {
  final db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  MoneyMaskedTextController _goalAmountTextController;

  TextEditingController _goalNameTextController;

  @override
  void initState() {
    _goalNameTextController = TextEditingController(text: widget.goal.name);
    _goalAmountTextController = MoneyMaskedTextController(
        decimalSeparator: '.',
        thousandSeparator: ',',
        leftSymbol: '\$ ',
        initialValue: widget.goal.goalAmount);
    super.initState();
  }

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

    db.editGoal(
        goalId: widget.goal.id,
        newGoalAmount: _goalAmountTextController.numberValue,
        newGoalName: _goalNameTextController.value.text.trim());

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);

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
                    const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
                child: Text(
                  'Edit goal details',
                  style: Theme.of(context).textTheme.subtitle,
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
                              hintText: "SUPER COOL NAME",
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
                                      initialValue:
                                          convertDoubleToCurrencyString(
                                              widget.goal.currentAmount),
                                      enabled: false,
                                      textAlign: TextAlign.start,
                                      decoration: InputDecoration(
                                        labelText: "Current amount",
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
                                  validator: (_) =>
                                      _goalAmountTextController.numberValue <= 0
                                          ? "Invalid goal amount"
                                          : null,
                                  onChanged: (_) {
                                    if (_hasErrorOccured) {
                                      _formKey.currentState.validate();
                                    }
                                  },
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                      labelText: "Goal amount",
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
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: themeProvider.isDarkTheme
                          ? SquircleIconButton(
                              width: double.infinity,
                              text: "Edit goal",
                              onPressed:
                                  _isLoading ? null : () => _submitForm(user),
                            )
                          : SquircleTextButton(
                              text: "Edit goal",
                              onPressed:
                                  _isLoading ? null : () => _submitForm(user)),
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
