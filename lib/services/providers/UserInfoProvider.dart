import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/shared/Db.dart';

class UserInfoProvider with ChangeNotifier {
  User? user;
  UserInfoProvider({required this.user}) {
    if (user != null) _init();
  }
  String option = "Expenses";

  List _cards = ["Other"];
  List _myArray = ["Other"];
  String _userName = "";
  String _phno = "";
  List _pointDocs = [];
  List _docs = [];
  List _eTrash = [];
  List _pTrash = [];
  bool _dev = false;

  List get eTrash => _eTrash;
  List get pTrash => _pTrash;
  List get cards => _cards;
  bool get isDev => _dev;
  List get docs => _docs;
  List get pointDocs => _pointDocs;
  List get items => _myArray;
  String get userName => _userName;
  String get phone => _phno;
  void setUser(User? usr) {
    // print("switching user to ${usr!.email} from ${user!.email}");
    user = usr;
    _init();
  }

  void setOption(v) {
    option = v;
    notifyListeners();
  }

  void _init() {
    _fetchUserInfo();
    _fetchExpenses();
    _fetchPoints();
  }

  Future<void> _fetchUserInfo() async {
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection(db).doc(user!.uid);

      docRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          _myArray = List.from(snapshot.data()!['items']);
          _userName = snapshot.data()!['Name'];
          _phno = snapshot.data()!['PhoneNumber'];
          _dev = snapshot.data()!['isDev'];
          _cards = List.from(snapshot.data()!['cards']);
          _cards.remove("Other");
          _cards.add("Other");
          _myArray.remove("Other");
          _myArray.add("Other");
        } else {
          _userName = "";
          _myArray = ["Other"];
          _phno = "";
          _cards = ["Other"];
        }

        notifyListeners();
      });
    }
  }

  Future<void> _fetchExpenses() async {
    if (user != null) {
      final colRef = FirebaseFirestore.instance
          .collection("$db/${user!.uid}/list")
          .orderBy("date", descending: true);

      colRef.snapshots().listen((snapshot) {
        _docs = snapshot.docs.where((item) {
          return item['isTrash'] == false;
        }).toList();
        _eTrash = snapshot.docs.where((item) {
          return item['isTrash'] == true;
        }).toList();
        notifyListeners();
      });
    }
  }

  Future<void> _fetchPoints() async {
    if (user != null) {
      final colRef = FirebaseFirestore.instance
          .collection("$db/${user!.uid}/points")
          .orderBy("date", descending: true);

      colRef.snapshots().listen((snapshot) {
        
         _pointDocs = snapshot.docs.where((item) {
          return item['isTrash'] == false;
        }).toList();
        _pTrash = snapshot.docs.where((item) {
          return item['isTrash'] == true;
        }).toList();
        notifyListeners();
      });
    }
  }
}
