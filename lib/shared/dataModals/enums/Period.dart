enum Period { quarter, halfYear, year, daily, weekly, monthly }

String serializePeriod(Period s) => s.name;

Period deserializePeriod(String s) =>
    Period.values.firstWhere((e) => e.name == s);
