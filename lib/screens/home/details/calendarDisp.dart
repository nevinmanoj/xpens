// ignore: file_names
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xpens/shared/constants.dart';

class CalendarDisp extends StatefulWidget {
  // final Map<DateTime, double> events;
  final Map<DateTime, Map<String, dynamic>> testmap;

  const CalendarDisp({super.key, required this.testmap});

  // CalendarDisp({required this.events, required this.testmap});

  @override
  _CalendarDispState createState() => _CalendarDispState();
}

class _CalendarDispState extends State<CalendarDisp> {
  DateTime _selectedDate = DateTime.now();
  var _calendarFormat = CalendarFormat.week;
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _onDaySelected(DateTime selectedDate, DateTime selectedDate2) {
    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         content: Text("select day $selectedDate"),
    //       );
    //     });
    setState(() {
      _selectedDate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TableCalendar(
        rowHeight: 90,
        lastDay: DateTime.now().add(Duration(days: 30)),
        firstDay: DateTime(2022),
        focusedDay: DateTime.now(),
        availableCalendarFormats: {
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
        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
        calendarStyle: CalendarStyle(
          // rowDecoration: BoxDecoration(color: Colors.yellow),
          defaultDecoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          selectedDecoration: BoxDecoration(
            color: primaryAppColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          todayDecoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: secondaryAppColor.withOpacity(0.5),
              shape: BoxShape.rectangle),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            // final value = widget.events[DateTime(day.year, day.month, day.day)];
            var map = widget.testmap[DateTime(day.year, day.month, day.day)];
            if (map == null) return Container();
            final value = map['cost'];
            if (value != null) {
              return Center(
                child: Container(
                  width: 40,
                  margin: const EdgeInsets.only(top: 50),
                  child: Text(
                    textAlign: TextAlign.center,
                    '₹ $value',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSameDay(_selectedDate, day)
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
      ),
    );
  }
}
