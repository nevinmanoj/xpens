import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class ThisYear extends StatefulWidget {
  List<Map<String, dynamic>> data;

  int year;

  ThisYear({super.key, required this.year, required this.data});

  @override
  State<ThisYear> createState() => _ThisYearState();
}

class _ThisYearState extends State<ThisYear> {
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
      child: Container(
        margin: EdgeInsets.fromLTRB(wt * 0.05, 10, wt * 0.05, 0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        // height: 200,
        width: 0.9 * wt,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    heading,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "TOTAL:  ${sum.toInt().toString()} ₹ ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 5,
              ),
              for (int i = 0;
                  i < sortedList.length;
                  // i < ((sortedList.length < 3) ? sortedList.length : 3);
                  i++)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "${sortedList[i].key}:   ${sortedList[i].value.toInt()} ₹",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
