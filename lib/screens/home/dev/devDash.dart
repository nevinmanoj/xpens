import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:xpens/screens/home/dev/deleteAllX.dart';
import 'package:xpens/screens/home/dev/injectData.dart';
import 'package:xpens/shared/constants.dart';

class DevDash extends StatefulWidget {
  const DevDash({super.key});

  @override
  State<DevDash> createState() => _DevDashState();
}

class _DevDashState extends State<DevDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
        centerTitle: true,
        title: Text("Dev Dashboard"),
      ),
      body: Center(child: Column(children: [InjectTestData(), DeleteAllX()])),
    );
  }
}
