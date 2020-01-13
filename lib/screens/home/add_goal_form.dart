import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:goals_flutter/widgets/text_button.dart';

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
            Text("New goal"),
            // Goal card
            Container(
              constraints: BoxConstraints(maxHeight: 300),
              padding: EdgeInsets.fromLTRB(35, 25, 35, 25),
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
                      TextFormField(
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
                        validator: (val) => val.isEmpty ? "Required" : null,
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(hintText: "GOAL NAME"),
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_startingAmountFocusNode),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              focusNode: _startingAmountFocusNode,
                              controller: _startingAmountTextController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("/"),
                          ),
                          Expanded(
                            child: TextFormField(
                              focusNode: _goalAmountFocusNode,
                              controller: _goalAmountTextController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val.isEmpty ? "Required" : null,
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(hintText: "999"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                          text: "Add",
                          onPressed: () {
                            _formKey.currentState.validate();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Form(
    //   key: _formKey,
    //   child: Container(
    //     // height: 300,
    //     child: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //           Text(
    //             'Create new goal',
    //             style: TextStyle(
    //               fontSize: 30.0,
    //               fontWeight: FontWeight.bold,
    //             ),
    //             textAlign: TextAlign.start,
    //           ),
    //           SizedBox(
    //             height: 20.0,
    //           ),
    //           TextFormField(
    //             autofocus: true,
    //             decoration: InputDecoration(hintText: "Goal name"),
    //             validator: (val) => val.isEmpty ? 'Please enter a name' : null,
    //             onChanged: (val) => setState(() => _goalName = val),
    //           ),
    //           TextFormField(
    //             decoration: InputDecoration(hintText: "Starting amount"),
    //             validator: (val) => val.isEmpty ? 'Please enter a name' : null,
    //             onChanged: (val) => setState(() => _goalName = val),
    //           ),
    //           Row(
    //             children: <Widget>[
    //               TextButton(
    //                 text: "Create",
    //                 onPressed: () {},
    //               )
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
