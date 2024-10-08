import 'package:flutter/material.dart';

class AddItem {
  double? cost;
  String itemName;
  DateTime date;
  TimeOfDay time;
  String? remarks;
  String location;
  bool? isOther;
  String group;
  AddItem(
      {this.cost,
      this.remarks,
      required this.location,
      required this.date,
      required this.itemName,
      this.isOther,
      required this.time,
      required this.group});
}
