// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:xpens/screens/home/dev/injectData.dart';
import 'package:xpens/screens/home/dev/devServices.dart';
import 'package:xpens/shared/constants.dart';

import 'test.dart';

class DevDash extends StatefulWidget {
  const DevDash({super.key});

  @override
  State<DevDash> createState() => _DevDashState();
}

class _DevDashState extends State<DevDash> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: Text("Dev Dashboard"),
      ),
      body: Center(
          child: Column(children: [
        InjectTestData(),
        ElevatedButton(
            style: buttonDecoration,
            onPressed: () async {
              await DevService().switchAc();
            },
            child: Text("Switch to dev")),
        Test(),
        ElevatedButton(
            style: buttonDecoration,
            onPressed: () async {
              await DevService().modify();
            },
            child: Text("modify")),
      ])),
    );
  }
}
