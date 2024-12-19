import 'package:flutter/material.dart';

class ExpenseDefault {
  double? cost;
  String? itemName;
  DateTime? date;
  TimeOfDay? time;
  String? remarks;
  String? location;
  bool? isOther;
  String? group;
  ExpenseDefault(
      {this.cost,
      this.remarks,
      required this.location,
      required this.date,
      required this.itemName,
      this.isOther,
      required this.time,
      required this.group});
}
