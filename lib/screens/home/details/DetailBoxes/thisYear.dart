import 'package:flutter/material.dart';
import 'package:xpens/screens/home/details/DetailBoxes/DetailBoxBody.dart';
import 'package:xpens/shared/constants.dart';

class ThisYear extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  int year;

  ThisYear({super.key, required this.year, required this.data});

  @override
  State<ThisYear> createState() => _ThisYearState();
}

class _ThisYearState extends State<ThisYear> {
  bool showAll = false;
  void toggleShowAll() {
    setState(() {
      showAll = !showAll;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double sum = 0;
    Map<String, double> ranks = {};
    for (var item in widget.data) {
      if (item['year'] == widget.year.toString()) {
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
        (widget.year == DateTime.now().year) ? "This Year" : "${widget.year}";

    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() {
              widget.year--;
            });
          } else if (details.primaryVelocity! < 0) {
            setState(() {
              widget.year++;
            });
          }
        },
        child: DetailBoxBody(
            heading: heading,
            showAll: showAll,
            sortedList: sortedList,
            sum: sum,
            toggleShowAll: toggleShowAll));
  }
}
