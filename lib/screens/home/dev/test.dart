// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigator.push(
        //     context, CupertinoPageRoute(builder: (context) => MyHomePage()));
      },
      child: Text("maps"),
    );
  }
}
