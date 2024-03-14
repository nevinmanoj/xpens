import 'package:flutter/material.dart';

import '../../details/DetailBoxes/DetailBoxBody.dart';

class GroupSummary extends StatefulWidget {
  final List data;

  final String group;

  const GroupSummary({super.key, required this.group, required this.data});

  @override
  State<GroupSummary> createState() => _GroupSummaryState();
}

class _GroupSummaryState extends State<GroupSummary> {
  bool showAll = false;

  @override
  void initState() {
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
      sum += item['cost'];
      if (ranks[item['itemName']] == null) {
        ranks[item['itemName']] = 0;
      }
      ranks[item['itemName']] = (ranks[item['itemName']]! + item['cost']);
    }
    List<MapEntry<String, double>> sortedList = ranks.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return DetailBoxBody(
        heading: "Summary",
        showAll: showAll,
        sortedList: sortedList,
        sum: sum,
        toggleShowAll: toggleShowAll);
  }
}
