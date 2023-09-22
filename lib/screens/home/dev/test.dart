// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ElevatedButton(
            onPressed: () async {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => MapTest()));
            },
            child: Text("test")),
      ],
    );
  }
}
