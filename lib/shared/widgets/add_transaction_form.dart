import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../models/contribution_model.dart';
import '../../services/database.dart';
import '../../shared/decorations/card_box_decoration.dart';
import 'buttons/squircle_icon_button.dart';
import 'buttons/squircle_text_button.dart';
import 'buttons/static_squircle_button.dart';
import 'keyboard_bar.dart';

/// An almost duplicate copy for [AddTransactionSlidingUpPanel], but does not rely on panel opening and closing. Used by [HomeScreen]'s goal cards.
class AddTransactionForm extends StatefulWidget {
  final GoalModel goal;
  final Function onSubmitSuccess;

  AddTransactionForm({@required this.goal, @required this.onSubmitSuccess});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  final db = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  final _descriptionTextController = TextEditingController();
  final _amountTextController = MoneyMaskedTextController(
      initialValue: 0.0,
      decimalSeparator: '.',
      thousandSeparator: ',',
      leftSymbol: '\$ ');

  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  ContributionType _currentTransactionType = ContributionType.ADD;
  bool _hasErrorOccured = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  _submitForm(FirebaseUser user) async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _hasErrorOccured = true;
      });
      return null;
    }

    setState(() {
      _isLoading = true;
    });

    db.addTransactionToGoal(
        amount: _amountTextController.numberValue,
        description: _descriptionTextController.value.text,
        goalId: widget.goal.id,
        type: _currentTransactionType,
        user: user);

    widget.onSubmitSuccess();
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SquircleIconButton(
                      width: 80,
                      isActive: _currentTransactionType == ContributionType.ADD,
                      iconData: FontAwesomeIcons.plus,
                      iconColor: Theme.of(context).indicatorColor,
                      onPressed: () {
                        setState(() {
                          _currentTransactionType = ContributionType.ADD;
                        });
                      }),
                  SizedBox(
                    width: 10,
                  ),
                  SquircleIconButton(
                    width: 80,
                    isActive:
                        _currentTransactionType == ContributionType.WITHDRAW,
                    iconData: FontAwesomeIcons.minus,
                    iconColor: Theme.of(context).errorColor,
                    onPressed: () {
                      setState(() {
                        _currentTransactionType = ContributionType.WITHDRAW;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Goal card
            Stack(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: cardBoxDecoration(context),
                  constraints: BoxConstraints(maxHeight: 300),
                  margin: EdgeInsets.all(20.0),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 84.0,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                autofocus: true,
                                enabled: !_isLoading,
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ],
                                focusNode: _amountFocusNode,
                                controller: _amountTextController,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.title,
                                cursorColor: Theme.of(context).cursorColor,
                                validator: (_) {
                                  var numVal =
                                      _amountTextController.numberValue;
                                  if (numVal == 0.0) {
                                    return 'Please enter an amount.';
                                  }
                                  return (numVal > 10000)
                                      ? 'Amount should not exceed \$10,000.'
                                      : null;
                                },
                                onChanged: (_) {
                                  if (_hasErrorOccured) {
                                    _formKey.currentState.validate();
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          enabled: !_isLoading,
                          focusNode: _descriptionFocusNode,
                          autocorrect: true,
                          textInputAction: TextInputAction.continueAction,
                          controller: _descriptionTextController,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle
                              .copyWith(fontSize: 16.0),
                          cursorColor:
                              Theme.of(context).textTheme.subtitle.color,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: "Enter notes (optional)",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 35,
                  right: 40,
                  child: Text(
                    _currentTransactionType == null
                        ? ''
                        : _currentTransactionType == ContributionType.ADD
                            ? 'Deposit'
                            : 'Withdrawal',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: (_currentTransactionType == ContributionType.ADD)
                            ? Theme.of(context).indicatorColor
                            : Theme.of(context).errorColor),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isLoading
                  ? StaticSquircleButton(
                      child: loadingWidget,
                      isActive: false,
                    )
                  : SquircleTextButton(
                      text: "Add contribution",
                      onPressed: _isLoading ? null : () => _submitForm(user),
                    ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // Fake keyboard bar to move back and forth and press next
            KeyboardBar(
              focusNodes: [
                _amountFocusNode,
                _descriptionFocusNode,
              ],
              isActive: MediaQuery.of(context).viewInsets.bottom != 0,
            ),
          ],
        ),
      ),
    );
  }
}
