// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:xpens/screens/home/details/calendar/addFromCalendar.dart';
import 'package:xpens/screens/home/listx/listStream/deleteExpense.dart';
import 'package:xpens/screens/home/listx/listStream/editMain.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../services/providers/UserInfoProvider.dart';

class CalendarExp extends StatefulWidget {
  final DateTime date;

  const CalendarExp({super.key, required this.date});
  @override
  State<CalendarExp> createState() => _CalendarExpState();
}

class _CalendarExpState extends State<CalendarExp> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return SizedBox(
      width: wt * 0.9,
      child: StatefulBuilder(builder: (context, setState) {
        final listData = Provider.of<UserInfoProvider>(context);

        List list = listData.docs;
        // print(list);
        list = list.where((item) {
          DateTime itemDate = DateTime.parse(item['date']);

          return widget.date ==
              DateTime(itemDate.year, itemDate.month, itemDate.day);
        }).toList();
        double cost = 0;
        for (var item in list) {
          cost += item['cost'];
        }

        List<Widget> items = [];

        for (int i = 0; i < list.length; i++) {
          items.add(
            buildItem(data: list[i], key: list[i].id, context: context),
          );
        }
        if (items.isNotEmpty) {
          items.add(buildLastRow(cost));
        }
        return AlertDialog(
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
        );
      }),
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
