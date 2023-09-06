import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:xpens/shared/Db.dart';
import '../shared/datamodals.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  Future updateUserInfo(String label, String data) async {
    return await FirebaseFirestore.instance.collection(db).doc(uid).set({
      label: data,
    }, SetOptions(merge: true));
  }

  Future createItemsArray() async {
    return await FirebaseFirestore.instance.collection(db).doc(uid).set({
      'items': [
        "Breakfast",
        "Lunch",
        "Dinner",
        "Tea and Snacks",
        "Petrol",
        "Icecream",
        "Other"
      ],
    }, SetOptions(merge: true));
  }

  Future updateItemsArray(
      {required bool add,
      required String item,
      required Function(double) progress}) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('$db/$uid/list')
        .where("itemName", isEqualTo: item)
        .get();
    double count = 0;
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('$db/$uid/list').doc(doc.id);
      docRef.update({'isOther': !add});

      count++;
      progress(count / snapshot.docs.length * 100);
    }
    if (add) {
      //add item
      return await FirebaseFirestore.instance.collection(db).doc(uid).update({
        "items": FieldValue.arrayUnion([item]),
      });
    } else {
      //delete item
      return await FirebaseFirestore.instance.collection(db).doc(uid).update({
        "items": FieldValue.arrayRemove([item])
      });
    }
  }

  Future<bool> addItem(AddItem I) async {
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
          .collection('$db/$uid/list')
          .doc(key)
          .set({
        "group": I.group,
        "month": month,
        "year": year,
        "day": day,
        "isOther": I.isOther,
        "remarks": I.remarks,
        "cost": I.cost,
        "date": I.date.toString(),
        "time": formattedTime,
        "location": I.location,
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
    FirebaseFirestore.instance.collection('$db/$uid/list').doc(id).delete();
  }

  Future<bool> editItem({required AddItem I, required String id}) async {
    String year = I.date.year.toString();

    String month = DateFormat.MMM().format(I.date).toString();
    String day = I.date.day.toString();
    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));
    I.date = DateTime(
        I.date.year, I.date.month, I.date.day, I.time.hour, I.time.minute);
    try {
      await FirebaseFirestore.instance.collection('$db/$uid/list').doc(id).set({
        "group": I.group,
        "month": month,
        "isOther": I.isOther,
        "year": year,
        "cost": I.cost,
        "remarks": I.remarks,
        "day": day,
        "date": I.date.toString(),
        "time": formattedTime,
        "itemName": I.itemName,
        "location": I.location
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }
}
