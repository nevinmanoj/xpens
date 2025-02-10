import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/dataModals/dbModals/streakModal.dart';

class StreakDatabaseService {
  final String uid;
  StreakDatabaseService({required this.uid});

  Future addStreak({required Streak s}) async {
    await FirebaseFirestore.instance
        .collection("$db/$uid/streaks")
        .add(s.toJson());
  }

  Future editStreakProperty(
      {required String key,
      required dynamic value,
      required String selfId}) async {
    await FirebaseFirestore.instance
        .collection("$db/$uid/streaks")
        .doc(selfId)
        .update({
      key: value,
    });
  }

  Future markDate({required String selfId, required DateTime day}) async {
    DateTime dateOnly = DateTime(
      day.year,
      day.month,
      day.day,
    );
    await FirebaseFirestore.instance
        .collection("$db/$uid/streaks")
        .doc(selfId)
        .update({
      "list": FieldValue.arrayUnion([dateOnly.toString()]),
    });
  }

  Future unmarkDate({required String selfId, required DateTime day}) async {
    DateTime dateOnly = DateTime(
      day.year,
      day.month,
      day.day,
    );
    await FirebaseFirestore.instance
        .collection("$db/$uid/streaks")
        .doc(selfId)
        .update({
      "list": FieldValue.arrayRemove([dateOnly.toString()]),
    });
  }

  Future deleteStreak({required String selfId}) async {
    await FirebaseFirestore.instance
        .collection("$db/$uid/streaks")
        .doc(selfId)
        .delete();
  }
}
