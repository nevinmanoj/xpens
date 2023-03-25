import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/auth.dart';
import 'package:xpens/services/database.dart';
import '../shared/datamodals.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class DevService {
  Future switchAc() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    String email = user!.email == "nevinmanojnew@gmail.com"
        ? "nevinmanojp@gmail.com"
        : "nevinmanojnew@gmail.com";

    await AuthSerivice().signOut();
    await AuthSerivice().loginWithEmail(email, "password");
  }

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
      await DatabaseService(uid: user!.uid).addItem(AddItem(
          remarks: "remark $i",
          cost: cost,
          date: date,
          itemName: itemName,
          time: formattedTime));
    }
  }
}
