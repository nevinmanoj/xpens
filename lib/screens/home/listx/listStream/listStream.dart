// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/utils/formatCost.dart';

import 'ListItem.dart';
import '../../../../shared/utils/filterFunction.dart';

class StreamBodyState extends StatefulWidget {
  final filter;
  const StreamBodyState({super.key, required this.filter});

  @override
  State<StreamBodyState> createState() => _StreamBodyStateState();
}

class _StreamBodyStateState extends State<StreamBodyState> {
  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<UserInfoProvider>(context);
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    List list = listData.docs;

    list = applyFilter(data: list, filter: widget.filter);
    Map groupedList = {};
    Map<String, double> dateSum = {};
    for (var item in list) {
      String dateStr =
          DateFormat.yMMMd().format(DateTime.parse(item['date'])).toString();
      if (groupedList[dateStr] == null) {
        groupedList[dateStr] = [item];
        dateSum[dateStr] = item['cost'];
      } else {
        groupedList[dateStr].add(item);
        dateSum[dateStr] = (dateSum[dateStr]! + item['cost']);
      }
    }
    return ListView.builder(
      // itemCount: list.length + 2,
      itemCount: groupedList.keys.length + 1,
      itemBuilder: (context, i) {
        if (i == 0)
          return Container(
            height: ht * 0.095,
          );
        String iDate = groupedList.keys.toList()[i - 1];
        return Column(
          children: [
            Container(
              width: wt,
              height: 35,
              color: const Color.fromARGB(255, 232, 232, 232),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      iDate,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                        width: 100,
                        child: Text(
                          "₹ ${formatDouble(dateSum[iDate] ?? 0).toString()}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                  ],
                ),
              ),
            ),
            for (var item in groupedList[iDate])
              itemWidget(
                context: context,
                iDate: iDate,
                item: item,
              )
          ],
        );
      },
    );
  }
}
