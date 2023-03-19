import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xpens/screens/home/details/downloadPopup.dart';
import 'package:xpens/screens/home/details/barGraph.dart';
import 'package:xpens/screens/home/details/today.dart';
import 'package:xpens/screens/home/details/yesterday.dart';
import 'package:xpens/services/auth.dart';
import 'package:xpens/services/toast.dart';
import 'package:xpens/shared/constants.dart';

import 'month.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
String curDate = "";
String month = DateFormat.MMM().format(DateTime.now()).toString();
String year = DateTime.now().year.toString();
String iDate = "";
DateTime today = DateTime.now();

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UserInfo/${user!.uid}/list')
            .orderBy('date', descending: true)
            .snapshots(),
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

          Map<String, double> weekDates = {};

          var limit = DateTime.now().subtract(Duration(days: 6));
          limit = DateTime(limit.year, limit.month, limit.day);
          List<dynamic> filteredEvents = data.where((event) {
            DateTime eventDate = DateTime.parse(event['date']);
            return eventDate.isAfter(limit) ||
                eventDate.isAtSameMomentAs(limit);
          }).toList();

          for (var item in filteredEvents) {
            var key = DateFormat.MMMd()
                .format(DateTime.parse(item['date']))
                .toString();
            if (weekDates[key] == null) {
              weekDates[key] = 0;
            }

            weekDates[key] = (weekDates[key]! + item['cost']);
          }
          List<Expense> barData = [];

          for (var day in weekDates.keys) {
            barData.add(Expense(day, weekDates[day]!));
          }

          List<Series<Expense, String>> expenseData = [
            Series(
              id: "Expenses",
              data: barData.reversed.toList(),
              domainFn: (Expense expense, _) => expense.day,
              measureFn: (Expense expense, _) => expense.amount,
              colorFn: (Expense expense, _) =>
                  ColorUtil.fromDartColor(Colors.black),
            ),
          ];
          return SingleChildScrollView(
            child: Column(
              children: [
                DashboardScreen(
                  animate: true,
                  seriesList: expenseData,
                ),
                Today(),
                Yesterday(),
                ThisMonth(),
                SizedBox(
                  height: 5,
                ),
                DOwnloadDetails(
                  data: data,
                ),
              ],
            ),
          );
        });
  }
}

class Expense {
  final String day;
  final double amount;

  Expense(this.day, this.amount);
}
