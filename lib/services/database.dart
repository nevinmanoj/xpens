import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../shared/datamodals.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference Usercollection =
      FirebaseFirestore.instance.collection('UserInfo');

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
    String key = DateTime.now().toString();
    String month = DateFormat.MMM().format(I.date).toString();

    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));

    try {
      await FirebaseFirestore.instance
          .collection('UserInfo/$uid/list')
          .doc(key)
          .set({
        "month": month,
        "year": year,
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
    try {
      String year = I.date.year.toString();
      String key = id;
      String month = DateFormat.MMM().format(I.date).toString();

      String formattedTime = DateFormat('HH:mm')
          .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));
      await FirebaseFirestore.instance
          .collection('UserInfo/$uid/list')
          .doc(key)
          .set({
        "month": month,
        "year": year,
        "cost": I.cost,
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
}
