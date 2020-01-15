import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../models/goal_model.dart';
import '../../models/history_model.dart';
import '../../services/database.dart';
import '../../shared/neumorphism/card_box_decoration.dart';
import '../../widgets/buttons/squircle_text_button.dart';
import '../../widgets/buttons/static_squircle_button.dart';
import '../../widgets/keyboard_bar.dart';

class AddTransactionModal extends StatefulWidget {
  final GoalModel goal;

  AddTransactionModal({@required this.goal});

  @override
  _AddTransactionModalState createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final db = DatabaseService();

  final _formKey = GlobalKey<FormState>();
  final _descriptionTextController = TextEditingController();
  final _amountTextController = MoneyMaskedTextController(
      decimalSeparator: '.', thousandSeparator: ',', leftSymbol: '\$ ');

  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

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

    await db.addTransactionToGoal(
        amount: _amountTextController.numberValue,
        description: _descriptionTextController.value.text,
        goalId: widget.goal.id,
        type: HistoryType.ADD,
        user: user);

    setState(() {
      _isLoading = true;
    });

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
                  'Add \$ to ${widget.goal.name}',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            // Goal card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: cardBoxDecoration(context),
              constraints: BoxConstraints(maxHeight: 300),
              // padding: const EdgeInsets.fromLTRB(35, 15, 35, 5),
              margin: EdgeInsets.all(20.0),
              width: double.infinity,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 84.0,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              enabled: !_isLoading,
                              autofocus: true,
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
                                var numVal = _amountTextController.numberValue;
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
                        autocorrect: false,
                        textInputAction: TextInputAction.continueAction,
                        controller: _descriptionTextController,
                        maxLines: null,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(fontSize: 16.0),
                        cursorColor: Theme.of(context).textTheme.subtitle.color,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          hintText: "Enter notes (optional)",
                        ),
                      ),
                    ],
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
                      text: "Add transaction",
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
              isActive: !_isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
