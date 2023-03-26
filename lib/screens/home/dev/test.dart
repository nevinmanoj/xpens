// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xpens/shared/constants.dart';

class Test extends StatefulWidget {
  int count;
  Test(this.count);
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.count.toString()),
        ElevatedButton(
            onPressed: () {
              setState(() {
                widget.count--;
              });
            },
            child: Text("reset")),
        ElevatedButton(
            onPressed: () {
              setState(() {
                widget.count++;
              });
            },
            child: Text("press"))
      ],
    );
  }
}
