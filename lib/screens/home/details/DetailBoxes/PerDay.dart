import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'DetailBoxBody.dart';

class PerDay extends StatefulWidget {
  final String heading;
  final DateTime date;
  final List<Map<String, dynamic>> data;
  PerDay(
      {super.key,
      required this.date,
      required this.heading,
      required this.data});

  @override
  State<PerDay> createState() => _PerDayState();
}

class _PerDayState extends State<PerDay> {
  bool showAll = false;
  void toggleShowAll() {
    setState(() {
      showAll = !showAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double wt = MediaQuery.of(context).size.width;

    double sum = 0;
    Map<String, double> ranks = {};
    for (var item in widget.data) {
      {
        if (widget.date.year.toString() == item['year'] &&
            DateFormat.MMM().format(widget.date).toString() == item['month'] &&
            widget.date.day.toString() == item['day']) {
          sum += item['cost'];
          if (ranks[item['itemName']] == null) {
            ranks[item['itemName']] = 0;
          }
          ranks[item['itemName']] = (ranks[item['itemName']]! + item['cost']);
        }
      }
    }
    List<MapEntry<String, double>> sortedList = ranks.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return DetailBoxBody(
      heading: widget.heading,
      showAll: showAll,
      toggleShowAll: toggleShowAll,
      sum: sum,
      sortedList: sortedList,
    );
  }
}
