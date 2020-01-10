import 'package:flutter/services.dart';

String generateAuthErrorMessage(PlatformException error) {
  String errorMessage;
  switch (error.code) {
    case 'ERROR_INVALID_EMAIL':
    case 'ERROR_WRONG_PASSWORD':
      errorMessage = 'Invalid email or password.';
      break;
    case 'ERROR_EMAIL_ALREADY_IN_USE':
      errorMessage = 'Email is already in use.';
      break;
    case 'ERROR_USER_NOT_FOUND':
      errorMessage = 'User not found. Sign up first before logging in.';
      break;
    case 'ERROR_TOO_MANY_REQUESTS':
      errorMessage = 'Tried to log in too many times. Please try again later';
      break;
    default:
      errorMessage = 'Authentication failed. Please try again.';
  }
  return errorMessage;
}
