import 'package:xpens/shared/utils/formatCost.dart';

double ceilTo(double value, double base) {
  return (value / base).ceil() * base;
}

String formatCostToShortFormat(double number, {bool roundToNice = true}) {
  // Optional upward rounding
  if (roundToNice) {
    if (number < 1000) {
      number = ceilTo(number, 10);
    } else if (number < 100000) {
      number = ceilTo(number, 5000); // Round up to nearest 5K
    } else if (number < 10000000) {
      number = ceilTo(number, 50000); // Round up to nearest 50K
    } else {
      number = ceilTo(number, 500000); // Round up to nearest 5L
    }
  }

  // Format into K, L, Cr
  return formatToShortCode(number);
}

double roundToNice(number) {
  if (number < 1000) {
    number = ceilTo(number, 10);
  } else if (number < 100000) {
    number = ceilTo(number, 5000); // Round up to nearest 5K
  } else if (number < 10000000) {
    number = ceilTo(number, 50000); // Round up to nearest 50K
  } else {
    number = ceilTo(number, 500000); // Round up to nearest 5L
  }
  return number;
}

String formatToShortCode(double number) {
  if (number >= 10000000) {
    return "${(formatDouble(number / 10000000))} Cr";
  } else if (number >= 100000) {
    return "${formatDouble(number / 100000)} L";
  } else if (number >= 1000) {
    return "${formatDouble(number / 1000)} K";
  } else {
    return number.toStringAsFixed(0);
  }
}
