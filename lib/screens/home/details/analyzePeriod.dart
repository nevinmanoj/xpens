import 'package:intl/intl.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/subModals/PeriodDates.dart';
import 'package:xpens/shared/utils/getDateTimesFromPeriod.dart';

/// The period the Analyze tab is looking at: a [mode] (day, week, …) and an
/// [offset] from the current one (0 = this week, -1 = last week, …).
class AnalyzePeriod {
  final Period mode;
  final int offset;
  const AnalyzePeriod(this.mode, this.offset);

  static const modes = [
    Period.daily,
    Period.weekly,
    Period.monthly,
    Period.quarter,
    Period.halfYear,
    Period.year,
  ];

  static String modeLabel(Period p) => switch (p) {
        Period.daily => "Day",
        Period.weekly => "Week",
        Period.monthly => "Month",
        Period.quarter => "Quarter",
        Period.halfYear => "Half-year",
        Period.year => "Year",
      };

  /// Month view of [month], as an offset from the current month.
  static AnalyzePeriod ofMonth(DateTime month) {
    final now = DateTime.now();
    return AnalyzePeriod(Period.monthly,
        (month.year * 12 + month.month) - (now.year * 12 + now.month));
  }

  DateRange get range =>
      getDateTimesFromPeriod(p: mode, date: DateTime.now(), offset: offset);

  AnalyzePeriod get previous => AnalyzePeriod(mode, offset - 1);
  AnalyzePeriod get next => AnalyzePeriod(mode, offset + 1);
  bool get canGoNext => offset < 0;

  /// Chart buckets are months for quarter and longer, days otherwise.
  bool get byMonth =>
      mode == Period.quarter || mode == Period.halfYear || mode == Period.year;

  bool get inProgress {
    final now = DateTime.now();
    final r = range;
    return !now.isBefore(r.startDate) && !now.isAfter(r.endDate);
  }

  /// End of the part of the period that has happened so far.
  DateTime get elapsedEnd {
    final now = DateTime.now();
    final end = range.endDate;
    return now.isBefore(end) ? now : end;
  }

  /// Start of each chart bucket (each day, or each month).
  List<DateTime> get buckets {
    final r = range;
    final start = r.startDate;
    if (mode == Period.daily) return [start];
    if (byMonth) {
      return [
        for (var m = DateTime(start.year, start.month);
            !m.isAfter(r.endDate);
            m = DateTime(m.year, m.month + 1))
          m
      ];
    }
    return [
      for (var d = DateTime(start.year, start.month, start.day);
          !d.isAfter(r.endDate);
          d = DateTime(d.year, d.month, d.day + 1))
        d
    ];
  }

  /// Index of the bucket [d] falls in, or -1 when outside the period.
  int bucketOf(DateTime d) {
    final r = range;
    if (d.isBefore(r.startDate) || d.isAfter(r.endDate)) return -1;
    final s = r.startDate;
    if (mode == Period.daily) return 0;
    if (byMonth) return (d.year * 12 + d.month) - (s.year * 12 + s.month);
    return DateTime(d.year, d.month, d.day)
        .difference(DateTime(s.year, s.month, s.day))
        .inDays;
  }

  /// Buckets that have started, used for averages.
  int get elapsedBuckets {
    if (!inProgress) return buckets.length;
    return bucketOf(DateTime.now()) + 1;
  }

  String get unit => byMonth ? "month" : "day";

  String get title {
    final r = range;
    final s = r.startDate;
    switch (mode) {
      case Period.daily:
        if (offset == 0) return "Today";
        if (offset == -1) return "Yesterday";
        return DateFormat(s.year == DateTime.now().year
                ? "EEE, d MMM"
                : "EEE, d MMM y")
            .format(s);
      case Period.weekly:
        if (offset == 0) return "This week";
        if (offset == -1) return "Last week";
        final e = r.endDate;
        final sameMonth = s.month == e.month;
        return "${DateFormat(sameMonth ? "d" : "d MMM").format(s)} – "
            "${DateFormat(e.year == DateTime.now().year ? "d MMM" : "d MMM y").format(e)}";
      case Period.monthly:
        return DateFormat.yMMMM().format(s);
      case Period.quarter:
        return "Q${(s.month - 1) ~/ 3 + 1} ${s.year}";
      case Period.halfYear:
        return "H${s.month <= 6 ? 1 : 2} ${s.year}";
      case Period.year:
        return "${s.year}";
    }
  }

  /// How the previous period is named in "vs …".
  String get previousLabel {
    if (mode == Period.daily && offset == 0) return "yesterday";
    if (mode == Period.weekly && offset == 0) return "last week";
    if (mode == Period.monthly) {
      return DateFormat.MMM().format(previous.range.startDate);
    }
    return previous.title;
  }

  /// Short label under a chart bar.
  String bucketLabel(int i) {
    final d = buckets[i];
    if (byMonth) {
      return mode == Period.year
          ? DateFormat.MMM().format(d).substring(0, 1)
          : DateFormat.MMM().format(d);
    }
    if (mode == Period.weekly) return DateFormat.E().format(d).substring(0, 2);
    return "${d.day}";
  }

  /// Full label for a bar's tooltip.
  String bucketTitle(int i) {
    final d = buckets[i];
    return byMonth
        ? DateFormat.yMMM().format(d)
        : DateFormat("EEE, d MMM").format(d);
  }
}
