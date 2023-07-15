// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xpens/screens/home/add/addInputs.dart';
import 'package:xpens/screens/home/add/welcome.dart';

class AddX extends StatefulWidget {
  @override
  State<AddX> createState() => _AddXState();
}

class _AddXState extends State<AddX> {
  // DateTime currentPhoneDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          Welcome(),
          SizedBox(
            height: ht * 0.1,
          ),
          AddxInputs()
        ],
      ),
    );
  }
}
