import 'package:flutter/material.dart';

class Item {
  double cost;
  String itemName;
  DateTime date;
  TimeOfDay time;
  Item(
      {required this.cost,
      required this.date,
      required this.itemName,
      required this.time});
}
