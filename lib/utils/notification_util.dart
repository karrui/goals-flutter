import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> showSuccessToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 3,
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );
}

Future<bool> showFailureToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 3,
    backgroundColor: Colors.redAccent,
    textColor: Colors.white,
  );
}
