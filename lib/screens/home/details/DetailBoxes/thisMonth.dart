// ignore_for_file: file_names, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/screens/home/details/DetailBoxes/DetailBoxBody.dart';

class ThisMonth extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  DateTime mY;

  ThisMonth({super.key, required this.mY, required this.data});

  @override
  State<ThisMonth> createState() => _ThisMonthState();
}

class _ThisMonthState extends State<ThisMonth> {
  bool showAll = false;
  late DateTime mY;
  @override
  void initState() {
    mY = widget.mY;
    super.initState();
  }

  void toggleShowAll() {
    setState(() {
      showAll = !showAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    double sum = 0;
    Map<String, double> ranks = {};
    for (var item in widget.data) {
      if (mY.year.toString() == item['year'] &&
          DateFormat.MMM().format(mY).toString() == item['month']) {
        sum += item['cost'];
        if (ranks[item['itemName']] == null) {
          ranks[item['itemName']] = 0;
        }
        ranks[item['itemName']] = (ranks[item['itemName']]! + item['cost']);
      }
    }
    List<MapEntry<String, double>> sortedList = ranks.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    String heading = (mY == DateTime(DateTime.now().year, DateTime.now().month))
        ? "This Month"
        : "${DateFormat.MMM().format(mY)} ${mY.year}";
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() {
              mY = DateTime(mY.year, mY.month - 1, mY.day);
            });
          } else if (details.primaryVelocity! < 0) {
            setState(() {
              mY = DateTime(mY.year, mY.month + 1, mY.day);
            });
          }
        },
        child: DetailBoxBody(
          heading: heading,
          showAll: showAll,
          toggleShowAll: toggleShowAll,
          sum: sum,
          sortedList: sortedList,
        ));
  }
}
