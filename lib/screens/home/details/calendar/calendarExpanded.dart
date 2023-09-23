import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xpens/screens/home/details/calendar/addFromCalendar.dart';
import 'package:xpens/screens/home/listx/listStream/deleteExpense.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';
import 'package:xpens/shared/constants.dart';

class CalendarExp extends StatefulWidget {
  final DateTime date;
  final List data;
  final List keys;
  final double cost;
  const CalendarExp(
      {super.key,
      required this.data,
      required this.date,
      required this.keys,
      required this.cost});
  @override
  State<CalendarExp> createState() => _CalendarExpState();
}

class _CalendarExpState extends State<CalendarExp> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    List<Widget> items = [];

    for (int i = 0; i < widget.data.length; i++) {
      items.add(
        buildItem(data: widget.data[i], key: widget.keys[i], context: context),
      );
    }
    if (items != []) {
      items.add(buildLastRow(widget.cost));
    }
    return SizedBox(
      width: wt * 0.9,
      child: AlertDialog(
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
        insetPadding: EdgeInsets.fromLTRB(
          0,
          0,
          0,
          ht * 0.1,
        ),
        title: Row(
          children: [
            const Spacer(),
            const Spacer(),
            Text(DateFormat.yMMMd().format(widget.date).toString()),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => AddFromCal(
                                date: widget.date,
                              )));
                },
                icon: const Icon(Icons.add))
          ],
        ),
        content: SizedBox(
          // height: 300,
          width: wt * 0.8,
          child: SingleChildScrollView(
            child: Column(
              children: items,
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildItem(
    {required var data, required var key, required BuildContext context}) {
  String iDate =
      DateFormat.yMMMd().format(DateTime.parse(data['date'])).toString();
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
          width: 120,
          child: Text(
            data['itemName'],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          )),
      Container(
          width: 90,
          child: Text(
            "₹ ${data['cost'].toString()}",
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          )),
      Spacer(),
      IconButton(
          onPressed: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => EditxDetails(
                          id: key,
                          item: data,
                        )));
          },
          icon: Icon(
            color: primaryAppColor,
            Icons.edit,
          )),
      IconButton(
          onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return DeleteExpense(
                    id: key,
                    name: data['itemName'],
                    cost: data['cost'].toString(),
                    date: iDate,
                  );
                },
              ),
          icon: Icon(
            color: primaryAppColor,
            Icons.delete,
          )),
    ],
  );
}

Widget buildLastRow(double cost) {
  return Row(
    children: [
      Container(
          width: 120,
          child: Text(
            "TOTAL",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
      Container(
          width: 90,
          child: Text(
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            "₹ $cost",
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          )),
    ],
  );
}
