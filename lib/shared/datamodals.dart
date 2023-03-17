import 'package:flutter/material.dart';

class Item {
  double cost;
  String itemName;
  DateTime date;
  TimeOfDay time;
  String remarks;
  Item(
      {required this.cost,
      required this.remarks,
      required this.date,
      required this.itemName,
      required this.time});
}
