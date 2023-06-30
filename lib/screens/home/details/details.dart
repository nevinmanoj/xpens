// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:intl/intl.dart';

import 'package:xpens/screens/home/details/downloadPopup.dart';
import 'package:xpens/screens/home/details/calendarDisp.dart';
import 'package:xpens/screens/home/details/filter.dart';
import 'package:xpens/screens/home/details/today.dart';
import 'package:xpens/screens/home/details/yesterday.dart';
import 'package:xpens/shared/constants.dart';

import 'package:xpens/shared/datamodals.dart';
import 'thisMonth.dart';

class Details extends StatefulWidget {
  DateTime mY = DateTime.now();
  String filter = filterList[0];

  var stream = FirebaseFirestore.instance
      .collection('UserInfo/${FirebaseAuth.instance.currentUser!.uid}/list')
      .orderBy('date', descending: true);
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void onFilterChanged(String val) {
    setState(() {
      widget.filter = val;
      widget.stream = FirebaseFirestore.instance
          .collection('UserInfo/${FirebaseAuth.instance.currentUser!.uid}/list')
          .orderBy('date', descending: true);
      if (val == "Personel" || val == "Home") {
        widget.stream = widget.stream.where('location', isEqualTo: val);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth auth = FirebaseAuth.instance;
    // User? user = auth.currentUser;
    double ht = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: ht * 0.02),
      child: StreamBuilder<QuerySnapshot>(
          stream: widget.stream.snapshots(),
          builder: (context, listSnapshot) {
            var list = listSnapshot.data?.docs;

            if (listSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Map<String, dynamic>> data = list!
                .map((document) => document.data() as Map<String, dynamic>)
                .toList();

            Map<DateTime, double> events = {};
            Map<DateTime, Map<String, dynamic>> testMap = {};
            for (var item in data) {
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
            for (var item in data) {
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

            return SingleChildScrollView(
              child: Column(
                children: [
                  FilterDetails(
                    onFilterChanged: onFilterChanged,
                    filter: widget.filter,
                  ),
                  CalendarDisp(
                    testmap: testMap,
                  ),
                  Today(
                    stream: widget.stream,
                  ),
                  Yesterday(
                    stream: widget.stream,
                  ),
                  ThisMonth(
                    stream: widget.stream,
                    mY: DateTime(widget.mY.year, widget.mY.month),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DOwnloadDetails(
                    data: data,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
