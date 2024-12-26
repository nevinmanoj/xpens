// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/appUpdate.dart';

import 'package:xpens/shared/constants.dart';

import '../../../../services/devServices.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import 'injectData.dart';
import 'test.dart';

class DevDash extends StatefulWidget {
  const DevDash({super.key});

  @override
  State<DevDash> createState() => _DevDashState();
}

class _DevDashState extends State<DevDash> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    // double wt = MediaQuery.of(context).size.width;
    // double ht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: Text("Dev Dashboard"),
      ),
      body: Center(
          child: Column(children: [
        InjectTestData(),
        Test(),
        ElevatedButton(
            style: buttonDecoration,
            onPressed: () async {
              await AppUpdater.checkAndUpdate();
            },
            child: Text(
              "update app",
              style: TextStyle(color: Colors.white),
            )),
        ElevatedButton(
            style: buttonDecoration,
            onPressed: () async {
              await DevService().modify();
            },
            child: Text(
              "Modify",
              style: TextStyle(color: Colors.white),
            )),
        ElevatedButton(
            style: buttonDecoration,
            onPressed: () async {
              userInfo.init();
            },
            child: Text("Reload")),
      ])),
    );
  }
}
