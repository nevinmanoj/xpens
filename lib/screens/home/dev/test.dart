// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xpens/shared/constants.dart';
import 'package:skeletons/skeletons.dart';

class Test extends StatefulWidget {
  DateTime x = DateTime.now();

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}
