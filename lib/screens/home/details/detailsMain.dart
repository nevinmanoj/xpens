// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
import 'package:xpens/screens/home/details/DetailBoxes/PerDay.dart';

import 'package:xpens/screens/home/details/calendar/calendarDisp.dart';
import 'package:xpens/screens/home/details/filter.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import 'package:xpens/shared/constants.dart';

import 'DetailBoxes/thisMonth.dart';
import 'DetailBoxes/thisYear.dart';

class Details extends StatefulWidget {
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DateTime mY = DateTime.now();
  String filter = filterList[0];
  // var stream = FirebaseFirestore.instance
  //     .collection('$db/${FirebaseAuth.instance.currentUser!.uid}/list')
  //     .orderBy('date', descending: true);
  void onFilterChanged(String val) {
    setState(() {
      filter = val;
      // stream = FirebaseFirestore.instance
      //     .collection('$db/${FirebaseAuth.instance.currentUser!.uid}/list')
      //     .orderBy('date', descending: true);
      // if (val == "Personel" || val == "Home") {
      //   stream = stream.where('location', isEqualTo: val);
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    final listData = Provider.of<UserInfoProvider>(context);

    List list = listData.docs;

    // List<Map<String, dynamic>> data = list
    //     .map((document) => document.data() as Map<String, dynamic>)
    //     .toList();
    if (filter != "All") {
      list = list.where((item) {
        return item['location'] == filter;
      }).toList();
    }
    Map<DateTime, double> events = {};
    Map<DateTime, Map<String, dynamic>> testMap = {};

    for (var item in list) {
      var date = DateTime.parse(item['date']);
      date = DateTime(date.year, date.month, date.day);
      if (events[date] == null) {
        events[date] = 0;
      }
      events[date] = events[date]! + item['cost'];
    }
    int i = 0;
    List dayx = [];
    List keys = [];
    for (var item in list) {
      var date = DateTime.parse(item['date']);
      date = DateTime(date.year, date.month, date.day);
      if (testMap[date] == null) {
        testMap[date] = {'cost': 0, 'listData': [], 'listKeys': []};
      }

      testMap[date]!['cost'] = testMap[date]!['cost']! + item['cost'];
      dayx = testMap[date]!['listData'];
      dayx.add(item);
      testMap[date]!['listData'] = dayx;
      keys = testMap[date]!['listKeys'];
      keys.add(list[i].id);
      testMap[date]!['listKeys'] = keys;

      i++;
    }

    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: ht * 0.02),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FilterDetails(
                    onFilterChanged: onFilterChanged,
                    filter: filter,
                  ),
                  CalendarDisp(
                    testmap: testMap,
                  ),
                  PerDay(data: list, date: DateTime.now(), heading: "Today"),
                  PerDay(
                      date: DateTime.now().subtract(const Duration(days: 1)),
                      data: list,
                      heading: "Yesterday"),
                  ThisMonth(mY: DateTime(mY.year, mY.month), data: list),

                  ThisYear(
                    year: mY.year,
                    data: list,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Caroursal(
                  //   stream: widget.stream,
                  // ),
                ],
              ),
            )),
      ],
    );
  }
}
