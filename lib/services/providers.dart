import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoProvider with ChangeNotifier {
  User? user;
  UserInfoProvider({required this.user}) {
    _init();
  }
  List<String> _myArray = ["Other"];
  String _userName = "";

  List<String> get items => _myArray;
  String get userName => _userName;

  // StreamController<UserInfoProvider> _controller = StreamController();
  // Stream<UserInfoProvider> get stream => _controller.stream;

  Future<void> _init() async {
    // FirebaseAuth _auth = FirebaseAuth.instance;
    // User? user = _auth.currentUser;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('UserInfo').doc(user!.uid);

      docRef.snapshots().listen((snapshot) {
        print("new data...");
        if (snapshot.exists) {
          _myArray = List.from(snapshot.data()!['items']);
          _userName = snapshot.data()!['Name'];

          // _controller.add(this);
        } else {
          _userName = "";
          _myArray = ["Other"];
        }
        notifyListeners();
      });
    }
  }
}
