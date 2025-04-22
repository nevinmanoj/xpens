// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:xpens/screens/home/details/calendar/calendarExpanded.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/utils/formatCost.dart';

class CalendarDisp extends StatefulWidget {
  final Map<DateTime, double> testmap;

  const CalendarDisp({super.key, required this.testmap});

  @override
  State<CalendarDisp> createState() => _CalendarDispState();
}

class _CalendarDispState extends State<CalendarDisp> {
  // DateTime _selectedDate = DateTime.now();
  var _calendarFormat = CalendarFormat.week;
  // @override
  // void initState() {
  //   super.initState();
  //   _selectedDate = DateTime.now();
  // }

  void _onDaySelected(DateTime selectedDate, DateTime selectedDate2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          DateTime date =
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

          return CalendarExp(
            date: date,
          );
        });
    // setState(() {
    //   _selectedDate =
    //       DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      startingDayOfWeek: StartingDayOfWeek.monday,
      rowHeight: 90,
      lastDay: DateTime.now().add(const Duration(days: 30)),
      firstDay: DateTime(2022),
      focusedDay: DateTime.now(),
      availableCalendarFormats: const {
        CalendarFormat.week: "Week",
        CalendarFormat.month: "Month"
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onDaySelected: _onDaySelected,
      selectedDayPredicate: (day) => isSameDay(DateTime.now(), day),
      calendarStyle: CalendarStyle(
        defaultDecoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        weekendDecoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        selectedDecoration: const BoxDecoration(
          color: primaryAppColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        todayDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: secondaryAppColor.withOpacity(0.5),
            shape: BoxShape.rectangle),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final value = widget.testmap[DateTime(day.year, day.month, day.day)];

          if (value != null) {
            return Center(
              child: Container(
                width: 40,
                margin: const EdgeInsets.only(top: 50),
                child: Text(
                  textAlign: TextAlign.center,
                  '₹ ${formatDouble(value)}',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSameDay(DateTime.now(), day)
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
