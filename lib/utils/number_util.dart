import 'package:intl/intl.dart';

// TODO: Allow currency format to be set by user
final currencyFormatter = new NumberFormat("#,##0.00", "en_SG");
final percentFormatter = new NumberFormat.percentPattern("en_SG");

String convertDoubleToCurrencyString(double value) {
  return currencyFormatter.format(value);
}

String convertDoubleToPercentString(double value) {
  return percentFormatter.format(value);
}
