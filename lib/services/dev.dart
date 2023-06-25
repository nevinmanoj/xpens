import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/auth.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';
import '../shared/datamodals.dart';

class DevService {
  Future switchAc() async {
    await AuthSerivice().signOut();
    await AuthSerivice().loginWithEmail("nevinmanojnew@gmail.com", "password");
  }

  Future addFieldToDocuments() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    print("adding fields");
    List<String> Items = [
      "Breakfast",
      "Lunch",
      "Dinner",
      "Tea and Snacks",
      "Petrol",
      "Icecream",
    ];
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('UserInfo/${user!.uid}/list');

    QuerySnapshot snapshot =
        await collectionRef.where('isOther', isEqualTo: true).get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      print("uncomment");

      // DocumentReference docRef = collectionRef.doc(doc.id);
      // await docRef.update({'isOther': newData});
    }
  }

  Future injectTestData(
      {required String year,
      required String month,
      required double count}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
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
      String location = locationList[Random().nextInt(2)];
      print("injectimg record $i");
      await DatabaseService(uid: user!.uid).addItem(AddItem(
          isOther: false,
          location: location,
          remarks: "remark $i",
          cost: cost,
          date: date,
          itemName: itemName,
          time: formattedTime));
    }
  }
}
