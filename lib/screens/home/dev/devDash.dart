import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:xpens/screens/home/dev/injectData.dart';
import 'package:xpens/services/dev.dart';
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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String ac = user!.email == "nevinmanojnew@gmail.com" ? "Main" : "Dev";
    Map<DateTime, double> events = {
      DateTime(2023, 3, 19): 522,
      DateTime(2023, 3, 20): 331,
      DateTime(2023, 3, 21): 700,
      DateTime(2023, 3, 22): 10000,
      DateTime(2023, 3, 23): 1,
      DateTime(2023, 3, 15): 144,
      DateTime(2023, 3, 14): 123,
    };
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
            child: Text("Switch to $ac")),
        CalendarWidget(events: events),
      ])),
    );
  }
}
