// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xpens/shared/constants.dart';

import '../spendChart.dart' show shortRupee;

/// Week or month calendar with each day's total. Tapping a day calls
/// [onDayTap].
class CalendarDisp extends StatefulWidget {
  final Map<DateTime, double> dayTotals;
  final ValueChanged<DateTime> onDayTap;

  const CalendarDisp(
      {super.key, required this.dayTotals, required this.onDayTap});

  @override
  State<CalendarDisp> createState() => _CalendarDispState();
}

class _CalendarDispState extends State<CalendarDisp> {
  var _format = CalendarFormat.week;
  DateTime _focused = DateTime.now();

  Widget _cell(DateTime day, {bool today = false, bool outside = false}) {
    final total = widget.dayTotals[DateTime(day.year, day.month, day.day)];
    // Fill the whole cell so every pill is the same size, whatever its text.
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
      decoration: BoxDecoration(
        color: today
            ? primaryAppColor
            : (outside ? Colors.transparent : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${day.day}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: today ? FontWeight.w700 : FontWeight.w500,
              color: today
                  ? Colors.white
                  : (outside ? Colors.grey.shade400 : Colors.black87),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            total == null ? "" : shortRupee(total),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: today
                  ? secondaryAppColor
                  : (outside ? Colors.grey.shade400 : Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeek = _format == CalendarFormat.week;
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: 56,
      daysOfWeekHeight: 20,
      firstDay: DateTime(2019),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: _focused,
      calendarFormat: _format,
      availableCalendarFormats: const {
        CalendarFormat.week: "Week",
        CalendarFormat.month: "Month",
      },
      onFormatChanged: (f) => setState(() => _format = f),
      onPageChanged: (d) => _focused = d,
      onDaySelected: (day, focused) {
        setState(() => _focused = focused);
        widget.onDayTap(DateTime(day.year, day.month, day.day));
      },
      headerStyle: HeaderStyle(
        titleTextStyle:
            const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        headerPadding: const EdgeInsets.only(bottom: 8),
        leftChevronPadding: EdgeInsets.zero,
        rightChevronPadding: EdgeInsets.zero,
        leftChevronMargin: EdgeInsets.zero,
        rightChevronMargin: EdgeInsets.zero,
        formatButtonShowsNext: true,
        formatButtonTextStyle: const TextStyle(fontSize: 12),
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        weekendStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: !isWeek,
        cellMargin: EdgeInsets.zero,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, _) => _cell(day),
        todayBuilder: (context, day, _) => _cell(day, today: true),
        outsideBuilder: (context, day, _) => _cell(day, outside: true),
        disabledBuilder: (context, day, _) => _cell(day, outside: true),
      ),
    );
  }
}
