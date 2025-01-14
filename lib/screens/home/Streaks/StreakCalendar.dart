// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:xpens/services/streakDatabase.dart';
import 'package:xpens/shared/constants.dart';

class StreakCalendar extends StatefulWidget {
  final List<DateTime> list;
  final DateTime addedDate;
  final String selfId;
  final bool selectRed;

  const StreakCalendar(
      {super.key,
      required this.list,
      required this.addedDate,
      required this.selfId,
      required this.selectRed});

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  var _calendarFormat = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    void onDaySelected(DateTime selectedDate, DateTime selectedDate2) {
      DateTime dateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      bool marked = widget.list.contains(dateOnly);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                  "${marked ? "Unmark" : "Mark"} ${DateFormat.yMMMd().format(selectedDate)}?"),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: secondaryAppColor),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(primaryAppColor)),
                  onPressed: () {
                    if (marked) {
                      StreakDatabaseService(uid: user!.uid)
                          .unmarkDate(selfId: widget.selfId, day: selectedDate);
                    } else {
                      StreakDatabaseService(uid: user!.uid)
                          .markDate(selfId: widget.selfId, day: selectedDate);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Confirm"),
                )
              ],
            );
          });
    }

    return TableCalendar(
      onDaySelected: onDaySelected,
      rowHeight: 90,
      lastDay: DateTime.now(),
      firstDay: widget.addedDate,
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
      // selectedDayPredicate: (day) => isSameDay(DateTime.now(), day),
      // calendarStyle: CalendarStyle(
      //   outsideDaysVisible: false,
      //   isTodayHighlighted: false,
      //   defaultDecoration: BoxDecoration(
      //     color: Colors.grey.withOpacity(0.1),
      //     shape: BoxShape.rectangle,
      //     borderRadius: const BorderRadius.all(Radius.circular(5)),
      //   ),
      //   weekendDecoration: BoxDecoration(
      //     color: Colors.grey.withOpacity(0.1),
      //     shape: BoxShape.rectangle,
      //     borderRadius: const BorderRadius.all(Radius.circular(5)),
      //   ),
      //   selectedDecoration: const BoxDecoration(
      //     color: primaryAppColor,
      //     shape: BoxShape.rectangle,
      //     borderRadius: BorderRadius.all(Radius.circular(5)),
      //   ),
      //   todayDecoration: BoxDecoration(
      //       borderRadius: const BorderRadius.all(Radius.circular(5)),
      //       color: secondaryAppColor.withOpacity(0.5),
      //       shape: BoxShape.rectangle),
      // ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          bool value =
              widget.list.contains(DateTime(day.year, day.month, day.day));
          return Center(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: (value == widget.selectRed) //TT,FF red, TF,FT green
                    ? const Color.fromARGB(255, 255, 66, 66)
                    : const Color.fromARGB(255, 65, 201, 70),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Text(
                day.day.toString(),
              ),
            ),
          );
        },
      ),
    );
  }
}
