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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: Text("Dev Dashboard"),
      ),
      body: Center(
          child: Column(children: [
        InjectTestData(),
        // Test(1),
        ElevatedButton(
            style: buttonDecoration,
            onPressed: () async {
              await DevService().switchAc();
            },
            child: Text("Switch to $ac")),
      ])),
    );
  }
}
