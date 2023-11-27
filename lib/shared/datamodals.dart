import 'package:flutter/material.dart';

class AddItem {
  double cost;
  String itemName;
  DateTime date;
  TimeOfDay time;
  String remarks;
  String location;
  bool isOther;
  String group;
  AddItem(
      {required this.cost,
      required this.remarks,
      required this.location,
      required this.date,
      required this.itemName,
      required this.isOther,
      required this.time,
      required this.group});
}

class Expense {
  String key;
  Map<String, dynamic> data;
  Expense({required this.key, required this.data});
}

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
