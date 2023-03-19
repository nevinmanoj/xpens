import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../shared/datamodals.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  Future updateUserName(String Name) async {
    return await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(uid)
        .set({
      'Name': Name,
    }, SetOptions(merge: true));
  }

  Future updateUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(uid)
        .set({
      'Email': email,
    }, SetOptions(merge: true));
  }

  Future updateUserPhone(String PhoneNumber) async {
    return await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(uid)
        .set({
      'PhoneNumber': PhoneNumber,
    }, SetOptions(merge: true));
  }

  Future<bool> addItem(Item I) async {
    String year = I.date.year.toString();
    String day = I.date.day.toString();
    String key = DateTime.now().toString();
    String month = DateFormat.MMM().format(I.date).toString();
    I.date = DateTime(
        I.date.year, I.date.month, I.date.day, I.time.hour, I.time.minute);
    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));

    try {
      await FirebaseFirestore.instance
          .collection('UserInfo/$uid/list')
          .doc(key)
          .set({
        "month": month,
        "year": year,
        "day": day,
        "remarks": I.remarks,
        "cost": I.cost,
        "date": I.date.toString(),
        "time": formattedTime,
        "itemName":
            I.itemName.substring(0, 1).toUpperCase() + I.itemName.substring(1)
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  Future deleteItem(String id) async {
    FirebaseFirestore.instance
        .collection('UserInfo/$uid/list')
        .doc(id)
        .delete();
  }

  Future<bool> editItem({required Item I, required String id}) async {
    String year = I.date.year.toString();

    String month = DateFormat.MMM().format(I.date).toString();
    String day = I.date.day.toString();
    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));
    I.date = DateTime(
        I.date.year, I.date.month, I.date.day, I.time.hour, I.time.minute);
    try {
      await FirebaseFirestore.instance
          .collection('UserInfo/$uid/list')
          .doc(id)
          .set({
        "month": month,
        "year": year,
        "cost": I.cost,
        "remarks": I.remarks,
        "day": day,
        "date": I.date.toString(),
        "time": formattedTime,
        "itemName": I.itemName
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  // Future injectTestData(
  //     {required String year,
  //     required String month,
  //     required double count}) async {
  //   List<String> Items = [
  //     "Breakfast",
  //     "Lunch",
  //     "Dinner",
  //     "Tea",
  //     "Petrol",
  //   ];

  //   var formattedTime = TimeOfDay.now();
  //   for (int i = 0; i < count; i++) {
  //     DateTime date = DateTime(int.parse(year),
  //         DateFormat("MMM").parse(month).month, Random().nextInt(28) + 1);
  //     double cost = Random().nextInt(151) + 50;
  //     String itemName = Items[Random().nextInt(4)];
  //     print("injectimg record $i");
  //     await addItem(Item(
  //         remarks: "remark $i",
  //         cost: cost,
  //         date: date,
  //         itemName: itemName,
  //         time: formattedTime));
  //   }
  // }
}
