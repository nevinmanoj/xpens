import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/dataModals/AddItemModal.dart';
import '../shared/dataModals/AddPointModal.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  Future updateUserInfo(String label, var data) async {
    return await FirebaseFirestore.instance.collection(db).doc(uid).set({
      label: data,
    }, SetOptions(merge: true));
  }

  Future createRequiredArrays() async {
    await FirebaseFirestore.instance.collection(db).doc(uid).set({
      'cards': ["Other"],
    }, SetOptions(merge: true));
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

  Future updateItemsArray({
    required bool add,
    required String item,
  }) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('$db/$uid/list')
        .where("itemName", isEqualTo: item)
        .get();
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('$db/$uid/list').doc(doc.id);
      docRef.update({'isOther': !add});
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
    final List<String> tags =
        I.itemName.split(' ').map((word) => word.toLowerCase()).toList();
    try {
      await FirebaseFirestore.instance
          .collection('$db/$uid/list')
          .doc(key)
          .set({
        "tags": tags,
        "isTrash": false,
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

  // Future deleteItem(String id) async {
  //   FirebaseFirestore.instance.collection('$db/$uid/list').doc(id).delete();
  // }

  Future<bool> editItem({required AddItem I, required String id}) async {
    String year = I.date.year.toString();

    String month = DateFormat.MMM().format(I.date).toString();
    String day = I.date.day.toString();
    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));
    I.date = DateTime(
        I.date.year, I.date.month, I.date.day, I.time.hour, I.time.minute);
    final List<String> tags =
        I.itemName.split(' ').map((word) => word.toLowerCase()).toList();
    try {
      await FirebaseFirestore.instance.collection('$db/$uid/list').doc(id).set({
        "tags": tags,
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

  Future<bool> addPointSpent(AddPoint I) async {
    String year = I.date.year.toString();
    String day = I.date.day.toString();
    String key = DateTime.now().toString();
    String month = DateFormat.MMM().format(I.date).toString();
    I.date = DateTime(
        I.date.year, I.date.month, I.date.day, I.time.hour, I.time.minute);
    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));
    final List<String> tags =
        I.itemName.split(' ').map((word) => word.toLowerCase()).toList();
    try {
      await FirebaseFirestore.instance
          .collection('$db/$uid/points')
          .doc(key)
          .set({
        "cardName": I.card,
        "isTrash": false,
        "tags": tags,
        "month": month,
        "year": year,
        "day": day,
        "points": I.point,
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

  Future deletePointSpent(String id) async {
    FirebaseFirestore.instance.collection('$db/$uid/points').doc(id).delete();
  }

  Future<bool> editPointsSpent(
      {required AddPoint I, required String id}) async {
    String year = I.date.year.toString();

    String month = DateFormat.MMM().format(I.date).toString();
    String day = I.date.day.toString();
    String formattedTime = DateFormat('HH:mm')
        .format(DateTime(0, 0, 0, I.time.hour, I.time.minute));
    I.date = DateTime(
        I.date.year, I.date.month, I.date.day, I.time.hour, I.time.minute);
    final List<String> tags =
        I.itemName.split(' ').map((word) => word.toLowerCase()).toList();
    try {
      await FirebaseFirestore.instance
          .collection('$db/$uid/points')
          .doc(id)
          .set({
        "tags": tags,
        "month": month,
        "year": year,
        "points": I.point,
        "day": day,
        "date": I.date.toString(),
        "time": formattedTime,
        "itemName": I.itemName,
        "cardName": I.card
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
      return false;
    }

    return true;
  }

  Future updateCardsArray({
    required bool add,
    required String card,
  }) async {
    if (add) {
      //add item
      return await FirebaseFirestore.instance.collection(db).doc(uid).update({
        "cards": FieldValue.arrayUnion([card]),
      });
    } else {
      //delete item
      return await FirebaseFirestore.instance.collection(db).doc(uid).update({
        "cards": FieldValue.arrayRemove([card])
      });
    }
  }

  Future moveToTrash({required String id, required String type}) async {
    String collection = "";
    if (type == "expense") {
      collection = "list";
    } else if (type == "points") {
      collection = "points";
    }
    String date = DateTime.now().toString();
    if (collection != "") {
      try {
        await FirebaseFirestore.instance
            .collection('$db/$uid/$collection')
            .doc(id)
            .set(
                {"isTrash": true, "deleteDate": date}, SetOptions(merge: true));
      } catch (e) {
        print(e.toString());
        return false;
      }
    }
  }

  Future permaDelete({required id, required type}) async {
    String collection = "";
    type = type.toLowerCase();
    if (type == "expense") {
      collection = "list";
    } else if (type == "points") {
      collection = "points";
    }
    if (collection != "") {
      try {
        FirebaseFirestore.instance
            .collection('$db/$uid/$collection')
            .doc(id)
            .delete();
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future restore({required String id, required String type}) async {
    type = type.toLowerCase();
    String collection = "";
    if (type == "expense") {
      collection = "list";
    } else if (type == "points") {
      collection = "points";
    }
    if (collection != "") {
      try {
        await FirebaseFirestore.instance
            .collection('$db/$uid/$collection')
            .doc(id)
            .set({"isTrash": false}, SetOptions(merge: true));
      } catch (e) {
        print(e.toString());
        return false;
      }
    }
  }
}
