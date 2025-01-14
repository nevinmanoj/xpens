import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xpens/services/milesstoneDatabase.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/dataModals/subModals/PeriodDates.dart';
import 'package:xpens/shared/utils/getDateTimesFromPeriod.dart';

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
  List _milestoneTemplatesDocs = [];
  List _milestoneDocs = [];
  List _streakDocs = [];
  //TODO: input and handle this to firebase
  String milestoneSyncDate = "";

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
  List get milestones => _milestoneDocs;
  List get milestoneTemplates => _milestoneTemplatesDocs;
  List get streaks => _streakDocs;

  bool msrunning = false;
  bool msurunning = false;

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
    _fetchmilestoneTemplates();
    _fetchmilestones();
    // _addUpcomingMilestonesForAllTemplates();
    // _checkActiveOrClosedMilestonesExistForAllTemplates();
    getmstandcheckforms();
    getStreaks();

    // _addUpcomingMilestonesForAllTemplates();
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

  Future<void> _fetchmilestones() async {
    if (user != null) {
      try {
        final colRef = FirebaseFirestore.instance
            .collection("$db/${user!.uid}/milestones")
            .orderBy("endDate", descending: false);
        colRef.snapshots().listen((event) {
          _milestoneDocs = event.docs;

          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _fetchmilestoneTemplates() async {
    if (user != null) {
      try {
        final colRef = FirebaseFirestore.instance
            .collection("$db/${user!.uid}/milestone-templates")
            .orderBy("addedDate", descending: true);
        colRef.snapshots().listen((event) async {
          _milestoneTemplatesDocs = event.docs;
          // _checkActiveOrClosedMilestonesExistForAllTemplates();
          getmstandcheckforms();
          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future _checkMilestonesForAllTemplates(
      {required List msdata, required List mstdata}) async {
    int today = DateTime.now().millisecondsSinceEpoch;
    if (!msurunning) {
      msurunning = true;
      if (user != null) {
        //change expired to closed
        try {
          List expiredMsList =
              msdata.where((item) => today > item["endDate"]).toList();
          for (var expms in expiredMsList) {
            Milestone ms = Milestone.fromJson(expms);
            ms.currentStatus = Status.closed;

            await MilestoneDatabaseService(uid: user!.uid).editMilestone(
              item: ms,
            );
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        msdata = await FirebaseFirestore.instance
            .collection("$db/${user!.uid}/milestones")
            .get()
            .then((value) => value.docs);

        //closed or active
        try {
          for (var mst in mstdata) {
            DateRange firstDateRange = getDateTimesFromPeriod(
                date: DateTime.fromMillisecondsSinceEpoch(mst["addedDate"]),
                p: deserializePeriod(mst["period"]),
                isNextPeriod: false);
            if (mst["skipFirst"] &&
                (today > firstDateRange.startDate.millisecondsSinceEpoch) &&
                (today <= firstDateRange.endDate.millisecondsSinceEpoch)) {
              continue;
            }

            List ms = msdata.where((item) {
              return (mst.id == item["templateID"] &&
                  (today > item["startDate"]) &&
                  (today <= item["endDate"]));
            }).toList();
            if (ms.isEmpty) {
              await MilestoneDatabaseService(uid: user!.uid).addMilestone(
                  template: MilestoneTemplate.fromJson(mst),
                  skipCurrent: false,
                  templateID: mst.id);
              msdata = await FirebaseFirestore.instance
                  .collection("$db/${user!.uid}/milestones")
                  .get()
                  .then((value) => value.docs);
              continue;
            }

            var upcomingItem = ms.firstWhereOrNull(
                (item) => (item["currentStatus"] == "upcoming"));
            if (upcomingItem != null) {
              Milestone ms = Milestone.fromJson(upcomingItem);

              ms.currentStatus = Status.active;
              await MilestoneDatabaseService(uid: user!.uid)
                  .editMilestone(item: ms);
              msdata = await FirebaseFirestore.instance
                  .collection("$db/${user!.uid}/milestones")
                  .get()
                  .then((value) => value.docs);
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
        //upcomming
        try {
          for (var mst in mstdata) {
            DateRange currentDateRange = getDateTimesFromPeriod(
                date: DateTime.now(),
                p: deserializePeriod(mst["period"]),
                isNextPeriod: false);
            DateRange nextDateRange = getDateTimesFromPeriod(
                date: DateTime.now(),
                p: deserializePeriod(mst["period"]),
                isNextPeriod: true);
            //for { quarter, halfYear, year } before 7 days,
            //for { monthly } before 4 days
            //for { weekly } before 2 days
            //for { daily } before 1 day
            Duration daysBefore = Duration();

            switch (deserializePeriod(mst["period"])) {
              //using fall down method for first three
              case Period.quarter:
              case Period.halfYear:
              case Period.year:
                daysBefore = const Duration(days: 7);
                break;
              case Period.daily:
                daysBefore = const Duration(days: 1);
                break;
              case Period.weekly:
                daysBefore = const Duration(days: 2);
                break;
              case Period.monthly:
                daysBefore = const Duration(days: 4);
                break;
            }
            if (today >
                currentDateRange.endDate
                    .subtract(daysBefore)
                    .millisecondsSinceEpoch) {
              //current time is past the period
              List ms = msdata.where((item) {
                return (mst.id == item["templateID"] &&
                    (item["currentStatus"] == "upcoming") &&
                    (nextDateRange.startDate.millisecondsSinceEpoch ==
                        item["startDate"]) &&
                    (nextDateRange.endDate.millisecondsSinceEpoch ==
                        item["endDate"]));
              }).toList();
              if (ms.isEmpty) {
                await MilestoneDatabaseService(uid: user!.uid).addMilestone(
                    template: MilestoneTemplate.fromJson(mst),
                    skipCurrent: true,
                    templateID: mst.id);

                msdata = await FirebaseFirestore.instance
                    .collection("$db/${user!.uid}/milestones")
                    .get()
                    .then((value) => value.docs);
              }
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      msurunning = false;
    }
  }

  Future getmstandcheckforms() async {
    final List ms = await FirebaseFirestore.instance
        .collection("$db/${user!.uid}/milestones")
        .get()
        .then((value) => value.docs);
    final List mst = await FirebaseFirestore.instance
        .collection("$db/${user!.uid}/milestone-templates")
        .get()
        .then((value) => value.docs);

    await _checkMilestonesForAllTemplates(msdata: ms, mstdata: mst);
  }

  Future getStreaks() async {
    if (user != null) {
      try {
        final colRef =
            FirebaseFirestore.instance.collection("$db/${user!.uid}/streaks");
        colRef.snapshots().listen((event) {
          _streakDocs = event.docs;

          notifyListeners();
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
