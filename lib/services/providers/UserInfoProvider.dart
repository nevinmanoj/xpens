import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/constants.dart';

class UserInfoProvider with ChangeNotifier {
  User? user;
  UserInfoProvider({required this.user}) {
    if (user != null) init();
  }
  String option = inputTypes[0];

  List _defaults = [];
  List _cards = ["Other"];
  List _myArray = ["Other"];
  String _userName = "";
  String _phno = "";
  List _pointDocs = [];
  List _docs = [];
  List _eTrash = [];
  List _pTrash = [];
  int _highestStreak = 0;
  bool _dev = false;
  DateTime? _streakDate;

  List get eTrash => _eTrash;
  List get defaults => _defaults;
  List get pTrash => _pTrash;
  List get cards => _cards;
  bool get isDev => _dev;
  List get docs => _docs;
  List get pointDocs => _pointDocs;
  List get items => _myArray;
  String get userName => _userName;
  String get phone => _phno;
  DateTime? get streakDate => _streakDate;
  int get highestStreak => _highestStreak;
  void setUser(User? usr) {
    // print("switching user to ${usr!.email} from ${user!.email}");
    user = usr;
    init();
  }

  void setOption(v) {
    option = v;
    notifyListeners();
  }

  void init() {
    _fetchUserInfo();
    _fetchExpenses();
    _fetchPoints();
    _fetchDefaults();
  }

  Future<void> _fetchUserInfo() async {
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection(db).doc(user!.uid);

      try {
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
            if (snapshot.data()!['streakDate'] != "") {
              _streakDate = DateTime.parse(snapshot.data()!['streakDate']);
            } else {
              _streakDate = null;
            }
            _highestStreak = snapshot.data()!['highestStreak'];
          } else {
            _dev = false;
            _userName = "";
            _myArray = ["Other"];
            _phno = "";
            _cards = ["Other"];
            _streakDate = null;
            _highestStreak = 0;
          }

          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _fetchExpenses() async {
    if (user != null) {
      try {
        final colRef = FirebaseFirestore.instance
            .collection("$db/${user!.uid}/list")
            .where("isTrash", isEqualTo: false)
            .orderBy("date", descending: true);
        colRef.snapshots().listen((event) {
          // print("fetching expense");
          _docs = event.docs;

          notifyListeners();
        });
        // zWxHz89t7qc1KhfSOhhicSTyyJI3 nevin
        final trashcolRef = FirebaseFirestore.instance
            .collection("$db/${user!.uid}/list")
            .where("isTrash", isEqualTo: true)
            .orderBy("date", descending: true);
        trashcolRef.snapshots().listen((event) {
          // print("fetching expense trash");
          _eTrash = event.docs;
          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _fetchPoints() async {
    if (user != null) {
      try {
        final colRef = FirebaseFirestore.instance
            .collection("$db/${user!.uid}/points")
            .where("isTrash", isEqualTo: false)
            .orderBy("date", descending: true);
        colRef.snapshots().listen((event) {
          // print("fetching expense");
          _pointDocs = event.docs;
          notifyListeners();
        });
        // zWxHz89t7qc1KhfSOhhicSTyyJI3 nevin
        final trashcolRef = FirebaseFirestore.instance
            .collection("$db/${user!.uid}/points")
            .where("isTrash", isEqualTo: true)
            .orderBy("date", descending: true);
        trashcolRef.snapshots().listen((event) {
          // print("fetching expense trash");
          _pTrash = event.docs;
          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _fetchDefaults() async {
    if (user != null) {
      try {
        final colRef =
            FirebaseFirestore.instance.collection("$db/${user!.uid}/defaults");
        colRef.snapshots().listen((event) {
          // print("fetching expense");
          _defaults = event.docs;
          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
