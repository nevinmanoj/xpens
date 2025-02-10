enum Period {
  daily,
  weekly,
  monthly,
  quarter,
  halfYear,
  year,
}

String serializePeriod(Period s) => s.name;

Period deserializePeriod(String s) =>
    Period.values.firstWhere((e) => e.name == s);
