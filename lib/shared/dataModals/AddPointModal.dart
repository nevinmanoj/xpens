import 'package:flutter/material.dart';

class AddPoint {
  double point;
  String card;
  String itemName;
  DateTime date;
  TimeOfDay time;
  AddPoint(
      {required this.card,
      required this.date,
      required this.time,
      required this.itemName,
      required this.point});
}
