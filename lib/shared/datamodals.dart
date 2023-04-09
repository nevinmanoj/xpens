import 'package:flutter/material.dart';

class AddItem {
  double cost;
  String itemName;
  DateTime date;
  TimeOfDay time;
  String remarks;
  String location;
  AddItem(
      {required this.cost,
      required this.remarks,
      required this.location,
      required this.date,
      required this.itemName,
      required this.time});
}

class Expense {
  String key;
  Map<String, dynamic> data;
  Expense({required this.key, required this.data});
}
