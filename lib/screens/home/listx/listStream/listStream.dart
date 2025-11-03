// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

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
    for (var item in list) {
      if (groupedList[DateFormat.yMMMd()
              .format(DateTime.parse(item['date']))
              .toString()] ==
          null) {
        groupedList[DateFormat.yMMMd()
            .format(DateTime.parse(item['date']))
            .toString()] = [item];
      } else {
        groupedList[DateFormat.yMMMd()
                .format(DateTime.parse(item['date']))
                .toString()]
            .add(item);
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
              color: const Color.fromARGB(255, 232, 232, 232),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Text(
                  iDate,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            for (var item in groupedList[iDate])
              itemWidget(context: context, iDate: iDate, item: item)
          ],
        );
      },
    );
  }
}
