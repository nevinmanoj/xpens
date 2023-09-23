import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/shared/Db.dart';

class UserInfoProvider with ChangeNotifier {
  User? user;
  UserInfoProvider({required this.user}) {
    if (user != null) _init();
  }
  List _myArray = ["Other"];
  String _userName = "";
  String _phno = "";

  List get items => _myArray;
  String get userName => _userName;
  String get phone => _phno;
  void setUser(User? usr) {
    print("switching user to ${usr!.email} from ${user!.email}");
    user = usr;
    _init();
  }

  Future<void> _init() async {
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection(db).doc(user!.uid);

      docRef.snapshots().listen((snapshot) {
        print("new data...");
        if (snapshot.exists) {
          _myArray = List.from(snapshot.data()!['items']);
          _userName = snapshot.data()!['Name'];
          _phno = snapshot.data()!['PhoneNumber'];
        } else {
          _userName = "";
          _myArray = ["Other"];
          _phno = "";
        }
        notifyListeners();
      });
    }
  }
}
