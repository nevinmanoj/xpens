import 'package:flutter/material.dart';

class AddPoint {
  double point;
  String sourceId;
  String cardName;
  String itemName;
  DateTime date;
  TimeOfDay time;
  AddPoint(
      {required this.sourceId,
      required this.date,
      required this.cardName,
      required this.time,
      required this.itemName,
      required this.point});
}
