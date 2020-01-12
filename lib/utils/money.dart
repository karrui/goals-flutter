import 'package:intl/intl.dart';

// TODO: Allow currency format to be set by user
final currencyFormatter = new NumberFormat("#,##0.00", "en_SG");

String convertDoubleToCurrencyString(double value) {
  return currencyFormatter.format(value);
}
