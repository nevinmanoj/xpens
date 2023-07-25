import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/auth.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';
import '../../../shared/datamodals.dart';

class DevService {
  Future switchAc() async {
    // await AuthSerivice().signOut();
    await AuthSerivice().loginWithEmail("nevinmanojnew@gmail.com", "password");
  }

  Future addFieldToDocuments() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    print("adding fields ");

    // CollectionReference collectionRef =
    //     FirebaseFirestore.instance.collection('UserInfo');

    // QuerySnapshot snapshot = await collectionRef.get();

    // for (QueryDocumentSnapshot doc in snapshot.docs) {
    //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //   DocumentReference docRef = collectionRef.doc(doc.id);
    //   await docRef.update({
    //     'items': [
    //       "Breakfast",
    //       "Lunch",
    //       "Dinner",
    //       "Tea and Snacks",
    //       "Petrol",
    //       "Icecream",
    //       "Other"
    //     ]
    //   });

    //   // docRef.update({
    //   //   "itemNames": FieldValue.delete(),
    //   // });
    // }
    List items = [
      "Breakfast",
      "Lunch",
      "Dinner",
      "Tea and Snacks",
      "Petrol",
      "Icecream",
    ];
    for (var item in items)
      DatabaseService(uid: user!.uid)
          .updateItemsArray(add: true, item: item, progress: (_) {});
  }

  Future injectTestData(
      {required String year,
      required String month,
      required double count}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    List<String> mainItems = [
      "Breakfast",
      "Lunch",
      "Dinner",
      "Tea and Snacks",
      "Petrol",
      "Icecream",
    ];
    var formattedTime = TimeOfDay.now();
    for (int i = 0; i < count; i++) {
      DateTime date = DateTime(int.parse(year),
          DateFormat("MMM").parse(month).month, Random().nextInt(28) + 1);
      double cost = Random().nextInt(151) + 50;
      String itemName = mainItems[Random().nextInt(4)];
      String location = locationList[Random().nextInt(2)];
      print("injectimg record $i");
      DatabaseService(uid: user!.uid).addItem(AddItem(
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
