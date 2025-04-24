String formatDouble(double value) {
  // Convert to string with 2 decimal places
  String str = value.toStringAsFixed(2);

  // Remove trailing zeros and possibly the decimal point
  str = str.replaceFirst(RegExp(r'\.?0*$'), '');

  return str;
}
