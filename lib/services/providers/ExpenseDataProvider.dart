import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/Db.dart';

class ExpenseDataProvider with ChangeNotifier {
  User user;
  // late Query _query;
  ExpenseDataProvider({required this.user}) {
    // _query = FirebaseFirestore.instance
    //     .collection("$db/${user.uid}/list")
    //     .orderBy("date", descending: true);

    _init();
  }
  // void setQuery(query) {
  //   _query = query;
  //   notifyListeners();
  // }

  List docs = [];
  Future<void> _init() async {
    // final colRef = _query;
    final colRef = FirebaseFirestore.instance
        .collection("$db/${user.uid}/list")
        .orderBy("date", descending: true);

    colRef.snapshots().listen((snapshot) {
      // print(snapshot.docs);
      docs = snapshot.docs;

      notifyListeners();
    });
  }
}
