import 'package:flutter/material.dart';
import 'package:xpens/screens/home/details/DetailBoxes/DetailBoxBody.dart';

class ThisYear extends StatefulWidget {
  final List data;

  final int year;

  const ThisYear({super.key, required this.year, required this.data});

  @override
  State<ThisYear> createState() => _ThisYearState();
}

class _ThisYearState extends State<ThisYear> {
  bool showAll = false;
  late int year;
  @override
  void initState() {
    year = widget.year;
    super.initState();
  }

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
      if (item['year'] == year.toString()) {
        sum += item['cost'];
        if (ranks[item['itemName']] == null) {
          ranks[item['itemName']] = 0;
        }
        ranks[item['itemName']] = (ranks[item['itemName']]! + item['cost']);
      }
    }
    List<MapEntry<String, double>> sortedList = ranks.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    String heading = (year == DateTime.now().year) ? "This Year" : "$year";

    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            setState(() {
              year--;
            });
          } else if (details.primaryVelocity! < 0) {
            setState(() {
              year++;
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
