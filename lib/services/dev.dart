import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/database.dart';
import '../shared/datamodals.dart';

class DevDatabaseService extends DatabaseService {
  DevDatabaseService({required super.uid});

  Future injectTestData(
      {required String year,
      required String month,
      required double count}) async {
    List<String> Items = [
      "Breakfast",
      "Lunch",
      "Dinner",
      "Tea",
      "Petrol",
    ];

    var formattedTime = TimeOfDay.now();
    for (int i = 0; i < count; i++) {
      DateTime date = DateTime(int.parse(year),
          DateFormat("MMM").parse(month).month, Random().nextInt(28) + 1);
      double cost = Random().nextInt(151) + 50;
      String itemName = Items[Random().nextInt(4)];
      print("injectimg record $i");
      await addItem(Item(
          remarks: "remark $i",
          cost: cost,
          date: date,
          itemName: itemName,
          time: formattedTime));
    }
  }
}
