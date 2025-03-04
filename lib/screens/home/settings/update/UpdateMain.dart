// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/update/updateAvailable.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

class UpdateMain extends StatefulWidget {
  const UpdateMain({super.key});

  @override
  State<UpdateMain> createState() => _UpdateMainState();
}

class _UpdateMainState extends State<UpdateMain> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    String currentVersion = userInfo.currentVersion;
    bool ua = userInfo.updateAvailable;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: ua
          ? updateAvailable()
          : Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/release.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'V$currentVersion',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () => userInfo.checkForUpdate(),
                      child: Text("Check for updates",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )))
                ],
              )),
    );
  }
}
