import 'package:intl/intl.dart';

class NumberUtil {
  // TODO: Allow currency format to be set by user
  static String convertDoubleToCurrencyString(double value) {
    final _currencyFormatter = NumberFormat("#,##0.00", "en_SG");
    return _currencyFormatter.format(value);
  }

  static String convertDoubleToPercentString(double value) {
    final _percentFormatter = NumberFormat.percentPattern("en_SG");
    return _percentFormatter.format(value);
  }
}
