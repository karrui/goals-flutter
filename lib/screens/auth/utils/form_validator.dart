String emailValidator(String value) {
  if (value.isEmpty) {
    return 'Email cannot be empty';
  }
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Invalid email format';
  } else {
    return null;
  }
}

String passwordValidator(String value) {
  if (value.isEmpty) {
    return 'Password cannot be empty';
  }

  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }

  return null;
}
