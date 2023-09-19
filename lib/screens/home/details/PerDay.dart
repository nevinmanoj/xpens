import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PerDay extends StatefulWidget {
  final String heading;
  DateTime date;
  List<Map<String, dynamic>> data;
  PerDay(
      {super.key,
      required this.date,
      required this.heading,
      required this.data});

  @override
  State<PerDay> createState() => _PerDayState();
}

class _PerDayState extends State<PerDay> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

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
    return Container(
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
                  widget.heading,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
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
    );
    ;
  }
}
