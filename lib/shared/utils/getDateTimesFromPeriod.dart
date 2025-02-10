import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/subModals/PeriodDates.dart';

DateRange getDateTimesFromPeriod({
  required Period p,
  required DateTime date,
  required bool isNextPeriod,
}) {
  switch (p) {
    case Period.daily:
      DateTime targetDate =
          isNextPeriod ? date.add(const Duration(days: 1)) : date;
      return DateRange(
          endDate: setTimePart(targetDate, false),
          startDate: setTimePart(targetDate, true));

    case Period.quarter:
      int quarter = ((date.month - 1) ~/ 3) + 1;
      if (isNextPeriod) quarter += 1;

      int yearOffset = (quarter > 4) ? 1 : 0;
      quarter = (quarter > 4) ? 1 : quarter;

      DateTime startDate =
          DateTime(date.year + yearOffset, (quarter - 1) * 3 + 1, 1);
      DateTime endDate = DateTime(date.year + yearOffset, quarter * 3 + 1, 1)
          .subtract(const Duration(days: 1));
      return DateRange(
          endDate: setTimePart(endDate, false),
          startDate: setTimePart(startDate, true));

    case Period.halfYear:
      int half = (date.month <= 6) ? 1 : 2;
      if (isNextPeriod) {
        half += 1;
        if (half > 2) {
          half = 1;
          date = DateTime(date.year + 1);
        }
      }

      DateTime startDate = DateTime(date.year, (half == 1) ? 1 : 7, 1);
      DateTime endDate = (half == 1)
          ? DateTime(date.year, 7, 1).subtract(const Duration(days: 1))
          : DateTime(date.year + 1, 1, 1).subtract(const Duration(days: 1));
      return DateRange(
          endDate: setTimePart(endDate, false), startDate: (startDate));

    case Period.year:
      int year = isNextPeriod ? date.year + 1 : date.year;
      DateTime startDate = DateTime(year, 1, 1);
      DateTime endDate =
          DateTime(year + 1, 1, 1).subtract(const Duration(days: 1));
      return DateRange(
          endDate: setTimePart(endDate, false),
          startDate: setTimePart(startDate, true));

    case Period.weekly:
      int dayOfWeek = date.weekday; // 1 = Monday, ..., 7 = Sunday
      DateTime startDate = date.subtract(Duration(days: dayOfWeek - 1));
      DateTime endDate = startDate.add(const Duration(days: 6));

      if (isNextPeriod) {
        startDate = startDate.add(const Duration(days: 7));
        endDate = endDate.add(const Duration(days: 7));
      }

      return DateRange(
          endDate: setTimePart(endDate, false),
          startDate: setTimePart(startDate, true));

    case Period.monthly:
      DateTime startDate = DateTime(date.year, date.month, 1);
      DateTime endDate = DateTime(date.year, date.month + 1, 1)
          .subtract(const Duration(days: 1));

      if (isNextPeriod) {
        startDate = DateTime(date.year, date.month + 1, 1);
        endDate = DateTime(date.year, date.month + 2, 1)
            .subtract(const Duration(days: 1));
      }

      return DateRange(
          endDate: setTimePart(endDate, false),
          startDate: setTimePart(startDate, true));
  }
}

DateTime setTimePart(DateTime input, isStart) {
  return DateTime(input.year, input.month, input.day, isStart ? 0 : 23,
      isStart ? 0 : 59, isStart ? 0 : 59);
}
