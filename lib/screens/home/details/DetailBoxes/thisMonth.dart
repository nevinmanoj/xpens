// ignore_for_file: file_names, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/screens/home/details/DetailBoxes/DetailBoxBody.dart';

import '../../../../shared/constants.dart';

class ThisMonth extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  DateTime mY;

  ThisMonth({super.key, required this.mY, required this.data});

  @override
  State<ThisMonth> createState() => _ThisMonthState();
}

class _ThisMonthState extends State<ThisMonth> {
  bool showAll = false;
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
      if (widget.mY.year.toString() == item['year'] &&
          DateFormat.MMM().format(widget.mY).toString() == item['month']) {
        sum += item['cost'];
        if (ranks[item['itemName']] == null) {
          ranks[item['itemName']] = 0;
        }
        ranks[item['itemName']] = (ranks[item['itemName']]! + item['cost']);
      }
    }
    List<MapEntry<String, double>> sortedList = ranks.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    String heading =
        (widget.mY == DateTime(DateTime.now().year, DateTime.now().month))
            ? "This Month"
            : "${DateFormat.MMM().format(widget.mY)} ${widget.mY.year}";
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() {
              widget.mY =
                  DateTime(widget.mY.year, widget.mY.month - 1, widget.mY.day);
            });
          } else if (details.primaryVelocity! < 0) {
            setState(() {
              widget.mY =
                  DateTime(widget.mY.year, widget.mY.month + 1, widget.mY.day);
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
