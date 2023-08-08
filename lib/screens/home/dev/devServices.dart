import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xpens/services/auth.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/shared/constants.dart';
import '../../../shared/datamodals.dart';

class DevService {
  Future switchAc() async {
    await AuthSerivice().loginWithEmail("dev@gmail.com", "password");
  }

  Future addFieldToDocuments() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    print("adding fields ");

    // copyDocument(
    //     sourceCollection: 'UserInfo',
    //     sourceDocumentId: "zWxHz89t7qc1KhfSOhhicSTyyJI3",
    //     destinationCollection: 'UserInfoProd',
    //     destinationDocumentId: "zWxHz89t7qc1KhfSOhhicSTyyJI3");

    // copyCollection(
    //     destinationCollection: 'UserInfoProd/zWxHz89t7qc1KhfSOhhicSTyyJI3/list',
    //     sourceCollection: 'UserInfo/zWxHz89t7qc1KhfSOhhicSTyyJI3/list');
  }

  Future<void> copyCollection(
      {required sourceCollection,
      required String destinationCollection}) async {
    try {
      // Get a reference to the source collection
      CollectionReference sourceRef =
          FirebaseFirestore.instance.collection(sourceCollection);

      // Get all documents from the source collection
      QuerySnapshot snapshot = await sourceRef.get();

      // Create a reference to the destination collection
      CollectionReference destinationRef =
          FirebaseFirestore.instance.collection(destinationCollection);

      // Loop through each document in the source collection and copy it to the destination collection
      for (DocumentSnapshot doc in snapshot.docs) {
        await destinationRef.doc(doc.id).set(doc.data());
      }

      print('Collection copied successfully!');
    } catch (e) {
      print('Error copying collection: $e');
    }
  }

  Future<void> copyDocument(
      {required sourceCollection,
      required String sourceDocumentId,
      required String destinationCollection,
      required String destinationDocumentId}) async {
    try {
      // Get a reference to the source document
      DocumentReference sourceRef = FirebaseFirestore.instance
          .collection(sourceCollection)
          .doc(sourceDocumentId);

      // Get the document data from the source document
      DocumentSnapshot snapshot = await sourceRef.get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      // Create a reference to the destination collection and set the data in a new document
      DocumentReference destinationRef = FirebaseFirestore.instance
          .collection(destinationCollection)
          .doc(destinationDocumentId);
      await destinationRef.set(data, SetOptions(merge: true));

      print('Document copied successfully!');
    } catch (e) {
      print('Error copying document: $e');
    }
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
